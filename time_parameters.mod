# =========================================
# Time-dependent parameters (derived)
# =========================================

param N2_cost_h2{t in T};
param N11_capex_ng{t in T};

param N15_ccs_cost_bf{t in T};
param N15_ccs_cost_cdri{t in T};
param N15_ccs_cost_ngdri{t in T};

param N12_cost_H2{t in T};
param N12_capex_h2{t in T};

param h2_avail{t in T};
param grid_ef{t in T};
param scrap_limit{t in T};

# -----------------------------------------
# Hydrogen cost (BF)
# -----------------------------------------
let {t in T} N2_cost_h2[t] :=
    N2_cost_h2_start
  - ((ord(t)-1)/(card(T)-1))
    * (N2_cost_h2_start - N2_cost_h2_end);

# -----------------------------------------
# NG-DRI CAPEX
# -----------------------------------------
let {t in T} N11_capex_ng[t] :=
    N11_capex_ng_start
  - ((ord(t)-1)/(card(T)-1))
    * (N11_capex_ng_start - N11_capex_ng_end);

# -----------------------------------------
# CCS costs
# -----------------------------------------
let {t in T} N15_ccs_cost_bf[t] :=
    N15_ccs_cost_bf_start
  - ((ord(t)-1)/(card(T)-1))
    * (N15_ccs_cost_bf_start - N15_ccs_cost_bf_end);

let {t in T} N15_ccs_cost_cdri[t] :=
    N15_ccs_cost_cdri_start
  - ((ord(t)-1)/(card(T)-1))
    * (N15_ccs_cost_cdri_start - N15_ccs_cost_cdri_end);

let {t in T} N15_ccs_cost_ngdri[t] :=
    N15_ccs_cost_ngdri_start
  - ((ord(t)-1)/(card(T)-1))
    * (N15_ccs_cost_ngdri_start - N15_ccs_cost_ngdri_end);

# -----------------------------------------
# H2-DRI cost and capex
# -----------------------------------------
let {t in T} N12_cost_H2[t] :=
    if t <= 2030 then N12_cost_H2_start
    else N12_cost_H2_start
         - ((t-2030)/(2050-2030))
           * (N12_cost_H2_start - N12_cost_H2_end);

let {t in T} N12_capex_h2[t] :=
    if t <= 2030 then N12_capex_h2_start
    else N12_capex_h2_start
         - ((t-2030)/(2050-2030))
           * (N12_capex_h2_start - N12_capex_h2_end);

# -----------------------------------------
# Hydrogen availability
# -----------------------------------------
let {t in T} h2_avail[t] :=
    if t < h2_start_year then 0
    else h2_base
         * (1 + h2_slow_growth)^(min(t,h2_intermediate_year)-h2_start_year)
         * (1 + h2_fast_growth)^(max(t-h2_intermediate_year,0));

# -----------------------------------------
# Grid EF
# -----------------------------------------
let {t in T} grid_ef[t] :=
    if t <= 2025 then grid_ef_start_value
    else grid_ef_start_value
         - ((t-2025)/(2050-2025))
           * (grid_ef_start_value - grid_ef_end_value);

# -----------------------------------------
# Scrap limit
# -----------------------------------------
let {t in T} scrap_limit[t] :=
    scrap_base * (1 + scrap_rate)^(ord(t)-1);
