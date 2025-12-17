# ============================================
# COAL DRI 
# ============================================

# Coal DRI output based on DRI-EAF steel share
s.t. coaldri_fraction{t in T}:
    f_cdri[t] * dri_eaf_steel_out[t] - coaldri_output[t] = 0;     # eq42


# Pellet requirement for Coal DRI
s.t. coaldri_pellets_balance{t in T}:
    N5_pel_dri * coaldri_output[t] - pellets_coaldri[t] = 0;      # eq43


# Coal consumption in Coal DRI
s.t. coaldri_coal_balance{t in T}:
    N5_c_dri * coaldri_output[t] - coaldri_coal_in[t] = 0;        # eq44


# Power consumption (Coal DRI)
s.t. coaldri_power_balance{t in T}:
    N5_e_dri * coaldri_output[t] - coaldri_power_in[t] = 0;       # eq45


# Lump ore requirement (Coal DRI)
s.t. coaldri_lumpore_balance{t in T}:
    N5_ore_dri * coaldri_output[t] - coaldri_lumpore_in[t] = 0;   # eq46


