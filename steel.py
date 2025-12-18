import streamlit as st
import subprocess
import shutil
import re
from pathlib import Path
import pandas as pd
import numpy as np
import time

# ==================================================
# Streamlit Setup - MUST BE FIRST
# ==================================================
st.set_page_config(
    layout="wide",
    page_title="Steel Sector Optimization System",
    page_icon="🏭"
)

# ==================================================
# Custom CSS for Academic/Classical Styling
# ==================================================
st.markdown("""
<style>
    /* Your existing CSS here - keeping it short */
    .stProgress > div > div > div {
        background: linear-gradient(90deg, #7D3C98 0%, #2C3E50 100%) !important;
    }
</style>
""", unsafe_allow_html=True)

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

# Load default parameters
default_params = load_defaults()
H2_START_YEAR = int(default_params.get("h2_start_year", 2030))

# ==================================================
# Sidebar Parameters
# ==================================================
st.sidebar.header("📐 Model Parameters")

# Initialize session state for user parameters
if 'user_params' not in st.session_state:
    st.session_state.user_params = default_params.copy()

# Store current parameter values before creating inputs
current_params = {}

# Create sidebar inputs
for k in sorted(default_params.keys()):
    default_val = default_params[k]
    current_val = st.session_state.user_params.get(k, default_val)
    
    # Store the input value
    current_params[k] = st.sidebar.number_input(
        f"**{k}**",
        value=float(current_val),
        format="%.6f",
        help=f"Default: {default_val:.6f}",
        key=f"sidebar_param_{k}"  # Unique key for each input
    )

# Update session state with current values
st.session_state.user_params = current_params

# ==================================================
# Write override file - SIMPLIFIED
# ==================================================
def write_user_parameters(p):
    with open(USER_PARAM_FILE, "w") as f:
        for k, v in p.items():
            f.write(f"let {k} := {v};\n")

# ==================================================
# Write AMPL run file - SIMPLIFIED
# ==================================================
def write_run_file():
    with open(RUN_FILE, "w") as f:
        f.write(f"""reset;
model "{PARAM_FILE.name}";
model "{USER_PARAM_FILE.name}";
model "main.mod";
solve;
display Cost_Total_Per_Ton;
display Emissions_Total_Per_Ton;
display Production_Route;
display Carbon_Capture_Requirement;
""")

# ==================================================
# Main Title
# ==================================================
st.title("🏭 Steel Sector System Modeling")
st.caption("Advanced Multi-Period Linear Programming Optimization Platform")

# ==================================================
# Optimization Execution
# ==================================================
st.markdown("---")

if st.button("▶️ Run Optimization", type="primary"):
    
    # Create a progress bar
    progress_bar = st.progress(0)
    
    # Debug: Show what parameters we're using
    st.write(f"Using {len(st.session_state.user_params)} parameters")
    
    # Count changed parameters
    changed_count = 0
    for k in st.session_state.user_params:
        user_val = st.session_state.user_params[k]
        default_val = default_params[k]
        if abs(user_val - default_val) > 0.000001:
            changed_count += 1
    
    st.write(f"Parameters changed from defaults: {changed_count}")
    
    # Show a few changed parameters as example
    if changed_count > 0:
        st.write("**Example changed parameters:**")
        changed_examples = []
        for k in list(st.session_state.user_params.keys())[:5]:  # Show first 5
            user_val = st.session_state.user_params[k]
            default_val = default_params[k]
            if abs(user_val - default_val) > 0.000001:
                changed_examples.append(f"{k}: {default_val:.6f} → {user_val:.6f}")
        
        for example in changed_examples[:3]:  # Show max 3 examples
            st.write(f"  - {example}")
    
    # Write parameter files
    write_user_parameters(st.session_state.user_params)
    write_run_file()
    
    # Show run file for debugging
    with st.expander("View AMPL run file"):
        st.code(open(RUN_FILE).read(), language="ampl")
    
    # Show user parameters file for debugging
    with st.expander("View user parameters file"):
        st.code(open(USER_PARAM_FILE).read(), language="ampl")
    
    # Run AMPL
    try:
        # Start AMPL
        process = subprocess.Popen(
            [AMPL_EXE, RUN_FILE.name],
            cwd=BASE_DIR,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Animate progress bar
        progress = 0
        while process.poll() is None and progress < 90:
            progress = min(90, progress + 2)
            progress_bar.progress(progress)
            time.sleep(0.1)
        
        # Get output
        stdout, stderr = process.communicate()
        
        # Complete progress
        progress_bar.progress(100)
        time.sleep(0.5)
        progress_bar.empty()
        
        # Check result
        if process.returncode == 0:
            st.success("✅ Optimization successful!")
            
            # Save output to file
            with open(AMPL_OUTPUT_FILE, "w") as f:
                f.write(stdout)
            
            # Display output
            with st.expander("View AMPL output"):
                st.text(stdout)
            
            # Process results (your existing parsing code here)
            # ... [Keep your existing result parsing code] ...
            
        else:
            st.error(f"❌ AMPL failed with return code: {process.returncode}")
            st.write("**Error output:**")
            st.code(stderr if stderr else stdout, language="text")
            
    except Exception as e:
        progress_bar.empty()
        st.error(f"❌ Error running AMPL: {str(e)}")

else:
    st.info("Configure parameters in the sidebar and click 'Run Optimization'")
