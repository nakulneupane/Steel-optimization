
# =====================================================
# EAF-I (DRI-EAF) 
# =====================================================

# Fraction of total steel going to EAF
s.t. eaf_steel_fraction{t in T}:
    f_eaf[t] * total_steel[t] - steel_eaf[t] = 0;                 # eq57


# Relation between DRI, scrap, and EAF steel
s.t. dri_eaf_steel_relation{t in T}:
    steel_eaf[t] - eaf_scrap_in[t] - dri_eaf_steel_out[t] = 0;    # eq58


# Scrap required in EAF
s.t. eaf_scrap_balance{t in T}:
    N4_phi_eaf * steel_eaf[t] - eaf_scrap_in[t] = 0;              # eq59


# Lime balance
s.t. eaf_lime_balance{t in T}:
    N4_ls * steel_eaf[t] - eaf_lime_in[t] = 0;                    # eq60


# Coal balance
s.t. eaf_coal_balance{t in T}:
    N4_cs * steel_eaf[t] - eaf_coal_in[t] = 0;                    # eq61


# Power consumption
s.t. eaf_power_balance{t in T}:
    N4_e_eaf * steel_eaf[t] - eaf_power_in[t] = 0;                # eq62


# Electrode consumption
s.t. eaf_electrode_balance{t in T}:
    N4_eltrd * steel_eaf[t] - eaf_electrode_in[t] = 0;            # eq63


# Slag generation
s.t. eaf_slag_balance{t in T}:
    N4_ss * steel_eaf[t] - eaf_slag_out[t] = 0;                   # eq64


# EAF off-gas
s.t. eaf_gas_out{t in T}:
    N4_eafg * steel_eaf[t] - eafgas_out[t] = 0;                   # eq65
