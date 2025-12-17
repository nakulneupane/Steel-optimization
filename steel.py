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
st.caption("Run model → Automatically view all results")

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
        st.error("AMPL ran but produced no output.")
        st.stop()

    st.success("Optimization completed")

    text = AMPL_OUTPUT_FILE.read_text(encoding="utf-8", errors="ignore")
    lines = text.splitlines()

    # ==================================================
    # COST PER TON TABLE
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
                "Coal DRI ($/t)": coal,
                "NG DRI ($/t)": ng,
                "H₂ DRI ($/t)": h2,
                "Scrap EAF ($/t)": scrap,
                "Average ($/t)": avg
            })

    df_cost = pd.DataFrame(cost_rows)

    st.subheader("Cost per ton of steel (2025–2050)")
    st.dataframe(
        df_cost.style
        .format("{:.2f}")
        .background_gradient(cmap="Blues", axis=0),
        use_container_width=True
    )

    # ==================================================
    # EMISSIONS TABLE
    # ==================================================
    emis_rows = []
    year = scope1 = scope2 = total = None

    for l in lines:
        if "Year" in l and "----" in l:
            year = int(re.findall(r"\d{4}", l)[0])

        if "Average Scope-1 Emissions:" in l:
            scope1 = float(re.findall(r"([\d.]+)", l)[0])
        if "Average Scope-2 Emissions:" in l:
            scope2 = float(re.findall(r"([\d.]+)", l)[0])
        if "Average System Emissions:" in l:
            total = float(re.findall(r"([\d.]+)", l)[0])
            emis_rows.append({
                "Year": year,
                "Scope 1 (tCO₂/t)": scope1,
                "Scope 2 (tCO₂/t)": scope2,
                "Total (tCO₂/t)": total
            })

    df_emis = pd.DataFrame(emis_rows)

    st.subheader("CO₂ emissions per ton of steel (2025–2050)")
    st.dataframe(
        df_emis.style
        .format("{:.3f}")
        .background_gradient(cmap="Reds", axis=0),
        use_container_width=True
    )

    # ==================================================
    # PRODUCTION ROUTE TABLE
    # ==================================================
    prod_rows = []
    capture = False

    for l in lines:
        if "YEAR" in l and "BF-BOF" in l:
            capture = True
            continue
        if capture and ("CCS" in l or "TABLE 2" in l):
            break
        if capture:
            parts = l.split()
            if parts and parts[0].isdigit():
                prod_rows.append({
                    "Year": int(parts[0]),
                    "BF-BOF (t)": float(parts[1].split("/")[0]),
                    "Coal DRI (t)": float(parts[2].split("/")[0]),
                    "NG DRI (t)": float(parts[3].split("/")[0]),
                    "H₂ DRI (t)": float(parts[4].split("/")[0]),
                    "Scrap EAF (t)": float(parts[5].split("/")[0]),
                    "Total steel (t)": float(parts[6]),
                })

    df_prod = pd.DataFrame(prod_rows)

    st.subheader("Production route (tons)")
    st.dataframe(
        df_prod.style.background_gradient(cmap="Greens"),
        use_container_width=True
    )

    # ==================================================
    # CARBON CAPTURE TABLE
    # ==================================================
    ccs_rows = []

    for l in lines:
        parts = l.split()
        if parts and parts[0].isdigit() and "/" in l and "CCS" not in l:
            if len(parts) >= 5:
                ccs_rows.append({
                    "Year": int(parts[0]),
                    "BF-BOF CCS (t)": float(parts[1].split("/")[0]),
                    "Coal DRI CCS (t)": float(parts[2].split("/")[0]),
                    "NG DRI CCS (t)": float(parts[3].split("/")[0]),
                    "Total CCS (t)": float(parts[4]),
                })

    df_ccs = pd.DataFrame(ccs_rows)

    st.subheader("Carbon capture requirement (tons CO₂)")
    st.dataframe(
        df_ccs.style.background_gradient(cmap="Purples"),
        use_container_width=True
    )
