# ============================================================
# Sinter Plant 
# ============================================================

# Fine ore → Sinter
s.t. sinter_fineore_balance{t in T}:
    N1_ore_sint * sinter_in[t] - sinter_fineore_in[t] = 0;            # eq8

# Power → Sinter
s.t. sinter_power_balance{t in T}:
    N1_e_sinter * sinter_in[t] - sinter_power_in[t] = 0;              # eq9

# Lime → Sinter
s.t. sinter_lime_balance{t in T}:
    N1_lim_sint * sinter_in[t] - sinter_lime_in[t] = 0;               # eq10

# Biochar → Sinter
s.t. sinter_biochar_balance{t in T}:
    N1_bio * sinter_in[t] - sinter_biochar_in[t] = 0;                 # eq11

# Breeze → Sinter
s.t. sinter_breeze_balance{t in T}:
    N1_b_sint * sinter_in[t] - sinter_breeze_in[t] = 0;               # eq12

# Sinter gas (SG) output
s.t. sinter_gas_balance{t in T}:
    N1_sintgas * sinter_in[t] - sg_out[t] = 0;                        # eq13
