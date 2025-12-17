reset;
set T ordered := 2025..2050;

include parameters.mod;

#Time dependent parameters
param N2_cost_h2{t in T} :=
    N2_cost_h2_start - ( (ord(t)-1) / (card(T)-1) ) * (N2_cost_h2_start - N2_cost_h2_end);
param N11_capex_ng{t in T} :=
    N11_capex_ng_start - ( (ord(t) - 1) / (card(T) - 1) ) * (N11_capex_ng_start - N11_capex_ng_end);

param N15_ccs_cost_bf{t in T} :=
    N15_ccs_cost_bf_start - ((ord(t)-1)/(card(T)-1)) * (N15_ccs_cost_bf_start - N15_ccs_cost_bf_end);
param N15_ccs_cost_cdri{t in T} :=
    N15_ccs_cost_cdri_start - ((ord(t)-1)/(card(T)-1)) * (N15_ccs_cost_cdri_start - N15_ccs_cost_cdri_end);
param N15_ccs_cost_ngdri{t in T} :=
    N15_ccs_cost_ngdri_start - ((ord(t)-1)/(card(T)-1)) * (N15_ccs_cost_ngdri_start - N15_ccs_cost_ngdri_end);

include variables.mod;

# Process modules
include modules/a_coke.mod;
include modules/b_sinter.mod;
include modules/c_pellets_bf.mod;
include modules/d_blast_furnace.mod;
include modules/e_bof.mod;
include modules/f_pellets_coaldri.mod;
include modules/g_pellets_ngdri.mod;
include modules/h_pellets_h2dri.mod;
include modules/i_dri_coal.mod;
include modules/j_dri_ng.mod;
include modules/k_dri_h2.mod;
include modules/l_eaf_dri.mod;
include modules/m_scrap_eaf.mod;
include modules/n_steel_balance.mod;
include modules/o_power_balance.mod;
include modules/p_waste_heat.mod;
include modules/q_carbon_capture.mod;
include modules/r_cost.mod;
include modules/s_emissions.mod;
include modules/t_additional_constraints.mod;



# Objective
param cost_ref := 500;     # $/t steel (target cost scale)
param emis_ref := 2.4;     # tCO2/t steel (2025 baseline)
param real_discount_rate := 0.06;
param discount_factor{t in T} :=
    1 / (1 + real_discount_rate)^(ord(t) - 1);
param w_emis_start := 0.2;     # weak pressure in 2025
param w_emis_end   := 1.0;     # strong pressure in 2050
param alpha := 2;              # curvature (>1 pushes late action)
param w_emis{t in T} :=
    w_emis_start
  + (w_emis_end - w_emis_start)
    * ((ord(t) - 1) / (card(T) - 1))^alpha;
param max_avg_cost := 600;   # $/ton

s.t. avg_cost_cap {t in T}:
    total_cost[t] <= max_avg_cost * total_steel[t];

minimize obj_scaled:
    sum{t in T} (
        discount_factor[t] *
        ( ( total_cost[t] / total_steel[t] ) / cost_ref )
      + w_emis[t] *
        ( ( total_emissions[t] / total_steel[t] ) / emis_ref )
    );


option solver gurobi;
solve;
      
include cost_report.mod;
include emissions_report.mod;
include report.mod;





