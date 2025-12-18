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
st.title("Steel Sector Optimization")

# ==================================================
# Paths
# ==================================================
BASE_DIR = Path(__file__).parent
MAIN_MOD_FILE = BASE_DIR / "main.mod"
PARAM_FILE = BASE_DIR / "parameters.mod"
USER_PARAM_FILE = BASE_DIR / "user_parameters.mod"
RUN_FILE = BASE_DIR / "run_ampl.run"
AMPL_OUTPUT_FILE = BASE_DIR / "ampl_output.txt"

# ==================================================
# Check required files
# ==================================================
if not PARAM_FILE.exists():
    st.error(f"Missing parameters.mod at {PARAM_FILE}")
    st.stop()
    
if not MAIN_MOD_FILE.exists():
    st.error(f"Missing main.mod at {MAIN_MOD_FILE}")
    st.stop()

AMPL_EXE = shutil.which("ampl")
if not AMPL_EXE:
    st.error("AMPL executable not found in PATH")
    st.stop()

# ==================================================
# Load parameters from parameters.mod
# ==================================================
def load_params():
    """Extract parameter names and default values from parameters.mod"""
    params = {}
    
    # Pattern to match: param param_name default value;
    pattern = re.compile(r'^\s*param\s+(\w+)\s+default\s+([0-9.eE+-]+)\s*;', re.IGNORECASE)
    
    try:
        with open(PARAM_FILE) as f:
            for line in f:
                match = pattern.match(line.strip())
                if match:
                    param_name = match.group(1)
                    param_value = float(match.group(2))
                    params[param_name] = param_value
    except Exception as e:
        st.error(f"Error reading parameters.mod: {e}")
        return {}
    
    return params

params = load_params()

if not params:
    st.error("No parameters found in parameters.mod. Check the file format.")
    st.stop()

# ==================================================
# Sidebar for parameter inputs
# ==================================================
st.sidebar.header("Model Parameters")
user_params = {}

for param_name in sorted(params.keys()):
    default_value = params[param_name]
    user_params[param_name] = st.sidebar.number_input(
        param_name,
        value=float(default_value),
        format="%.6f"
    )

# ==================================================
# Create a custom main.mod that doesn't include parameters.mod
# ==================================================
def create_custom_main():
    """Create a main.mod file that doesn't include parameters.mod
    since we'll include it separately with overrides"""
    
    try:
        with open(MAIN_MOD_FILE, 'r') as f:
            content = f.read()
        
        # Remove the include parameters.mod line
        lines = content.split('\n')
        new_lines = []
        
        for line in lines:
            # Skip the include parameters.mod line
            if 'include parameters.mod;' in line:
                continue
            new_lines.append(line)
        
        # Write to a temporary file
        temp_main = BASE_DIR / "temp_main.mod"
        with open(temp_main, 'w') as f:
            f.write('\n'.join(new_lines))
        
        return temp_main
    
    except Exception as e:
        st.error(f"Error creating custom main.mod: {e}")
        return MAIN_MOD_FILE

# ==================================================
# Write user parameters file
# ==================================================
def write_user_params():
    """Write user parameters as let statements to override defaults"""
    with open(USER_PARAM_FILE, "w") as f:
        f.write("# User parameter overrides\n\n")
        for param_name, value in user_params.items():
            f.write(f"let {param_name} := {value};\n")

# ==================================================
# Create AMPL run file
# ==================================================
def write_run_file():
    """Create AMPL run script"""
    
    # Create custom main.mod without parameters.mod include
    custom_main = create_custom_main()
    
    with open(RUN_FILE, "w") as f:
        f.write(f"""# AMPL run script
reset;

# First include the parameters
include "{PARAM_FILE.name}";

# Then override with user parameters
include "{USER_PARAM_FILE.name}";

# Now include the custom main.mod (without parameters.mod include)
include "{custom_main.name}";

# Solve
solve;

# Display results
display total_cost;
display total_steel;
display total_emissions;
""")

# ==================================================
# Parse AMPL output
# ==================================================
def parse_results():
    """Parse AMPL output file for results"""
    if not AMPL_OUTPUT_FILE.exists():
        return None, None
    
    try:
        text = AMPL_OUTPUT_FILE.read_text(encoding='utf-8', errors='ignore')
        
        # Debug: Show raw output
        with st.expander("View AMPL Output"):
            st.code(text)
        
        # Try to find cost and emissions data
        cost_rows = []
        emis_rows = []
        
        lines = text.split('\n')
        
        # Simple parsing for cost
        for line in lines:
            if 'total_cost[' in line and ':=' in line:
                # Example: total_cost[2025] := 123.456
                match = re.search(r'total_cost\[(\d+)\]\s*:=\s*([\d.]+)', line)
                if match:
                    year = int(match.group(1))
                    cost = float(match.group(2))
                    cost_rows.append({
                        'Year': year,
                        'Total Cost': cost
                    })
        
        # Simple parsing for steel production
        steel_data = {}
        for line in lines:
            if 'total_steel[' in line and ':=' in line:
                match = re.search(r'total_steel\[(\d+)\]\s*:=\s*([\d.]+)', line)
                if match:
                    year = int(match.group(1))
                    steel = float(match.group(2))
                    steel_data[year] = steel
        
        # Simple parsing for emissions
        for line in lines:
            if 'total_emissions[' in line and ':=' in line:
                match = re.search(r'total_emissions\[(\d+)\]\s*:=\s*([\d.]+)', line)
                if match:
                    year = int(match.group(1))
                    emissions = float(match.group(2))
                    emis_rows.append({
                        'Year': year,
                        'Total Emissions': emissions
                    })
        
        # Create dataframes with per-ton calculations
        cost_df = pd.DataFrame(cost_rows) if cost_rows else pd.DataFrame()
        emis_df = pd.DataFrame(emis_rows) if emis_rows else pd.DataFrame()
        
        # Calculate per-ton values
        if not cost_df.empty and steel_data:
            cost_df['Steel Production'] = cost_df['Year'].map(steel_data)
            cost_df['Cost per ton ($/t)'] = cost_df.apply(
                lambda row: row['Total Cost'] / row['Steel Production'] if row['Steel Production'] > 0 else 0,
                axis=1
            )
        
        if not emis_df.empty and steel_data:
            emis_df['Steel Production'] = emis_df['Year'].map(steel_data)
            emis_df['Emissions per ton (tCO₂/t)'] = emis_df.apply(
                lambda row: row['Total Emissions'] / row['Steel Production'] if row['Steel Production'] > 0 else 0,
                axis=1
            )
        
        return cost_df, emis_df
        
    except Exception as e:
        st.error(f"Error parsing results: {e}")
        return None, None

# ==================================================
# Clean up temporary files
# ==================================================
def cleanup():
    """Clean up temporary files"""
    temp_files = [
        USER_PARAM_FILE,
        RUN_FILE,
        AMPL_OUTPUT_FILE,
        BASE_DIR / "temp_main.mod"
    ]
    
    for file in temp_files:
        if file.exists():
            try:
                file.unlink()
            except:
                pass

# Clean up on start
cleanup()

# ==================================================
# Run optimization
# ==================================================
if st.button("Run Optimization"):
    if not user_params:
        st.error("No parameters to optimize")
        st.stop()
    
    # Clean up first
    cleanup()
    
    # Write parameter files
    write_user_params()
    write_run_file()
    
    # Run AMPL
    with st.spinner("Running AMPL..."):
        try:
            # Run AMPL
            result = subprocess.run(
                [AMPL_EXE, RUN_FILE.name],
                cwd=BASE_DIR,
                capture_output=True,
                text=True
            )
            
            # Check if AMPL ran successfully
            if result.returncode != 0:
                st.error("AMPL failed to run")
                st.code(f"STDOUT:\n{result.stdout}\n\nSTDERR:\n{result.stderr}")
                st.stop()
            
            # Parse and display results
            df_cost, df_emis = parse_results()
            
            if df_cost is not None and not df_cost.empty:
                st.subheader("Cost Results")
                st.dataframe(df_cost)
            else:
                st.warning("No cost results found in output")
            
            if df_emis is not None and not df_emis.empty:
                st.subheader("Emissions Results")
                st.dataframe(df_emis)
            else:
                st.warning("No emissions results found in output")
            
            # Show success message
            st.success("Optimization completed!")
            
        except Exception as e:
            st.error(f"Error running optimization: {e}")
        finally:
            # Clean up temporary files
            cleanup()
