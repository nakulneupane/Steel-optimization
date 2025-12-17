# =========================================
# COST EQUATIONS 
# =========================================

# -------------------- Coke Oven --------------------
s.t. cost_cokeov_def{t in T}:
    N0_capex       * steel_bof[t]
  + N0_cost_coal   * coking_coal_in[t]
  + N0_cost_power  * coke_power_in[t]
  - N0_credit_breeze * coke_breeze_out[t]
  - N0_credit_tar    * tar_out[t]
  - cost_cokeov[t] = 0;                                  # eq84

# -------------------- Sinter ------------------------
s.t. cost_sinter_def{t in T}:
    N1_capex      * steel_bof[t]
  + N1_cost_breeze  * sinter_breeze_in[t]
  + N1_cost_fineore * sinter_fineore_in[t]
  + N1_cost_power   * sinter_power_in[t]
  + N1_cost_lime    * sinter_lime_in[t]
  + N1_cost_biochar * sinter_biochar_in[t]
  - cost_sinter[t] = 0;                                   # eq85

# -------------------- Pellets BF ---------------------
s.t. cost_pellet_bf_def{t in T}:
    N8_capex         * steel_bof[t]
  + N8_cost_fineore  * pellets_fineore_bf[t]
  + N8_cost_power    * pellets_bf_power[t]
  - cost_pellet_bf[t] = 0;                              # eq86
  
# -------------------- Blast Furnace -----------------
s.t. cost_bf_def{t in T}:
    N2_capex        * steel_bof[t]
  + N2_cost_lumpore * bf_lumpore_in[t]
  + N2_cost_pci     * bf_pci_in[t]
  + N2_cost_power   * bf_power_in[t]
  + N2_cost_lime    * bf_lime_in[t]
  + N2_cost_biochar * bf_biochar_in[t]
  + N2_cost_h2[t] * bf_h2_in[t]
  - N2_credit_slag  * bf_slag_out[t]
  - cost_bf[t] = 0;                                      # eq87

# -------------------- BOF ---------------------------
s.t. cost_bof_def{t in T}:
    N3_capex       * steel_bof[t]
  + N3_cost_scrap  * bof_scrap_in[t]
  + N3_cost_power  * bof_power_in[t]
  + N3_cost_lime   * bof_lime_in[t]
  - N3_credit_slag * bof_slag_out[t]
  - cost_bof[t] = 0;                                     # eq88

# -------------------- Pellets Coal DRI ---------------
s.t. cost_pellet_coaldri_def{t in T}:
    N6_capex         * f_cdri[t]       * steel_eaf[t]
  + N6_cost_fineore  * pellets_fineore_coaldri[t]
  + N6_cost_power    * coaldri_pellet_power[t]
  - cost_pellet_coaldri[t] = 0;                         # eq89

# -------------------- Pellets NG DRI -----------------
s.t. cost_pellet_ngdri_def{t in T}:
    N13_capex        * f_ngdri[t] * steel_eaf[t]
  + N13_cost_fineore * ngdri_fineore[t]
  + N13_cost_power   * ngdri_pellet_power[t]
  - cost_pellet_ngdri[t] = 0;                          # eq90
       
# -------------------- Pellets H2 DRI -----------------
s.t. cost_pellet_h2dri_def{t in T}:
    N14_capex        * (1-f_cdri[t] - f_ngdri[t]) * steel_eaf[t]
  + N14_cost_fineore * h2dri_fineore[t]
  + N14_cost_power   * h2dri_pellet_power[t]
  - cost_pellet_h2dri[t] = 0;                          # eq91
  
# -------------------- Coal DRI ----------------------
s.t. cost_coaldri_def{t in T}:
    N5_capex_coal * f_cdri[t]       * steel_eaf[t]
  + N5_cost_power * coaldri_power_in[t]
  + N5_cost_lumpore * coaldri_lumpore_in[t]
  + N5_cost_coal     * coaldri_coal_in[t]
  - cost_coaldri[t] = 0;                                # eq92

# -------------------- NG DRI -------------------------
s.t. cost_ngdri_def{t in T}:
    N11_capex_ng[t]    * f_ngdri[t] * steel_eaf[t]
  + N11_cost_power  * ngdri_power_in[t]
  + N11_cost_lumpore * ngdri_lumpore_in[t]
  + N11_cost_NG     * ngdri_ng_in[t]
  - cost_ngdri[t] = 0;                                # eq93

# -------------------- H2 DRI -------------------------
s.t. cost_h2dri_def{t in T}:
    N12_capex_h2[t]    * (1-f_cdri[t] - f_ngdri[t]) * steel_eaf[t]
  + N12_cost_power  * h2dri_power_in[t]
  + N12_cost_lumpore * h2dri_lumpore_in[t]
  + N12_cost_H2[t]     * h2dri_h2_in[t]
  - cost_h2dri[t] = 0;                               # eq94
  
# -------------------- EAF-I (DRI-EAF) ----------------
s.t. cost_eaf_def{t in T}:
    N4_capex         * steel_eaf[t]
  + N4_cost_scrap    * eaf_scrap_in[t]
  + N4_cost_power    * eaf_power_in[t]
  + N4_cost_lime     * eaf_lime_in[t]
  + N4_cost_coal     * eaf_coal_in[t]
  + N4_cost_electrode* eaf_electrode_in[t]
  - N4_credit_slag   * eaf_slag_out[t]
  - cost_eaf[t] = 0;                                  # eq95
        
# -------------------- Scrap EAF ----------------------
s.t. cost_scrap_eaf_def{t in T}:
    N10_capex        * steel_scrap_eaf[t]
  + N10_cost_scrap   * scrap_eaf_scrap_in[t]
  + N10_cost_power   * scrap_eaf_power_in[t]
  + N10_cost_lime    * scrap_eaf_lime_in[t]
  + N10_cost_coal    * scrap_eaf_coal_in[t]
  + N10_cost_electrode * scrap_eaf_electrode_in[t]
  - N10_credit_slag  * scrap_eaf_slag_out[t]
  - cost_scrap_eaf[t] = 0;                             # eq96

# -------------------- Carbon Capture -------------------------
s.t. cost_captured_co2{t in T}:
    (ccs_bf[t]* N15_ccs_cost_bf[t] + ccs_cdri[t]* N15_ccs_cost_cdri[t]
     + ccs_ngdri[t]* N15_ccs_cost_ngdri[t]) - cost_ccs[t] = 0;          # eq97
    
       
# -------------------- TOTAL COST ---------------------
s.t. total_cost_def{t in T}:
      cost_cokeov[t]
    + cost_sinter[t]
    + cost_bf[t]
    + cost_bof[t]
    + cost_eaf[t]
    + cost_coaldri[t]
    + cost_pellet_coaldri[t]
    + cost_pellet_bf[t]
    + cost_pellet_ngdri[t]
    + cost_pellet_h2dri[t]
    + cost_scrap_eaf[t]
    + cost_ngdri[t]
    + cost_h2dri[t]
    + cost_ccs[t]
    + (labor_cost + maintenance_cost + other_opex)* total_steel[t]
    - total_cost[t] = 0;                             # eq98
