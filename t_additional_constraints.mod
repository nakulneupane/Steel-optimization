# -----------------------------------
#        Initialization
# -----------------------------------
s.t. init_f_bof: f_bof[first(T)] = 0.44;
s.t. init_f_eaf: f_eaf[first(T)] = 0.36;
s.t. init_f_cdri: f_cdri[first(T)] = 0.8;

# -------------------------------------------------------------------
#              Demand and availability Constraints
# -------------------------------------------------------------------
s.t. meet_demand{t in T}:
    total_steel[t] = base_demand * (1 + growth_rate)^(ord(t) - 1);

s.t. scrap_bound{t in T}:
    scrap_eaf_scrap_in[t] <= scrap_limit[t];

s.t. ng_bound{t in T}:
    ngdri_ng_in[t] <= ng_base * (1 + ng_growth)^(ord(t) - 1);;
        
s.t. H2_Availability_Constraint{t in T}:
    h2dri_h2_in[t] <= h2_avail[t];

# -----------------------------------------------------
#                Ramping Constraints
# -----------------------------------------------------
s.t. bof_prod_up {t in T: t != first(T)}:
    steel_bof[t] <= 1.15 * steel_bof[prev(t)];

s.t. bof_prod_down {t in T: t != first(T)}:
    steel_bof[t] >= 0.85 * steel_bof[prev(t)];
    
s.t. cdri_prod_up {t in T: t != first(T)}:
    coaldri_output[t] <= 1.15 * coaldri_output[prev(t)];

s.t. cdri_prod_down {t in T: t != first(T)}:
    coaldri_output[t] >= 0.85 * coaldri_output[prev(t)];
    
s.t. ngdri_prod_up {t in T: t != first(T)}:
    ngdri_output[t] <= 1.15 * ngdri_output[prev(t)];

s.t. ngdri_prod_down {t in T: t != first(T)}:
    ngdri_output[t] >= 0.85 * ngdri_output[prev(t)];

# DRI Frcations
s.t. dri_fraction_bounds {t in T}:
    f_cdri[t] + f_ngdri[t] <= 1;


# -----------------------------------------------------
#                Hydrogen Constraints
# -----------------------------------------------------

# Hydrogen fraction must NOT decrease
s.t. h2_fraction_monotonic {t in T: t != first(T)}:
    (1 - f_cdri[t] - f_ngdri[t]) >= (1 - f_cdri[prev(t)] - f_ngdri[prev(t)]);


#  Initialization at start year: set to base capacity
s.t. H2_Start_Base{t in T: t = h2_start_year}:
    h2dri_h2_in[t] = h2_base;

# Slow growth limit (2031–2035): +8% per year
s.t. H2_Slow_Growth_Limit{t in T: t > h2_start_year && t <= 2035}:
    h2dri_h2_in[t] <= h2dri_h2_in[t-1] * (1 + h2_slow_growth);

#  Fast growth limit (2036 onward): +20% per year
s.t. H2_Fast_Growth_Limit{t in T: t > 2035}:
    h2dri_h2_in[t] <= h2dri_h2_in[t-1] * (1 + h2_fast_growth);
    
# ========================================
#       Carbon Capture Constraints
# ========================================
s.t. init_fc_bf:      fc_bf[2025]   = 0;
s.t. init_fc_cdri:    fc_cdri[2025] = 0;
s.t. init_fc_ngdri:   fc_ngdri[2025] = 0;

s.t. fc_bf_change {t in T: t > 2025}:
    - (if t <= 2030 then 0.01
       else if t <= 2035 then 0.03
       else if t <= 2040 then 0.05
       else if t <= 2050 then 0.08)
    <= fc_bf[t] - fc_bf[prev(t)]
    <= (if t <= 2030 then 0.01
        else if t <= 2035 then 0.03
        else if t <= 2040 then 0.05
        else if t <= 2050 then 0.08);


s.t. fc_cdri_change {t in T: t > 2025}:
    - (if t <= 2030 then 0.01
       else if t <= 2035 then 0.03
       else if t <= 2040 then 0.05
       else if t <= 2050 then 0.08)
    <= fc_cdri[t] - fc_cdri[prev(t)]
    <= (if t <= 2030 then 0.01
        else if t <= 2035 then 0.03
        else if t <= 2040 then 0.05
        else if t <= 2050 then 0.08);


s.t. fc_ngdri_change {t in T: t > 2025}:
    - (if t <= 2030 then 0.01
       else if t <= 2035 then 0.03
       else if t <= 2040 then 0.05
       else if t <= 2050 then 0.08)
    <= fc_ngdri[t] - fc_ngdri[prev(t)]
    <= (if t <= 2030 then 0.01
        else if t <= 2035 then 0.03
        else if t <= 2040 then 0.05
        else if t <= 2050 then 0.08);    
        
#Binary
# =====================================================
#   Unimodality constraint for CCS fractions
#   (increase allowed, one-time decline, no rebound)
# =====================================================

param M := 1;   # Big-M (safe since fc_* ∈ [0,1])

# --- Binary flags indicating decline phase ---
var bf_decline{t in T} binary;
var cdri_decline{t in T} binary;
var ngdri_decline{t in T} binary;

# --- Once decline starts, it cannot stop ---
s.t. bf_decline_monotone {t in T: t > first(T)}:
    bf_decline[t] >= bf_decline[prev(t)];

s.t. cdri_decline_monotone {t in T: t > first(T)}:
    cdri_decline[t] >= cdri_decline[prev(t)];

s.t. ngdri_decline_monotone {t in T: t > first(T)}:
    ngdri_decline[t] >= ngdri_decline[prev(t)];

# --- No increase allowed after decline starts ---
s.t. bf_no_increase_after_decline {t in T: t > first(T)}:
    fc_bf[t] - fc_bf[prev(t)] <= M * (1 - bf_decline[t]);

s.t. cdri_no_increase_after_decline {t in T: t > first(T)}:
    fc_cdri[t] - fc_cdri[prev(t)] <= M * (1 - cdri_decline[t]);

s.t. ngdri_no_increase_after_decline {t in T: t > first(T)}:
    fc_ngdri[t] - fc_ngdri[prev(t)] <= M * (1 - ngdri_decline[t]);

# --- Trigger decline when a decrease occurs ---
s.t. bf_trigger_decline {t in T: t > first(T)}:
    fc_bf[prev(t)] - fc_bf[t] <= M * bf_decline[t];

s.t. cdri_trigger_decline {t in T: t > first(T)}:
    fc_cdri[prev(t)] - fc_cdri[t] <= M * cdri_decline[t];

s.t. ngdri_trigger_decline {t in T: t > first(T)}:
    fc_ngdri[prev(t)] - fc_ngdri[t] <= M * ngdri_decline[t];
        