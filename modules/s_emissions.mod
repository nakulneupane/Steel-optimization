
# ============================================================
# Scope 1 Emissions (Blast furnace)
# ============================================================
s.t. scope1_blastf{t in T}:
    (
        coking_coal_in[t] * 2.6
       + bf_pci_in[t] * 2.5

      + (bf_biochar_in[t]
       + sinter_biochar_in[t]) * 2.9
      + (sinter_lime_in[t]
       + bf_lime_in[t]
       + bof_lime_in[t]) * 0.44
    )
    - scope1_bf[t] = 0;                                 # eq99
 
# ============================================================
# Scope 1 Emissions (Coal DRI)
# ============================================================
s.t. scope1_coaldri{t in T}:
            (
                coaldri_coal_in[t]       * 2.5
              + eaf_coal_in[t] * f_cdri[t] * 2.5
              + eaf_lime_in[t] * f_cdri[t] * 0.44
            )  - scope1_cdri[t] = 0;                   # eq100
            
# ============================================================
# Scope 1 Emissions (NG DRI)
# ============================================================                
s.t. scope1_natgasdri{t in T}:
            (
                ngdri_ng_in[t]           * 2.75
              + eaf_coal_in[t] * f_ngdri[t] * 2.5
              + eaf_lime_in[t] * f_ngdri[t] * 0.44
            )  - scope1_ngdri[t] = 0;                  # eq101

# ============================================================
# Scope 1 Emissions (Total)
# ============================================================   
s.t. scope1_def{t in T}:
    (
        coking_coal_in[t] * 2.6

      + (coaldri_coal_in[t]
       + eaf_coal_in[t]
       + bf_pci_in[t]
       + scrap_eaf_coal_in[t]) * 2.5

      + (bf_biochar_in[t]
       + sinter_biochar_in[t]) * 2.9

      + ngdri_ng_in[t] * 2.75

      + (sinter_lime_in[t]
       + eaf_lime_in[t]
       + bf_lime_in[t]
       + bof_lime_in[t]
       + scrap_eaf_lime_in[t]) * 0.44
    )
    - scope1_emissions[t] = 0;                         # eq102

# ============================================================
# Scope 2 Emissions (Total)
# ============================================================
s.t. scope2_def{t in T}:
    grid_ef[t] * grid_power_in[t] 
    - scope2_emissions[t] = 0;                         # eq103
       
# ============================================================
# Total Emissions (Scope 1  + Scope 2)
# ============================================================
s.t. total_emissions_def{t in T}:
    scope1_emissions[t] + scope2_emissions[t]
    - total_ccs[t] - total_emissions[t] = 0;           # eq104
# ============================================================