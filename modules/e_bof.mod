# ============================
# BOF balances 
# ============================

s.t. bof_steel_fraction{t in T}:
    f_bof[t] * total_steel[t] - steel_bof[t] = 0;          # eq29

s.t. bof_cog_balance{t in T}:
    N3_COG * steel_bof[t] - bof_cog_in[t] = 0;          # eq30

s.t. bof_scrap_balance{t in T}:
    N3_s_bof * steel_bof[t] - bof_scrap_in[t] = 0;      # eq31

s.t. bof_power_balance{t in T}:
    N3_e_bof * steel_bof[t] - bof_power_in[t] = 0;      # eq32

s.t. bof_lime_balance{t in T}:
    N3_ls_bof * steel_bof[t] - bof_lime_in[t] = 0;      # eq33

s.t. bof_slag_balance{t in T}:
    N3_sl_bof * steel_bof[t] - bof_slag_out[t] = 0;     # eq34

s.t. bof_gas_out{t in T}:
    N3_BOFG * steel_bof[t] - bofgas_out[t] = 0;         # eq35
