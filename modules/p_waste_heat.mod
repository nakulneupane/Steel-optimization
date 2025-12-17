# ============================================================
# Waste Heat Balances + WHR Power Generation
# ============================================================

# BF–BOF + Sinter + Coke waste heat availability
s.t. bf_bof_waste_heat_balance{t in T}:
      cog_out[t]
    + bfg_out[t]
    + bofgas_out[t]
    + sg_out[t]
    - cog_in_cokeov[t]
    - bfg_in[t]
    - recovered_cog_in[t]
    - bof_cog_in[t]
    - wasteheat_bf_bof[t]
    = 0;                                                          # eq77


# DRI–EAF waste heat
s.t. eaf_waste_heat_balance{t in T}:
    eafgas_out[t] - wasteheat_eaf[t] = 0;                         # eq78


# WHR power from all waste-heat sources
s.t. whr_power_balance{t in T}:
    ( (wasteheat_bf_bof[t]
      + wasteheat_eaf[t]
      + scrap_eaf_wasteheat[t]) * 277.78 ) * N9_eta * N9_whr
    - whr_power_generated[t]
    = 0;                                                           # eq79
