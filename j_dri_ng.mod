# ============================================
# NG DRI (time-series)
# ============================================

# NG DRI output based on DRI-EAF fraction
s.t. ngdri_fraction{t in T}:
    f_ngdri[t] * dri_eaf_steel_out[t] - ngdri_output[t] = 0;   # eq47


# Pellet requirement for NG DRI
s.t. ngdri_pellets_balance{t in T}:
    N11_pel_dri * ngdri_output[t] - ngdri_pellet_in[t] = 0;     # eq48


# Natural gas consumption
s.t. ngdri_ng_balance{t in T}:
    N11_ng_dri * ngdri_output[t] - ngdri_ng_in[t] = 0;          # eq49
    

# Power consumption for NG DRI
s.t. ngdri_power_balance{t in T}:
    N11_e_dri * ngdri_output[t] - ngdri_power_in[t] = 0;        # eq50
    
 
# Lump ore consumption
s.t. ngdri_lumpore_balance{t in T}:
    N11_ore_dri * ngdri_output[t] - ngdri_lumpore_in[t] = 0;    # eq51   



