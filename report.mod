printf "\n%-6s %-20s %-37s %-18s %-10s",
       "YEAR",
       "BF-BOF (t/f)",
       "DRI-EAF (t/f split)",
       "Scrap-EAF (t/f)",
       "Total";

printf "\n%-6s %-12s %-15s %-15s %-20s %-10s %-10s",
       "", "", "Coal", "NG", "H2", "", "";

for {t in T} {
    printf "\n%4d %8.0f/%5.2f %8.0f/%5.2f %8.0f/%5.2f %8.0f/%5.2f %10.0f/%5.2f %10.0f",
        t,
        steel_bof[t], f_bof[t],                                  # BF-BOF
        steel_eaf[t] * f_cdri[t], f_cdri[t] * f_eaf[t],                            # Coal DRI
        steel_eaf[t] * f_ngdri[t] , f_ngdri[t] * f_eaf[t],                             # NG DRI
        steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]), (1 - f_cdri[t] - f_ngdri[t]) * * f_eaf[t],            # H2 DRI
        steel_scrap_eaf[t], 1 - f_bof[t] - f_eaf[t],            # Scrap-EAF
        total_steel[t];                                          # Total
}

printf "\n";

# ======================================================
# TABLE 2: CCS fractions and captured amounts
# ======================================================

printf "\n%-6s %-20s %-20s %-20s %-20s",
       "YEAR",
       "BF-BOF CCS (t/f)",
       "Coal-DRI CCS (t/f)",
       "NG-DRI CCS (t/f)",
       "Total CCS";

for {t in T} {
    printf "\n%4d %10.0f/%5.2f %10.0f/%5.2f %10.0f/%5.2f %12.0f",
        t,
        ccs_bf[t],     fc_bf[t],        # BF CCS: tons / fraction
        ccs_cdri[t],   fc_cdri[t],      # Coal-DRI CCS
        ccs_ngdri[t],  fc_ngdri[t],     # NG-DRI CCS
        total_ccs[t];                   # Total CO₂ captured
}

printf "\n";



