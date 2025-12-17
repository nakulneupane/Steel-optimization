# ============================================================
# Total Power Balance 
# ============================================================

s.t. total_power_balance{t in T}:
      coke_power_in[t]
    + sinter_power_in[t]
    + bf_power_in[t]
    + coaldri_power_in[t]
    + eaf_power_in[t]
    + bof_power_in[t]
    + coaldri_pellet_power[t]
    + pellets_bf_power[t]
    + scrap_eaf_power_in[t]
    + ngdri_power_in[t]
    + h2dri_power_in[t]
    + ngdri_pellet_power[t]
    + h2dri_pellet_power[t]
    - whr_power_generated[t]
    - grid_power_in[t]
    = 0;                                                          # eq76
