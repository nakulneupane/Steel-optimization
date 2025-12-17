set T ordered := 2025..2050;
# Crude Steel Production
param base_demand := 144000000;    # Steel production at year 2025
param growth_rate := 0.05;         # Production growth rate upto 2050

# Coke Oven
param N0_e_coke := 40;             # Electricity per ton coke produced (kWh/ton)
param N0_cf := 0.68;               # Coking fraction
param N0_br_coal := 0.056;         # Breeze per ton coking coal (ton/ton)
param N0_cog_c := 11.5;            # COG per ton coal (GJ/ton)
param N0_tar_c := 0.04;            # Tar per ton coal (ton/ton)
param N0_r_cog := 0.4;             # cog recovered fraction
param N0_cost_coal := 130;         # Cost per ton of coal ($/ton)
param N0_cost_power := 0.08;       # Cost per kWh of Power ($/kWh)
param N0_credit_breeze := 85;      # Cost per ton of breeze ($/ton)
param N0_credit_tar := 20;         # Cost per ton of tar ($/ton)
param N0_capex := 50;              # CAPEX of coke oven plant per ton of crude steel ($/ton)

# Sinter
param N1_e_sinter := 40;           # Electricity per ton of sinter (kWh/t)
param N1_lim_sint := 0.04;         # Lime per ton of sinter (ton/ton)
param N1_b_sint := 0.04;           # Breeze per ton of sinter (ton/ton)
param N1_bio := 0;                 # Biochar per ton of sinter (ton/ton)
param N1_ore_sint := 0.9;          # Fine ore per ton sinter (ton/ton)
param N1_sintgas := 1;             # Energy content of sinter gas per ton sinter (GJ/t)
param N1_cost_breeze := 85;        # Cost per ton of breeze ($/ton)
param N1_cost_fineore := 65;       # Cost per ton of fineore ($/ton)
param N1_cost_power := 0.08;       # Cost per kWh of power ($/kWh)
param N1_cost_lime := 60;          # Cost per ton of lime ($/ton)
param N1_cost_biochar := 75;       # Cost per ton of biochar ($/ton)
param N1_capex := 30;              # CAPEX of sinter plant per ton of Crude steel ($/ton)

# Pellets BF
param N8_e_pell := 40;             # Electricity per ton pellets (kWh/ton)
param N8_y := 0.92;                # Pellets yield per ton ore (ton/ton)
param N8_cost_fineore := 65;       # Cost per ton of fineore ($/ton)
param N8_cost_power := 0.08;       # Cost per kWh of power ($/kWh)
param N8_capex := 10;              # CAPEX of pellets plant for BF-BOF per ton of crude steel ($/ton)

# Blast Furnace
param N2_e_hm := 40;             # Electricity per ton hot metal (kWh/ton)
param N2_s_hm := 1.1;            # Sinter per ton hot metal (ton/ton)
param N2_o_hm := 0.15;           # Lump ore per ton hot metal (ton/ton)
param N2_c_hm := 0.55;           # Coke per ton hot metal (ton/ton)
param N2_p_hm := 0.15;           # PCI per ton hot metal (ton/ton)
param N2_biochar_target := 0.03; # Biochar per ton hot metal by 2050 (ton/ton)
param N2_h2_target :=0.0007;     # Hydrogen per thm by 2050 (ton/ton)
param N2_l_hm := 0.025;          # Lime per ton hot metal (ton/ton)
param N2_sl_hm := 0.3;           # Slag per ton hot metal (ton/ton)
param N2_BFG_hm := 5;            # Blast Furnace Gas (BFG) per ton hot metal (GJ/ton)
param N2_rec_BFG := 0.3;         # Fraction of BFG recovered
param N2_rec_COG := 0.02;        # Fraction of COG recovered
param N2_pel_hm := 0.35;         # Pellets per ton hot metal (ton/ton)
param N2_cost_lumpore := 70;     # Cost per ton of lumpore ($/ton)
param N2_cost_pci := 120;        # Cost per ton of pulverized coal ($/ton)
param N2_cost_power := 0.08;     # Cost per kWh of power ($/kWh)
param N2_cost_lime := 60;        # Cost per ton of lime ($/ton)
param N2_cost_biochar := 75;     # Cost per ton of biochar ($/ton)
param N2_cost_h2{t in T} :=
    if t <= 2030 then 4500
    else 4500 - ( (t - 2030) / (2050 - 2030) ) * (4500 - 1500);  # Dynamic cost of hydrogen ($/ton)
param N2_credit_slag := 15;      # Cost per ton of slag ($/ton)
param N2_capex := 100;           # CAPEX of blast furnace per ton of crude steel ($/ton)

# BOF
param N3_e_bof := 150;           # Electricity per ton crude steel (kWh/ton)
param N3_s_bof := 0.1;           # Scrap per ton crude steel used in BOF (ton/ton)
param N3_ls_bof := 0.075;        # Limestone per ton crude steel in BOF (ton/ton)
param N3_sl_bof := 0.095;        # BOF slag per ton steel (ton/ton)
param N3_BOFG := 0.8;            # BOF Gas per ton of steel (GJ/t)
param N3_COG := 1.75;            # COG per ton of crude steel (GJ/t)
param N3_cost_scrap := 350;      # Cost per ton of scrap ($/ton)
param N3_cost_power := 0.08;     # Cost per kWh of power ($/kWh)
param N3_cost_lime := 60;        # Cost per ton of lime ($/ton)
param N3_credit_slag := 15;      # Cost per ton of slag ($/ton)
param N3_capex := 60;            # CAPEX of BOF per ton of crude steel ($/ton)

# Pellets Coal DRI
param N6_e_pell := 40;          #Electricity per ton pellets (kWh/ton)
param N6_y := 0.92;             # Pellets yield per ton ore
param N6_cost_fineore := 65;    # Cost per ton of fineore ($/ton)
param N6_cost_power := 0.08;    # Cost per kWh of power ($/kWh)
param N6_capex := 10;           # CAPEX of pellets plant for CoalDRI per ton of crude steel

# Pellets NG DRI
param N13_e_pell := 40;          #Electricity per ton pellets (kWh/ton)
param N13_y := 0.92;             # Pellets yield per ton ore
param N13_cost_fineore := 65;    # Cost per ton of fineore ($/ton)
param N13_cost_power := 0.08;    # Cost per kWh of power ($/kWh)
param N13_capex := 10;           # CAPEX of pellets plant for NG-DRI per ton of crude steel

# Pellets H2 DRI
param N14_e_pell := 40;         #Electricity per ton pellets (kWh/ton)
param N14_y := 0.92;            # Pellets yield per ton ore
param N14_cost_fineore := 65;   # Cost per ton of fineore ($/ton)
param N14_cost_power := 0.08;   # Cost per kWh of power ($/kWh)
param N14_capex := 10;          # CAPEX of pellets plant for H2-DRI per ton of crude steel

# Coal DRI
param N5_e_dri := 130;          # Electricity per ton DRI (kWh/ton)
param N5_pel_dri := 1.5;        # Pellets per ton dri (ton/ton)
param N5_ore_dri := 0.1;        # Iron ore per ton dri (ton/ton)
param N5_c_dri := 1;            # Coal per ton DRI (ton/ton)
param N5_cost_coal := 100;      # Cost per ton of coal ($/ton)
param N5_cost_power := 0.08;    # Cost per kWh of power ($/kWh)
param N5_cost_lumpore := 70;    # Cost per ton of lumpore ($/ton)
param N5_capex_coal := 110;     # CAPEX of coalDRI plant per ton of crude steel ($/ton)

# NG DRI
param N11_e_dri := 130;        # Electricity per ton DRI (kWh/ton)
param N11_ng_dri := 0.35;      # Natural gas per ton DRI (ton/ton)
param N11_pel_dri := 1.5;      # Pellets per ton dri (ton/ton)
param N11_ore_dri := 0.1;      # Iron ore per ton dri (ton/ton)
param N11_cost_power := 0.08;  # Cost per kWh of power ($/kWh)
param N11_cost_NG := 450;      # Cost per ton of NG ($/ton)
param N11_cost_lumpore := 70;  # Cost per ton of lumpore ($/ton)
param N11_capex_ng{t in T} :=
    if t <= 2025 then 130
    else 130 - ( (t - 2025) / (2050 - 2025) ) * (130 - 90);  # Dynamic CAPEX of NG-DRI plant per ton crude steel ($/ton)
param ng_base := 10000000;      # Natural gas available for steel sector in 2025 (tons)
param ng_growth := 0.10;        # Annual growth rate of natural gas availability

# H2 DRI
param N12_e_dri := 140;         # Electricity per ton DRI (kWh/ton)
param N12_h2_dri := 0.13;       # Hydrogen per ton DRI (ton/ton)
param N12_pel_dri := 1.5;       # Pellets per ton dri (ton/ton)
param N12_ore_dri := 0.1;       # Iron ore per ton dri (ton/ton)
param N12_cost_power := 0.08;   # Cost per kWh of power ($/kWh)
param N12_cost_H2{t in T} :=
    if t <= 2030 then 4500
    else 4500 - ( (t - 2030) / (2050 - 2030) ) * (4500 - 1500);  # Dynamic price of H2 ($/ton)
param N12_cost_lumpore := 70;   # Cost per ton of lumpore ($/ton)
param N12_capex_h2{t in T} :=
    if t <= 2030 then 170
    else 170 - ( (t - 2030) / (2050 - 2030) ) * (170 - 100); # Dynamic CAPEX of H2-DRI plant per ton crude steel ($/ton)
param h2_start_year := 2030;    # Year from when hydrogen becomes available for iron and steel sector
param h2_slow_growth := 0.20;   # Assumed slow growth rate of hydrogen in initial years
param h2_fast_growth := 0.40;   # Assumed fast growth rate of hydrogen in later years
param h2_base := 500000;        # Tons of hydrogen that might be available in start year of hydrogen (tons)
param h2_avail{t in T} :=
    if t < h2_start_year then 0
    else h2_base
         * (1 + h2_slow_growth)^( min(t,2035) - h2_start_year )
         * (1 + h2_fast_growth)^( max(t-2035, 0) );   # Dynamic availability cap of hydrogen over the years (tons)

# EAF (DRI-Based)
param N4_e_eaf := 650;          # Electricity per ton steel produced from EAF (Kwh/ton)
param N4_phi_eaf := 0.1;        # Frcation of scrap used in eaf
param N4_eltrd := 0.003;        # Mass of electrodes per ton of steel produced (ton/ton)
param N4_ls := 0.05;            # Limestone per ton steel (ton/ton)
param N4_cs := 0.01;            # Coal per ton steel (ton/ton)
param N4_ss := 0.15;            # Slag per ton steel (ton/ton)
param N4_eafg := 3;             # EAF gas per ton steel (GJ/ton)
param N4_cost_scrap := 350;     # Cost per ton of scrap ($/ton)
param N4_cost_lime := 60;       # Cost per ton of lime ($/ton)
param N4_cost_coal := 100;      # Cost per ton of coal ($/ton)
param N4_cost_power := 0.08;    # Cost per kWh of power ($/kWh)
param N4_cost_electrode := 600; # Cost per ton of electrode ($/ton)
param N4_credit_slag := 15;     # Cost per ton of slag ($/ton)
param N4_capex := 70;           # CAPEX of EAF (DRI-based) plant per ton of crude steel ($/ton)

# EAF (Scrap-Based)
param N10_e_eaf := 820;          # Electricity per ton steel produced from EAF (Kwh/ton)
param N10_phi_eaf := 1.1;        # Frcation of scrap used in eaf
param N10_eltrd := 0.003;        # Mass of electrodes per ton of steel produced (ton/ton)
param N10_ls := 0.05;            # Limestone per ton steel (ton/ton)
param N10_cs := 0.01;            # Coal per ton steel (ton/ton)
param N10_ss := 0.15;            # Slag per ton steel (ton/ton)
param N10_eafg := 3;             # EAF gas per ton steel (GJ/ton)
param N10_cost_scrap := 330;     # Cost per ton of scrap ($/ton)
param N10_cost_lime := 60;       # Cost per ton of lime ($/ton)
param N10_cost_coal := 100;      # Cost per ton of coal ($/ton)
param N10_cost_power := 0.08;    # Cost per kWh of power ($/kWh)
param N10_cost_electrode := 600; # Cost per ton of electrode ($/ton)
param N10_credit_slag := 15;     # Cost per ton of slag ($/ton)
param N10_capex := 70;           # CAPEX of EAF (Scrap-based) plant per ton of crude steel ($/ton)
param scrap_base  := 32000000;   # Scrap available  in 2025 (tons)
param scrap_rate  := 0.064;      # Annual growth rate of scrap
param scrap_years := 25;         # Total years in timeseries
param scrap_limit{t in T} :=
    scrap_base * (1 + scrap_rate) ** (ord(t) - 1); # Scrap availability cap 

# Waste Heat Recovery
param N9_u :=7884;                # Utilization hours (hrs/year)
param N9_whr :=0.1;               # Adoption rate of whr throughout country (scale of 0 to 1)
param N9_eta := 0.25;             # Conversion efficiency from heat to power
param N9_c := 0;                  # Existing waste heat capacity (kWh)
param N9_credit_power := 0.02;    # Credit per ton of power generated ($/ton)
param grid_ef{t in T} :=
    if t <= 2025 then 0.000757
    else 0.000757 - ( (t - 2025) / (2050 - 2025) ) * (0.000757 - 0.0003);  # Dynamic grid emission factor (ton CO2/kWh)
param N9_capex := 60;             # CAPEX of WHRS per ton of steel manufactured

#Carbon capture
param N15_ccs_eta := 0.85;                         # Carbon capture efficiency
param N15_ccs_cost_bf {t in T} :=
    150 - (150 - 75) * (ord(t)-1) / (card(T)-1);   # Carbon capture cost for blast furnace ($/ton CO2)

param N15_ccs_cost_cdri {t in T} :=
    150 - (150 - 75) * (ord(t)-1) / (card(T)-1);   # Carbon capture cost for CoalDRI ($/ton CO2)

param N15_ccs_cost_ngdri {t in T} :=
    180 - (180 - 85) * (ord(t)-1) / (card(T)-1);   # Carbon capture cost for H2-DRI ($/ton CO2)
    
# Other parameters
param labor_cost := 20;            # Labor cost per ton crude steel
param maintenance_cost := 15;      # Maintenance cost per ton crude steel
param other_opex := 10;            # Other OPEX per ton crude steel



    
    
    

    
