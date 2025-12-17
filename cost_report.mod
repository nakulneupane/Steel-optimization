printf "\n===============================================";
printf "\n     📊 ROUTE FRACTIONS + COST PER TON (TIME SERIES)";
printf "\n===============================================\n";

for {t in T} {

    printf "\n-------------------- Year %d --------------------", t;

    # =========================================================
    # 1. PRODUCTION FRACTIONS (STEELMAKING + DRI SPLIT)
    # =========================================================
    printf "\n\n🔄 PRODUCTION FRACTIONS:";

    printf "\nBF-BOF share:                     %12.4f", f_bof[t];
    printf "\nDRI-EAF share:                    %12.4f", f_eaf[t];
    printf "\nScrap-EAF share:                  %12.4f", 1-f_bof[t]-f_eaf[t];

    printf "\n\n   → DRI FRACTION SPLIT:";
    printf "\n      Coal DRI fraction:          %12.4f", f_cdri[t];
    printf "\n      NG DRI fraction:            %12.4f", f_ngdri[t];
    printf "\n      H2 DRI fraction:            %12.4f", 1 - f_cdri[t] - f_ngdri[t];

    # =========================================================
    # 2. COST PER TON FROM EACH ROUTE
    # =========================================================
    printf "\n\n💰 COST PER TON:";

    # BF-BOF
    if steel_bof[t] > 0 then
        printf "\nBF-BOF steel:                    $%12.2f/ton",
            (  cost_cokeov[t]
             + cost_sinter[t]
             + cost_bf[t]
             + cost_bof[t]
             + cost_pellet_bf[t]
             + ccs_bf[t]* N15_ccs_cost_bf[t]
             + (labor_cost + maintenance_cost + other_opex) * steel_bof[t] )
            / steel_bof[t];

    # ---------------------------------------------------------
    # DRI → Coal route
    # ---------------------------------------------------------
    if steel_eaf[t] * f_cdri[t] > 0 then
        printf "\nCoal DRI–EAF steel:              $%12.2f/ton",
            (  cost_coaldri[t]
             + cost_pellet_coaldri[t]
             + cost_eaf[t] * f_cdri[t]
             + ccs_cdri[t]* N15_ccs_cost_cdri[t]
             + (labor_cost + maintenance_cost + other_opex)
                   * (steel_eaf[t] * f_cdri[t]))
            / (steel_eaf[t] * f_cdri[t]);

    # ---------------------------------------------------------
    # DRI → NG route
    # ---------------------------------------------------------
    if steel_eaf[t] * f_ngdri[t] > 0 then
        printf "\nNG DRI–EAF steel:                $%12.2f/ton",
            (  cost_ngdri[t]
             + cost_pellet_ngdri[t]
             + cost_eaf[t] * f_ngdri[t]
             + ccs_ngdri[t]* N15_ccs_cost_ngdri[t]
             + (labor_cost + maintenance_cost + other_opex)
                   * (steel_eaf[t] * f_ngdri[t]))
            / (steel_eaf[t] * f_ngdri[t]);

    # ---------------------------------------------------------
    # DRI → H2 route
    # ---------------------------------------------------------
    if steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]) > 0 then
        printf "\nH2 DRI–EAF steel:                $%12.2f/ton",
            (  cost_h2dri[t]
             + cost_pellet_h2dri[t]
             + cost_eaf[t] * (1 - f_cdri[t] - f_ngdri[t])
             + (labor_cost + maintenance_cost + other_opex)
                   * (steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t])))
            / (steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]));

    # Scrap EAF
    if steel_scrap_eaf[t] > 0 then
        printf "\nScrap–EAF steel:                 $%12.2f/ton",
            (  cost_scrap_eaf[t]
             + (labor_cost + maintenance_cost + other_opex) * steel_scrap_eaf[t] )
            / steel_scrap_eaf[t];
     if total_steel[t] > 0 then
        printf "\n\nAverage Cost:        $%12.3f $/ton",
            total_cost[t] / total_steel[t];
    else
        printf "\n\nAverage System Emissions:        %12.3f tCO2/ton", 0;

    printf "\n";
    printf "\nTotal system cost in Year %d = %12.3f", t, total_cost[t];
    
}

