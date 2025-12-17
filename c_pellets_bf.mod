# ============================================================
# Pellets for BF 
# ============================================================

s.t. pellets_bf_fineore_balance{t in T}:
    pellets_bf_in[t] / N8_y - pellets_fineore_bf[t] = 0;        # eq14

s.t. pellets_bf_power_balance{t in T}:
    N8_e_pell * pellets_bf_in[t] - pellets_bf_power[t] = 0;     # eq15
