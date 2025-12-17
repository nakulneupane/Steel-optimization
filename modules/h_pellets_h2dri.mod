# ============================================================
# Pellets for Hydrogen DRI 
# ============================================================

# Fine ore requirement for H₂ DRI pellets
s.t. pellets_h2dri_fineore_balance{t in T}:
    h2dri_pellet_in[t] / N14_y - h2dri_fineore[t] = 0;                 # eq40

# Power requirement for H₂ DRI pellet plant
s.t. pellets_h2dri_power_balance{t in T}:
    N14_e_pell * h2dri_pellet_in[t] - h2dri_pellet_power[t] = 0;       # eq41


