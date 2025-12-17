printf "\n===============================================";
printf "\n     🌍 EMISSIONS PER TON WITH SCOPE BREAKDOWN";
printf "\n===============================================\n";

for {t in T} {

    printf "\n-------------------- Year %d --------------------", t;

    # =====================================================
    # BF–BOF EMISSIONS PER TON
    # =====================================================
    if steel_bof[t] > 0 then {

        # Scope 1 per ton (BF-BOF)
        printf "\nBF-BOF Scope 1 per ton:          %12.3f",
            (
                coking_coal_in[t] * 2.6
              + bf_pci_in[t]      * 2.5
              + sinter_lime_in[t] * 0.44
              + bf_lime_in[t]     * 0.44
              + bof_lime_in[t]    * 0.44
            ) / steel_bof[t];

        # Scope 2 per ton (BF-BOF)
        if grid_power_in[t] > 0 then
            printf "\nBF-BOF Scope 2 per ton:          %12.3f",
                (
                    coke_power_in[t]
                  + sinter_power_in[t]
                  + bf_power_in[t]
                  + bof_power_in[t]
                  + pellets_bf_power[t]
                  -wasteheat_bf_bof[t]* 277.78 * N9_eta * N9_whr
                )* grid_ef[t] / steel_bof[t];
        else
            printf "\nBF-BOF Scope 2 per ton:          %12.3f", 0;

        # Total per ton (BF-BOF)
        if grid_power_in[t] > 0 then
            printf "\nBF-BOF Total per ton:            %12.3f",
                (
                    coking_coal_in[t] * 2.6
                  + bf_pci_in[t]      * 2.5
                  + sinter_lime_in[t] * 0.44
                  + bf_lime_in[t]     * 0.44
                  + bof_lime_in[t]    * 0.44
                  + (
                        coke_power_in[t]
                      + sinter_power_in[t]
                      + bf_power_in[t]
                      + bof_power_in[t]
                      + pellets_bf_power[t]
                      -wasteheat_bf_bof[t]* 277.78 * N9_eta * N9_whr
                )* grid_ef[t]) / steel_bof[t];
        else
            printf "\nBF-BOF Total per ton:            %12.3f",
                (
                    coking_coal_in[t] * 2.6
                  + bf_pci_in[t]      * 2.5
                  + sinter_lime_in[t] * 0.44
                  + bf_lime_in[t]     * 0.44
                  + bof_lime_in[t]    * 0.44
                  - ccs_bf[t]
                ) / steel_bof[t];
    }
    else {
        printf "\nBF-BOF Scope 1 per ton:          %12.3f", 0;
        printf "\nBF-BOF Scope 2 per ton:          %12.3f", 0;
        printf "\nBF-BOF Total per ton:            %12.3f", 0;
    }

    # =====================================================
    # DRI–EAF EMISSIONS PER TON (OVERALL)
    # =====================================================
    if steel_eaf[t] > 0 then {

        # Scope 1 per ton (overall DRI–EAF)
        printf "\nDRI-EAF Scope 1 per ton:         %12.3f",
            (
                coaldri_coal_in[t] * 2.5
              + eaf_coal_in[t]     * 2.5
              + eaf_lime_in[t]     * 0.44
              + ngdri_ng_in[t]     * 2.75
            ) / steel_eaf[t];

        # Scope 2 per ton (overall DRI–EAF)
        if grid_power_in[t] > 0 then
            printf "\nDRI-EAF Scope 2 per ton:         %12.3f",
                (
                    coaldri_power_in[t]
                  + eaf_power_in[t]
                  + coaldri_pellet_power[t]
                  + ngdri_power_in[t]
                  + h2dri_power_in[t]
                  + ngdri_pellet_power[t]
                  + h2dri_pellet_power[t]
                  -wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr
                )* grid_ef[t] / steel_eaf[t];
        else
            printf "\nDRI-EAF Scope 2 per ton:         %12.3f", 0;

        # Total per ton (overall DRI–EAF)
        if grid_power_in[t] > 0 then
            printf "\nDRI-EAF Total per ton:           %12.3f",
                (
                    coaldri_coal_in[t] * 2.5
                  + eaf_coal_in[t]     * 2.5
                  + eaf_lime_in[t]     * 0.44
                  + ngdri_ng_in[t]     * 2.75
                  + (
                        coaldri_power_in[t]
                      + eaf_power_in[t]
                      + coaldri_pellet_power[t]
                      + ngdri_power_in[t]
                      + h2dri_power_in[t]
                      + ngdri_pellet_power[t]
                      + h2dri_pellet_power[t]
                      -wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr
                )* grid_ef[t]) / steel_eaf[t];
        else
            printf "\nDRI-EAF Total per ton:           %12.3f",
                (
                    coaldri_coal_in[t] * 2.5
                  + eaf_coal_in[t]     * 2.5
                  + eaf_lime_in[t]     * 0.44
                  + ngdri_ng_in[t]     * 2.75
                  - ccs_cdri[t]- ccs_ngdri[t]
                ) / steel_eaf[t];
    }
    else {
        printf "\nDRI-EAF Scope 1 per ton:         %12.3f", 0;
        printf "\nDRI-EAF Scope 2 per ton:         %12.3f", 0;
        printf "\nDRI-EAF Total per ton:           %12.3f", 0;
    }

    # =====================================================
    # SCRAP–EAF EMISSIONS PER TON
    # =====================================================
    if steel_scrap_eaf[t] > 0 then {

        # Scope 1 per ton (Scrap–EAF)
        printf "\nScrap-EAF Scope 1 per ton:       %12.3f",
            (
                scrap_eaf_coal_in[t] * 2.5
              + scrap_eaf_lime_in[t] * 0.44
            ) / steel_scrap_eaf[t];

        # Scope 2 per ton (Scrap–EAF)
        if grid_power_in[t] > 0 then
            printf "\nScrap-EAF Scope 2 per ton:       %12.3f",
                (scrap_eaf_power_in[t] 
                - scrap_eaf_wasteheat[t]* 277.78 * N9_eta * N9_whr
                )* grid_ef[t] / steel_scrap_eaf[t];
        else
            printf "\nScrap-EAF Scope 2 per ton:       %12.3f", 0;

        # Total per ton (Scrap–EAF)
        if grid_power_in[t] > 0 then
            printf "\nScrap-EAF Total per ton:         %12.3f",
                (
                    scrap_eaf_coal_in[t] * 2.5
                  + scrap_eaf_lime_in[t] * 0.44
                  + (scrap_eaf_power_in[t] 
                - scrap_eaf_wasteheat[t]* 277.78 * N9_eta * N9_whr
                )* grid_ef[t]) / steel_scrap_eaf[t];
        else
            printf "\nScrap-EAF Total per ton:         %12.3f",
                (
                    scrap_eaf_coal_in[t] * 2.5
                  + scrap_eaf_lime_in[t] * 0.44
                ) / steel_scrap_eaf[t];
    }
    else {
        printf "\nScrap-EAF Scope 1 per ton:       %12.3f", 0;
        printf "\nScrap-EAF Scope 2 per ton:       %12.3f", 0;
        printf "\nScrap-EAF Total per ton:         %12.3f", 0;
    }

    # =====================================================
    # DRI-TYPE SPLIT: COAL / NG / H2 DRI–EAF (PER TON STEEL)
    # =====================================================
    printf "\n\n🔬 DRI-TYPE ROUTE EMISSIONS PER TON (STEEL):";

    # ---------- Coal DRI–EAF ----------
    if steel_eaf[t] * f_cdri[t] > 0 then {

        printf "\nCoal DRI-EAF Scope 1 per ton:    %12.3f",
            (
                coaldri_coal_in[t]       * 2.5
              + eaf_coal_in[t] * f_cdri[t] * 2.5
              + eaf_lime_in[t] * f_cdri[t] * 0.44
            ) / (steel_eaf[t] * f_cdri[t]);

        if grid_power_in[t] > 0 then
            printf "\nCoal DRI-EAF Scope 2 per ton:    %12.3f",
                (
                    coaldri_power_in[t]
                  + coaldri_pellet_power[t]
                  + eaf_power_in[t] * f_cdri[t]
                  -wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr * f_cdri[t])
                  * grid_ef[t] / (steel_eaf[t] * f_cdri[t]);
              
        else
            printf "\nCoal DRI-EAF Scope 2 per ton:    %12.3f", 0;

        if grid_power_in[t] > 0 then
            printf "\nCoal DRI-EAF Total per ton:      %12.3f",
                (
                    coaldri_coal_in[t]       * 2.5
                  + eaf_coal_in[t] * f_cdri[t] * 2.5
                  + eaf_lime_in[t] * f_cdri[t] * 0.44
                  + (
                        coaldri_power_in[t]
                      + coaldri_pellet_power[t]
                      + eaf_power_in[t] * f_cdri[t]
                      -wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr * f_cdri[t])
                  * grid_ef[t]) / (steel_eaf[t] * f_cdri[t]);

        else
            printf "\nCoal DRI-EAF Total per ton:      %12.3f",
                (
                    coaldri_coal_in[t]       * 2.5
                  + eaf_coal_in[t] * f_cdri[t] * 2.5
                  + eaf_lime_in[t] * f_cdri[t] * 0.44
                  - ccs_cdri[t]
                ) / (steel_eaf[t] * f_cdri[t]);
    }
    else {
        printf "\nCoal DRI-EAF Scope 1 per ton:    %12.3f", 0;
        printf "\nCoal DRI-EAF Scope 2 per ton:    %12.3f", 0;
        printf "\nCoal DRI-EAF Total per ton:      %12.3f", 0;
    }

    # ---------- NG DRI–EAF ----------
    if steel_eaf[t] * f_ngdri[t] > 0 then {

        printf "\nNG DRI-EAF Scope 1 per ton:      %12.3f",
            (
                ngdri_ng_in[t]           * 2.75
              + eaf_coal_in[t] * f_ngdri[t] * 2.5
              + eaf_lime_in[t] * f_ngdri[t] * 0.44
            ) / (steel_eaf[t] * f_ngdri[t]);

        if grid_power_in[t] > 0 then
            printf "\nNG DRI-EAF Scope 2 per ton:      %12.3f",
                (
                    ngdri_power_in[t]
                  + ngdri_pellet_power[t]
                  + eaf_power_in[t] * f_ngdri[t]
                  - wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr * f_ngdri[t])
                  * grid_ef[t] / (steel_eaf[t] * f_ngdri[t]);
                
            printf "\nNG DRI-EAF Scope 2 per ton:      %12.3f", 0;

        if grid_power_in[t] > 0 then
            printf "\nNG DRI-EAF Total per ton:        %12.3f",
                (
                    ngdri_ng_in[t]           * 2.75
                  + eaf_coal_in[t] * f_ngdri[t] * 2.5
                  + eaf_lime_in[t] * f_ngdri[t] * 0.44
                  + (
                        ngdri_power_in[t]
                      + ngdri_pellet_power[t]
                      + eaf_power_in[t] * f_ngdri[t]
                       -wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr * f_ngdri[t])
                  * grid_ef[t]) / (steel_eaf[t] * f_ngdri[t]);
        else
            printf "\nNG DRI-EAF Total per ton:        %12.3f",
                (
                    ngdri_ng_in[t]           * 2.75
                  + eaf_coal_in[t] * f_ngdri[t] * 2.5
                  + eaf_lime_in[t] * f_ngdri[t] * 0.44
                  - ccs_ngdri[t]
                ) / (steel_eaf[t] * f_ngdri[t]);
    }
    else {
        printf "\nNG DRI-EAF Scope 1 per ton:      %12.3f", 0;
        printf "\nNG DRI-EAF Scope 2 per ton:      %12.3f", 0;
        printf "\nNG DRI-EAF Total per ton:        %12.3f", 0;
    }

    # ---------- H2 DRI–EAF ----------
    if steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]) > 0 then {

        printf "\nH2 DRI-EAF Scope 1 per ton:      %12.3f",
            (
                eaf_lime_in[t] * (1 - f_cdri[t] - f_ngdri[t]) * 0.44
            ) / (steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]));

        if grid_power_in[t] > 0 then
            printf "\nH2 DRI-EAF Scope 2 per ton:      %12.3f",
                (
                    h2dri_power_in[t]
                  + h2dri_pellet_power[t]
                  + eaf_power_in[t] * (1 - f_cdri[t] - f_ngdri[t])
                  - wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr * (1 - f_cdri[t] - f_ngdri[t]))
                  * grid_ef[t] / (steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]));
        else
            printf "\nH2 DRI-EAF Scope 2 per ton:      %12.3f", 0;

        if grid_power_in[t] > 0 then
            printf "\nH2 DRI-EAF Total per ton:        %12.3f",
                (
                    eaf_lime_in[t] * (1 - f_cdri[t] - f_ngdri[t]) * 0.44
                  + (
                        h2dri_power_in[t]
                      + h2dri_pellet_power[t]
                      + eaf_power_in[t] * (1 - f_cdri[t] - f_ngdri[t])
                      -wasteheat_eaf[t]* 277.78 * N9_eta * N9_whr * (1 - f_cdri[t] - f_ngdri[t]))
                  * grid_ef[t]) / (steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]));
        else
            printf "\nH2 DRI-EAF Total per ton:        %12.3f",
                (
                    eaf_lime_in[t] * (1 - f_cdri[t] - f_ngdri[t]) * 0.44
                ) / (steel_eaf[t] * (1 - f_cdri[t] - f_ngdri[t]));
    }
    else {
        printf "\nH2 DRI-EAF Scope 1 per ton:      %12.3f", 0;
        printf "\nH2 DRI-EAF Scope 2 per ton:      %12.3f", 0;
        printf "\nH2 DRI-EAF Total per ton:        %12.3f", 0;
    }

    # =====================================================
    # AVERAGE SYSTEM EMISSIONS PER TON
    # =====================================================
    if total_steel[t] > 0 then
        printf "\n\nAverage System Emissions:        %12.3f tCO2/ton",
            total_emissions[t] / total_steel[t];
    else
        printf "\n\nAverage System Emissions:        %12.3f tCO2/ton", 0;
        
    if total_steel[t] > 0 then
        printf "\n\nAverage Scope-1 Emissions:        %12.3f tCO2/ton",
            scope1_emissions[t] / total_steel[t];
    else
        printf "\n\nAverage Scope-1 Emissions:        %12.3f tCO2/ton", 0;
        
        if total_steel[t] > 0 then
        printf "\n\nAverage Scope-2 Emissions:        %12.3f tCO2/ton",
            scope2_emissions[t] / total_steel[t];
    else
        printf "\n\nAverage Scope-2 Emissions:        %12.3f tCO2/ton", 0;
        
   
    printf "\n";
}

      
      #wasteheat_eaf[t]* 277.78 * N9_eta
      #scrap_eaf_wasteheat[t] * 277.78 * N9_eta
   