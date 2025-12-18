import streamlit as st
import subprocess
import shutil
import re
from pathlib import Path
import pandas as pd
import numpy as np
import time

# ==================================================
# Streamlit Setup 
# ==================================================
st.set_page_config(
    layout="wide",
    page_title="Steel Sector Optimization System",
    page_icon="🏭"
)

# ==================================================
# Styling
# ==================================================
st.markdown("""
<style>
    /* Font and Typography */
    @import url('https://fonts.googleapis.com/css2?family=Source+Serif+Pro:wght@400;600;700&family=Source+Sans+Pro:wght@300;400;600&display=swap');
    
    * {
        font-family: 'Source Sans Pro', sans-serif;
    }
    
    h1, h2, h3, h4, .stTitle, .stHeader {
        font-family: 'Source Serif Pro', serif !important;
        font-weight: 600 !important;
        color: #2C3E50 !important;
        border-bottom: 2px solid #E8E8E8 !important;
        padding-bottom: 0.5rem !important;
    }
    
    h1 {
        color: #1A5276 !important;
        border-bottom: 3px solid #7D3C98 !important;
    }
    
    /* Sidebar Styling */
    section[data-testid="stSidebar"] {
        background-color: #F8F9FA !important;
        border-right: 2px solid #E8E8E8 !important;
    }
    
    section[data-testid="stSidebar"] .stHeader {
        color: #7D3C98 !important;
        border-bottom: 2px solid #D5D8DC !important;
    }
    
    /* Button Styling */
    .stButton > button {
        font-family: 'Source Serif Pro', serif !important;
        font-weight: 600 !important;
        background: linear-gradient(135deg, #7D3C98 0%, #2C3E50 100%) !important;
        color: white !important;
        border: none !important;
        border-radius: 4px !important;
        padding: 0.75rem 2rem !important;
        font-size: 1.1rem !important;
        transition: all 0.3s ease !important;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1) !important;
    }
    
    .stButton > button:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2) !important;
        background: linear-gradient(135deg, #6C3483 0%, #1C2833 100%) !important;
    }
    
    /* Progress Bar Styling */
    .stProgress > div > div > div {
        background: linear-gradient(90deg, #7D3C98 0%, #2C3E50 100%) !important;
        height: 8px !important;
        border-radius: 4px !important;
    }
    
    .stProgress > div > div {
        background-color: #E8E8E8 !important;
        border-radius: 4px !important;
        height: 8px !important;
    }
    
    /* Dataframe Styling */
    .dataframe {
        font-family: 'Source Sans Pro', sans-serif !important;
        border-collapse: collapse !important;
        width: 100% !important;
    }
    
    .dataframe th {
        background-color: #F2F3F4 !important;
        color: #2C3E50 !important;
        font-weight: 600 !important;
        text-align: left !important;
        padding: 12px !important;
        border-bottom: 2px solid #D5D8DC !important;
    }
    
    .dataframe td {
        padding: 10px !important;
        border-bottom: 1px solid #E8E8E8 !important;
    }
    
    .dataframe tr:hover {
        background-color: #F8F9FA !important;
    }
    
    /* Container and Layout */
    .main .block-container {
        padding-top: 2rem !important;
        max-width: 95% !important;
    }
    
    /* Parameter Inputs */
    .stNumberInput > div > div > input {
        border: 1px solid #D5D8DC !important;
        border-radius: 4px !important;
        padding: 8px 12px !important;
    }
    
    .stNumberInput > div > div > input:focus {
        border-color: #7D3C98 !important;
        box-shadow: 0 0 0 2px rgba(125, 60, 152, 0.2) !important;
    }
    
    /* Success/Error Messages */
    .stAlert {
        border-radius: 4px !important;
        border-left: 4px solid !important;
    }
</style>
""", unsafe_allow_html=True)

# ==================================================
# Paths
# ==================================================
BASE_DIR = Path(__file__).parent
PARAM_FILE = BASE_DIR / "default_params.mod"
USER_PARAM_FILE = BASE_DIR / "parameters.mod"
RUN_FILE = BASE_DIR / "run_ampl.run"
AMPL_OUTPUT_FILE = BASE_DIR / "ampl_output.txt"

# ==================================================
# Checks
# ==================================================
if not PARAM_FILE.exists():
    st.error("❌ **Critical Error**: `parameters.mod` file not found.")
    st.stop()

AMPL_EXE = shutil.which("ampl")
if not AMPL_EXE:
    st.error("❌ **AMPL Executable Missing**: Please ensure AMPL is installed and added to PATH.")
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
H2_START_YEAR = int(params.get("h2_start_year", 2030))

# ==================================================
# Sidebar Parameters 
# ==================================================
st.sidebar.markdown("""
<div style="padding: 1rem 0; border-bottom: 2px solid #D5D8DC;">
    <h2 style="color: #7D3C98; margin-bottom: 1rem;">📐 Model Parameters</h2>
    <p style="color: #5D6D7E; font-size: 0.9rem;">
        Adjust parameters below. Changes will override defaults.
    </p>
</div>
""", unsafe_allow_html=True)

# Organizing parameters 
user_params = {}
for k, v in sorted(params.items()):
    label = f"**{k}**"
    help_text = f"Default: {v:.6f}"
    user_params[k] = st.sidebar.number_input(
        label,
        value=v,
        format="%.6f",
        help=help_text,
        key=f"param_{k}"
    )

st.sidebar.markdown("---")
st.sidebar.markdown("""
<div style="color: #5D6D7E; font-size: 0.85rem; padding-top: 1rem;">
    <p><strong>Note:</strong> All values use scientific precision.</p>
</div>
""", unsafe_allow_html=True)

# ==================================================
# Override file
# ==================================================
def write_user_parameters(p):
    with open(USER_PARAM_FILE, "w") as f:
        for k, v in p.items():
            f.write(f"let {k} := {v};\n")

# ==================================================
# AMPL run file
# ==================================================
def write_run_file():
    with open(RUN_FILE, "w") as f:
        f.write(f"""
reset;
option log_file "{AMPL_OUTPUT_FILE.name}";
option log_flush 1;

include definitions.mod;
include main.mod;
""")

# ==================================================
# Main Title with Academic Touch
# ==================================================
st.markdown("""
<div style="text-align: center; margin-bottom: 2rem;">
    <h1 style="font-size: 2.5rem; margin-bottom: 0.5rem; color: #1A5276;">
        🏭 Steel Sector System Modeling
    </h1>
    <p style="font-size: 1.1rem; color: #5D6D7E; font-style: italic;">
        Advanced Multi-Period Linear Programming Optimization Platform
    </p>
</div>
""", unsafe_allow_html=True)

# ==================================================
# Optimization Execution Section
# ==================================================
st.markdown("---")
st.markdown("### Optimization Execution")

col1, col2 = st.columns([3, 1])
with col1:
    st.markdown("Configure parameters and initiate optimization process.")

if col2.button("▶️ Run Optimization", type="primary", use_container_width=True):
    
    # Create a progress bar
    progress_bar = st.progress(0)
    
    # Write parameter files
    write_user_parameters(user_params)
    write_run_file()
    
    # Start AMPL process
    process = subprocess.Popen(
        [AMPL_EXE, RUN_FILE.name],
        cwd=BASE_DIR,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    # Animate progress bar while AMPL runs
    progress = 0
    while process.poll() is None and progress < 90:
        progress = min(90, progress + 1)
        progress_bar.progress(progress)
        time.sleep(0.05)  # Smooth animation
    
    # Wait for completion
    stdout, stderr = process.communicate()
    
    # Complete the progress bar
    progress_bar.progress(100)
    time.sleep(0.3)  # Brief pause at 100%
    
    # Clear progress bar
    progress_bar.empty()
    
    # Check result
    if process.returncode == 0:
        st.success("✅ Optimization completed successfully!")
        
        # Read and process output
        text = AMPL_OUTPUT_FILE.read_text(encoding="utf-8", errors="ignore")
        lines = text.splitlines()
        
        # ==================================================
        # Display Optimization Results
        # ==================================================
        st.markdown("---")
        st.markdown("## 📊 Optimization Results")
        
        # Helper function for styled dataframes
        def create_styled_dataframe(df, title, color_scheme):
            st.markdown(f"### {title}")
            
            # Format numbers based on column type
            format_dict = {}
            for col in df.columns:
                if 'CO₂' in col or 'emiss' in col.lower() or col == 'Average (tCO₂/t)':
                    format_dict[col] = "{:.3f}"
                elif 'frac' in col.lower():
                    format_dict[col] = "{:.3f}"
                elif '$' in col:
                    format_dict[col] = "${:.2f}"
                elif ('(t)' in col or col == 'Total steel (t)' or col == 'Total CCS (t)') and 'frac' not in col.lower():
                    format_dict[col] = "{:,.0f}"
                elif 'Year' in col:
                    format_dict[col] = "{:.0f}"
                else:
                    format_dict[col] = "{:.2f}"
            
            # Apply styling
            styled_df = df.style.format(format_dict)
            
            # Apply gradient
            if color_scheme == "cost":
                cmap = "Blues"
            elif color_scheme == "emissions":
                cmap = "Reds_r"
            elif color_scheme == "production":
                cmap = "Greens"
            else:
                cmap = "Purples"
            
            # Don't apply gradient to Year column
            gradient_cols = [col for col in df.columns if col != "Year"]
            if gradient_cols:
                styled_df = styled_df.background_gradient(cmap=cmap, subset=gradient_cols)
            
            # Display dataframe
            st.dataframe(styled_df, use_container_width=True, height=400)
        
        # ==================================================
        # COST PER TON
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
                    "H₂ DRI-EAF ($/t)": h2,
                    "Scrap-EAF ($/t)": scrap,
                    "Average ($/t)": avg
                })
        
        if cost_rows:
            df_cost = pd.DataFrame(cost_rows)
            create_styled_dataframe(df_cost, "Cost per Ton of Steel (2025–2050)", "cost")
        
        # ==================================================
        # EMISSIONS PER TON
        # ==================================================
        emis_rows = []
        year = None
        bf = coal = ng = h2 = scrap = avg = np.nan
        
        for l in lines:
            if "Year" in l and "----" in l:
                year = int(re.findall(r"\d{4}", l)[0])
                bf = coal = ng = h2 = scrap = avg = np.nan
            
            if "BF-BOF Total per ton:" in l:
                bf = float(re.findall(r"([\d.]+)", l)[0])
            if "Coal DRI-EAF Total per ton:" in l:
                coal = float(re.findall(r"([\d.]+)", l)[0])
            if "NG DRI-EAF Total per ton:" in l:
                ng = float(re.findall(r"([\d.]+)", l)[0])
            if "H2 DRI-EAF Total per ton:" in l:
                m = re.search(r"H2 DRI-EAF Total per ton:\s*([\d.]+)", l)
                h2 = float(m.group(1)) if (m and year >= H2_START_YEAR) else np.nan
            if "Scrap-EAF Total per ton:" in l:
                scrap = float(re.findall(r"([\d.]+)", l)[0])
            if "Average System Emissions:" in l:
                avg = float(re.findall(r"([\d.]+)", l)[0])
                emis_rows.append({
                    "Year": year,
                    "BF-BOF (tCO₂/t)": bf,
                    "Coal DRI-EAF (tCO₂/t)": coal,
                    "NG DRI-EAF (tCO₂/t)": ng,
                    "H₂ DRI-EAF (tCO₂/t)": h2,
                    "Scrap-EAF (tCO₂/t)": scrap,
                    "Average (tCO₂/t)": avg
                })
        
        if emis_rows:
            df_emis = pd.DataFrame(emis_rows)
            st.markdown("### CO₂ Emissions per Ton of Steel (2025–2050)")
            
            # Apply specific formatting for emissions table
            emis_format_dict = {}
            for col in df_emis.columns:
                if col == "Year":
                    emis_format_dict[col] = "{:.0f}"
                else:
                    emis_format_dict[col] = "{:.3f}"
            
            styled_emis = df_emis.style.format(emis_format_dict)
            
            # Apply gradient
            gradient_cols = [col for col in df_emis.columns if col != "Year"]
            if gradient_cols:
                styled_emis = styled_emis.background_gradient(cmap="Reds_r", subset=gradient_cols)
            
            st.dataframe(styled_emis, use_container_width=True, height=400)
        
        # ==================================================
        # PRODUCTION ROUTE
        # ==================================================
        prod_rows = []
        
        for l in lines:
            if re.match(r"\d{4}\s", l):
                pairs = re.findall(r"(\d+(?:\.\d+)?)/\s*(-?\d+\.\d+)", l)
                total_match = re.search(r"\s(\d+)\s*$", l)
                
                if len(pairs) == 5 and total_match:
                    prod_rows.append({
                        "Year": int(l[:4]),
                        "BF-BOF (t)": float(pairs[0][0]),
                        "BF-BOF frac": float(pairs[0][1]),
                        "Coal DRI (t)": float(pairs[1][0]),
                        "Coal DRI frac": float(pairs[1][1]),
                        "NG DRI (t)": float(pairs[2][0]),
                        "NG DRI frac": float(pairs[2][1]),
                        "H₂ DRI (t)": float(pairs[3][0]),
                        "H₂ DRI frac": float(pairs[3][1]),
                        "Scrap-EAF (t)": float(pairs[4][0]),
                        "Scrap-EAF frac": float(pairs[4][1]),
                        "Total steel (t)": float(total_match.group(1)),
                    })
        
        if prod_rows:
            df_prod = pd.DataFrame(prod_rows)
            create_styled_dataframe(df_prod, "Production Route Distribution (Tons & Fractions)", "production")
        
        # ==================================================
        # CARBON CAPTURE
        # ==================================================
        ccs_rows = []
        
        for l in lines:
            if re.match(r"\d{4}\s", l):
                pairs = re.findall(r"(\d+(?:\.\d+)?)/\s*(-?\d+\.\d+)", l)
                total_match = re.search(r"\s(\d+)\s*$", l)
                
                if len(pairs) == 3 and total_match:
                    ccs_rows.append({
                        "Year": int(l[:4]),
                        "BF-BOF CCS (t)": float(pairs[0][0]),
                        "BF-BOF CCS frac": float(pairs[0][1]),
                        "Coal DRI CCS (t)": float(pairs[1][0]),
                        "Coal DRI CCS frac": float(pairs[1][1]),
                        "NG DRI CCS (t)": float(pairs[2][0]),
                        "NG DRI CCS frac": float(pairs[2][1]),
                        "Total CCS (t)": float(total_match.group(1)),
                    })
        
        if ccs_rows:
            df_ccs = pd.DataFrame(ccs_rows)
            create_styled_dataframe(df_ccs, "Carbon Capture Requirements (Tons & Fractions)", "ccs")
        
    else:
        st.error("❌ Optimization failed!")
        if stderr:
            with st.expander("Show error details"):
                st.code(stderr, language="text")
        st.stop()
        
else:
    st.info("👆 Click 'Run Optimization' to execute the model with current parameters.")
