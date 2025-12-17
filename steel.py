import streamlit as st
import subprocess
import shutil
import re
from pathlib import Path
import pandas as pd
import numpy as np

# ==================================================
# Streamlit setup
# ==================================================
st.set_page_config(layout="wide")
st.title("Steel System Optimization (AMPL)")
st.caption("Optimization + fully tabularized results")

# ==================================================
# Paths
# ==================================================
BASE_DIR = Path(__file__).parent
PARAM_FILE = BASE_DIR / "parameters.mod"
USER_PARAM_FILE = BASE_DIR / "user_parameters.mod"
RUN_FILE = BASE_DIR / "run_ampl.run"
AMPL_OUTPUT_FILE = BASE_DIR / "ampl_output.txt"

# ==================================================
# Sanity checks
# ==================================================
if not PARAM_FILE.exists():
    st.error("Missing parameters.mod")
    st.stop()

AMPL_EXE = shutil.which("ampl")
if not AMPL_EXE:
    st.error("AMPL executable not found in PATH")
    st.stop()

# ==================================================
# Load DEFAULT parameters
# ==================================================
param_pattern = re.compile(
    r"^\s*param\s+(\w+)\s+default\s+([0-9.eE+-]+)\s*;",
    re.IGNORECASE
)

def load_defaults():
    params = {}
    with open(PARAM_FILE) as f:
        for line in f:
            m = param_pattern.match(line)
            if m:
                params[m.group(1)] = float(m.group(2))
    return params

params = load_defaults()
if not params:
    st.error("No parameters declared as `param x default v;`")
    st.stop()

H2_START_YEAR = int(params.get("h2_start_year", 2030))

# ==================================================
# Sidebar parameters
# ==================================================
st.sidebar.header("Model Parameters")
user_params = {
    k: st.sidebar.number_input(k, value=v, format="%.6f")
    for k, v in sorted(params.items())
}

# ==================================================
# Write override file
# ==================================================
def write_user_parameters(p):
    with open(USER_PARAM_FILE, "w") as f:
        for k, v in p.items():
            f.write(f"let {k} := {v};\n")

# ==================================================
# Write AMPL run file
# ==================================================
def write_run_file():
    with open(RUN_FILE, "w") as f:
        f.write(f"""
reset;
option log_file "{AMPL_OUTPUT_FILE.name}";
option log_flush 1;

include parameters.mod;
include user_parameters.mod;
include main.mod;
""")

# ==================================================
# Run optimization
# ==================================================
if st.button("Run Optimization", type="primary"):

    write_user_parameters(user_params)
    write_run_file()

    with st.spinner("Running AMPL optimization..."):
        subprocess.run([AMPL_EXE, RUN_FILE.name], cwd=BASE_DIR)

    if not AMPL_OUTPUT_FILE.exists():
        st.error("AMPL produced no output.")
        st.stop()

    st.success("Optimization completed")

    text = AMPL_OUTPUT_FILE.read_text(encoding="utf-8", errors="ignore")
    lines = text.splitlines()

    # ==================================================
    # COST PER TON (UNCHANGED – WORKING)
    # ==================================================
    cost_rows = []
    year = None
    bf = coal = ng = h2 = scrap = avg = np.nan

    for l in lines:
        if "Year" in l and "----" in l:
            year = int(re.findall(r"\d{4}", l)[0])
            bf = coal = ng = h2 = scrap = avg = np.nan

        if "BF-BOF steel:" in l:
            bf = float(re.findall(r"\$ *([\d.]+)", l)[0])
        if "Coal DRI–EAF steel:" in l:
            coal = float(re.findall(r"\$ *([\d.]+)", l)[0])
        if "NG DRI–EAF steel:" in l:
            ng = float(re.findall(r"\$ *([\d.]+)", l)[0])
        if "H2 DRI–EAF steel:" in l:
            h2 = float(re.findall(r"\$ *([\d.]+)", l)[0])
        if "Scrap–EAF steel:" in l:
            scrap = float(re.findall(r"\$ *([\d.]+)", l)[0])
        if "Average Cost:" in l:
            avg = float(re.findall(r"\$ *([\d.]+)", l)[0])
            cost_rows.append({
                "Year": year,
                "BF-BOF ($/t)": bf,
                "Coal DRI-EAF ($/t)": coal,
                "NG DRI-EAF ($/t)": ng,
                "H₂ DRI-EAF ($/t)": h2 if year >= H2_START_YEAR else np.nan,
                "Scrap-EAF ($/t)": scrap,
                "Average ($/t)": avg
            })

    df_cost = pd.DataFrame(cost_rows)

    st.subheader("Cost per ton of steel (2025–2050)")
    st.dataframe(
        df_cost.style.format("{:.2f}").background_gradient(cmap="Blues"),
        use_container_width=True
    )

    # ==================================================
    # EMISSIONS PER TON (TOTAL ROUTE ONLY – FIXED)
    # ==================================================
    emis_rows = []
    year = None
    bf = coal = ng = h2 = scrap = avg = np.nan

    for l in lines:
        if "Year" in l and "----" in l:
            year = int(re.findall(r"\d{4}", l)[0])
            bf = coal = ng = h2 = scrap = avg = np.nan

        if "BF-BOF Total per ton:" in l:
            bf = float(re.findall(r"([\d.]+)", l)[-1])
        if "Coal DRI-EAF Total per ton:" in l:
            coal = float(re.findall(r"([\d.]+)", l)[-1])
        if "NG DRI-EAF Total per ton:" in l:
            ng = float(re.findall(r"([\d.]+)", l)[-1])
        if "H2 DRI-EAF Total per ton:" in l:
            val = float(re.findall(r"([\d.]+)", l)[-1])
            h2 = val if year >= H2_START_YEAR else np.nan
        if "Scrap-EAF Total per ton:" in l:
            scrap = float(re.findall(r"([\d.]+)", l)[-1])
        if "Average System Emissions:" in l:
            avg = float(re.findall(r"([\d.]+)", l)[-1])
            emis_rows.append({
                "Year": year,
                "BF-BOF (tCO₂/t)": bf,
                "Coal DRI-EAF (tCO₂/t)": coal,
                "NG DRI-EAF (tCO₂/t)": ng,
                "H₂ DRI-EAF (tCO₂/t)": h2,
                "Scrap-EAF (tCO₂/t)": scrap,
                "Average (tCO₂/t)": avg
            })

    df_emis = pd.DataFrame(emis_rows)

    st.subheader("CO₂ emissions per ton of steel (2025–2050)")
    st.dataframe(
        df_emis.style.format("{:.3f}").background_gradient(cmap="Reds"),
        use_container_width=True
    )

    # ==================================================
    # PRODUCTION ROUTE (ROBUST PARSING – NO ERRORS)
    # ==================================================
    prod_rows = []
    capture = False

    for l in lines:
        if "YEAR" in l and "BF-BOF" in l:
            capture = True
            continue
        if capture and "CCS" in l:
            break
        if capture:
            parts = re.findall(r"(\d+|\d+/\d+\.\d+)", l)
            if len(parts) >= 7:
                try:
                    prod_rows.append({
                        "Year": int(parts[0]),
                        "BF-BOF (t)": float(parts[1].split("/")[0]),
                        "BF-BOF frac": float(parts[1].split("/")[1]),
                        "Coal DRI (t)": float(parts[2].split("/")[0]),
                        "Coal DRI frac": float(parts[2].split("/")[1]),
                        "NG DRI (t)": float(parts[3].split("/")[0]),
                        "NG DRI frac": float(parts[3].split("/")[1]),
                        "H₂ DRI (t)": float(parts[4].split("/")[0]),
                        "H₂ DRI frac": float(parts[4].split("/")[1]),
                        "Scrap-EAF (t)": float(parts[5].split("/")[0]),
                        "Scrap-EAF frac": float(parts[5].split("/")[1]),
                        "Total steel (t)": float(parts[6]),
                    })
                except:
                    pass

    df_prod = pd.DataFrame(prod_rows)

    st.subheader("Production route (tons & fractions)")
    st.dataframe(
        df_prod.style
        .format("{:.2f}", subset=[c for c in df_prod.columns if "frac" in c])
        .background_gradient(cmap="Greens"),
        use_container_width=True
    )

    # ==================================================
    # CARBON CAPTURE (ROBUST PARSING)
    # ==================================================
    ccs_rows = []

    for l in lines:
        parts = re.findall(r"(\d+|\d+/\d+\.\d+)", l)
        if len(parts) == 5:
            try:
                ccs_rows.append({
                    "Year": int(parts[0]),
                    "BF-BOF CCS (t)": float(parts[1].split("/")[0]),
                    "BF-BOF CCS frac": float(parts[1].split("/")[1]),
                    "Coal DRI CCS (t)": float(parts[2].split("/")[0]),
                    "Coal DRI CCS frac": float(parts[2].split("/")[1]),
                    "NG DRI CCS (t)": float(parts[3].split("/")[0]),
                    "NG DRI CCS frac": float(parts[3].split("/")[1]),
                    "Total CCS (t)": float(parts[4]),
                })
            except:
                pass

    df_ccs = pd.DataFrame(ccs_rows)

    st.subheader("Carbon capture requirement (tons & fractions)")
    st.dataframe(
        df_ccs.style
        .format("{:.2f}", subset=[c for c in df_ccs.columns if "frac" in c])
        .background_gradient(cmap="Purples"),
        use_container_width=True
    )
