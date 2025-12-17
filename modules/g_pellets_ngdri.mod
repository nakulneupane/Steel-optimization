# ============================================================
# Pellets for Natural Gas DRI 
# ============================================================

# Fine ore needed for NG DRI pellets
s.t. pellets_ngdri_fineore_balance{t in T}:
    ngdri_pellet_in[t] / N13_y - ngdri_fineore[t] = 0;                 # eq38

# Power consumption for NG DRI pellet plant
s.t. pellets_ngdri_power_balance{t in T}:
    N13_e_pell * ngdri_pellet_in[t] - ngdri_pellet_power[t] = 0;       # eq39


