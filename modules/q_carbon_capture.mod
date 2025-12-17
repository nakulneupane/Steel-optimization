

# -----------------------------
# CCS from Blast Furnace Route
# -----------------------------
s.t. ccs_blastfurnace{t in T}:
    (
        coking_coal_in[t] * 2.6
      + (eaf_coal_in[t] + bf_pci_in[t]) * 2.5
      + (bf_biochar_in[t] + sinter_biochar_in[t]) * 2.9
      + (sinter_lime_in[t] + bf_lime_in[t] + bof_lime_in[t]) * 0.44
    )
    * N15_ccs_eta * fc_bf[t]
    - ccs_bf[t] = 0;                         # eq80


# -----------------------------
# CCS from Coal-DRI route
# -----------------------------
s.t. ccs_coaldri{t in T}:
    (
        coaldri_coal_in[t] * 2.5
      + eaf_coal_in[t] * f_cdri[t] * 2.5
      + eaf_lime_in[t] * f_cdri[t] * 0.44
    )
    * N15_ccs_eta * fc_cdri[t]
    - ccs_cdri[t] = 0;                         # eq81


# -----------------------------
# CCS from NG-DRI route
# -----------------------------
s.t. ccs_naturalgasdri{t in T}:
    (
        ngdri_ng_in[t] * 2.75
      + eaf_coal_in[t] * f_ngdri[t] * 2.5
      + eaf_lime_in[t] * f_ngdri[t] * 0.44
    )
    * N15_ccs_eta * fc_ngdri[t]
    - ccs_ngdri[t] = 0;                         # eq82


# -----------------------------
# Total captured CO2
# -----------------------------
s.t. total_captured_co2{t in T}:
    ccs_bf[t] + ccs_cdri[t] + ccs_ngdri[t] - total_ccs[t] = 0;                         # eq83
    