# ============================================================
# Pellets for Coal DRI 
# ============================================================

# Fine ore requirement for pellets (Coal DRI)
s.t. pellets_coaldri_fineore_balance{t in T}:
    pellets_coaldri[t] / N6_y - pellets_fineore_coaldri[t] = 0;        # eq36

# Power used in Coal DRI pellet plant
s.t. pellets_coaldri_power_balance{t in T}:
    N6_e_pell * pellets_coaldri[t] - coaldri_pellet_power[t] = 0;      # eq37


