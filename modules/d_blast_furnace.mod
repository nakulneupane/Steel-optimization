# ============================
# Blast Furnace balances
# ============================

s.t. bf_coke_balance{t in T}:
    N2_c_hm * hot_metal[t] - coke_in[t] = 0;          # eq16

s.t. bf_sinter_balance{t in T}:
    N2_s_hm * hot_metal[t] - sinter_in[t] = 0;        # eq17

s.t. bf_hot_metal_in{t in T}:
    bof_slag_out[t] + steel_bof[t]
  - bof_lime_in[t] - bof_scrap_in[t] - hot_metal[t] = 0;  # eq18
    
s.t. bf_biochar_balance{t in T}:
    (N2_biochar_target * (t - 2025) / 10) * hot_metal[t] - bf_biochar_in[t] = 0;    # eq19

s.t. bf_bfg_in{t in T}:
    N2_rec_BFG * bfg_out[t] - bfg_in[t] = 0;          # eq20

s.t. bf_lumpore_balance{t in T}:
    N2_o_hm * hot_metal[t] - bf_lumpore_in[t] = 0;    # eq21

s.t. bf_hydrogen_balance{t in T}:
    (N2_h2_target * (t - 2025) / 10) * hot_metal[t] - bf_h2_in[t] = 0;   #eq22
    
s.t. bf_pci_balance{t in T}:
    N2_p_hm * hot_metal[t] -bf_biochar_in[t] - bf_h2_in[t] -  bf_pci_in[t] = 0;        # eq23

s.t. bf_power_balance{t in T}:
    N2_e_hm * hot_metal[t] - bf_power_in[t] = 0;      # eq24

s.t. bf_lime_balance{t in T}:
    N2_l_hm * hot_metal[t] - bf_lime_in[t] = 0;       # eq25

s.t. bf_slag_balance{t in T}:
    N2_sl_hm * hot_metal[t] - bf_slag_out[t] = 0;     # eq26

s.t. bf_pellets_in{t in T}:
    N2_pel_hm * hot_metal[t] - pellets_bf_in[t] = 0;  # eq27

s.t. bf_bfg_out{t in T}:
    N2_BFG_hm * hot_metal[t] - bfg_out[t] = 0;        # eq28
