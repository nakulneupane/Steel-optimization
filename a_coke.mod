# ============================
# Coke Oven balances 
# ============================

s.t. coke_coal_balance{t in T}:
    coke_in[t] / N0_cf - coking_coal_in[t] = 0;          # eq1

s.t. coke_power_balance{t in T}:
    N0_e_coke * coke_in[t] - coke_power_in[t] = 0;       # eq2

s.t. coke_tar_balance{t in T}:
    N0_tar_c * coking_coal_in[t] - tar_out[t] = 0;       # eq3

s.t. coke_cog_out_balance{t in T}:
    N0_cog_c * coking_coal_in[t] - cog_out[t] = 0;       # eq4

s.t. coke_breeze_out_balance{t in T}:
    N0_br_coal * coking_coal_in[t] - coke_breeze_out[t] = 0;   # eq5

s.t. coke_cog_recovered{t in T}:
    N0_r_cog * cog_out[t] - cog_in_cokeov[t] = 0;        # eq6

s.t. coke_cog_to_bf_bof{t in T}:
    N2_rec_COG * cog_out[t] - recovered_cog_in[t] = 0;   # eq7
