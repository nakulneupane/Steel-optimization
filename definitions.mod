
# Crude Steel Production
param base_demand default 144000000;    # Steel production at year 2025
param growth_rate default 0.05;         # Production growth rate upto 2050

# Coke Oven
param N0_e_coke default 40;             
param N0_cf default 0.68;               
param N0_br_coal default 0.056;         
param N0_cog_c default 11.5;            
param N0_tar_c default 0.04;            
param N0_r_cog default 0.4;             
param N0_cost_coal default 130;         
param N0_cost_power default 0.08;       
param N0_credit_breeze default 85;      
param N0_credit_tar default 20;         
param N0_capex default 50;              

# Sinter
param N1_e_sinter default 40;           
param N1_lim_sint default 0.04;         
param N1_b_sint default 0.04;           
param N1_bio default 0;                 
param N1_ore_sint default 0.9;          
param N1_sintgas default 1;             
param N1_cost_breeze default 85;        
param N1_cost_fineore default 65;       
param N1_cost_power default 0.08;       
param N1_cost_lime default 60;          
param N1_cost_biochar default 75;       
param N1_capex default 30;              

# Pellets BF
param N8_e_pell default 40;             
param N8_y default 0.92;                
param N8_cost_fineore default 65;       
param N8_cost_power default 0.08;       
param N8_capex default 10;              

# Blast Furnace
param N2_e_hm default 40;             
param N2_s_hm default 1.1;            
param N2_o_hm default 0.15;           
param N2_c_hm default 0.55;           
param N2_p_hm default 0.15;           
param N2_biochar_target default 0.03; 
param N2_h2_target default 0.0007;     
param N2_l_hm default 0.025;          
param N2_sl_hm default 0.3;           
param N2_BFG_hm default 5;            
param N2_rec_BFG default 0.3;         
param N2_rec_COG default 0.02;        
param N2_pel_hm default 0.35;         
param N2_cost_lumpore default 70;     
param N2_cost_pci default 120;        
param N2_cost_power default 0.08;     
param N2_cost_lime default 60;        
param N2_cost_biochar default 75;     
param N2_cost_h2_start default 4500;  
param N2_cost_h2_end default 1500;    
param N2_credit_slag default 15;      
param N2_capex default 100;           

# BOF
param N3_e_bof default 150;           
param N3_s_bof default 0.1;           
param N3_ls_bof default 0.075;       
param N3_sl_bof default 0.095;       
param N3_BOFG default 0.8;            
param N3_COG default 1.75;            
param N3_cost_scrap default 350;      
param N3_cost_power default 0.08;     
param N3_cost_lime default 60;        
param N3_credit_slag default 15;      
param N3_capex default 60;            

# Pellets Coal DRI
param N6_e_pell default 40;          
param N6_y default 0.92;             
param N6_cost_fineore default 65;    
param N6_cost_power default 0.08;    
param N6_capex default 10;           

# Pellets NG DRI
param N13_e_pell default 40;         
param N13_y default 0.92;            
param N13_cost_fineore default 65;   
param N13_cost_power default 0.08;   
param N13_capex default 10;          

# Pellets H2 DRI
param N14_e_pell default 40;         
param N14_y default 0.92;            
param N14_cost_fineore default 65;   
param N14_cost_power default 0.08;   
param N14_capex default 10;          

# Coal DRI
param N5_e_dri default 130;          
param N5_pel_dri default 1.5;        
param N5_ore_dri default 0.1;        
param N5_c_dri default 1;            
param N5_cost_coal default 100;      
param N5_cost_power default 0.08;    
param N5_cost_lumpore default 70;    
param N5_capex_coal default 110;     

# NG DRI
param N11_e_dri default 130;        
param N11_ng_dri default 0.35;      
param N11_pel_dri default 1.5;      
param N11_ore_dri default 0.1;      
param N11_cost_power default 0.08;  
param N11_cost_NG default 450;      
param N11_cost_lumpore default 70;  
param N11_capex_ng_start default 130;  
param N11_capex_ng_end default 90;    
param ng_base default 10000000;      
param ng_growth default 0.10;        

# H2 DRI
param N12_e_dri default 140;         
param N12_h2_dri default 0.13;      
param N12_pel_dri default 1.5;      
param N12_ore_dri default 0.1;      
param N12_cost_power default 0.08;   
param N12_cost_H2_start default 4500;
param N12_cost_H2_end default 1500;   
param N12_capex_h2_start default 170;
param N12_capex_h2_end default 100;  
param N12_cost_lumpore default 70;   
param h2_start_year default 2030;    
param h2_slow_growth default 0.20;   
param h2_fast_growth default 0.40;   
param h2_base default 500000;        
param h2_intermediate_year default 2035;

# EAF (DRI-Based)
param N4_e_eaf default 650;          
param N4_phi_eaf default 0.1;        
param N4_eltrd default 0.003;        
param N4_ls default 0.05;            
param N4_cs default 0.01;            
param N4_ss default 0.15;            
param N4_eafg default 3;             
param N4_cost_scrap default 350;     
param N4_cost_lime default 60;       
param N4_cost_coal default 100;      
param N4_cost_power default 0.08;    
param N4_cost_electrode default 600; 
param N4_credit_slag default 15;     
param N4_capex default 70;           

# EAF (Scrap-Based)
param N10_e_eaf default 820;         
param N10_phi_eaf default 1.1;       
param N10_eltrd default 0.003;       
param N10_ls default 0.05;           
param N10_cs default 0.01;           
param N10_ss default 0.15;           
param N10_eafg default 3;            
param N10_cost_scrap default 330;    
param N10_cost_lime default 60;      
param N10_cost_coal default 100;     
param N10_cost_power default 0.08;   
param N10_cost_electrode default 600;
param N10_credit_slag default 15;    
param N10_capex default 70;          
param scrap_base default 32000000;   
param scrap_rate default 0.064;      
param scrap_years default 25;        

# Waste Heat Recovery
param N9_u default 7884;             
param N9_whr default 0.1;            
param N9_eta default 0.25;           
param N9_c default 0;                
param N9_credit_power default 0.02;  
param grid_ef_start_value default 0.000757;
param grid_ef_end_value default 0.0003;
param N9_capex default 60;           

# Carbon capture
param N15_ccs_eta default 0.85;                         
param N15_ccs_cost_bf_start default 150;   
param N15_ccs_cost_bf_end default 75;    
param N15_ccs_cost_cdri_start default 150;  
param N15_ccs_cost_cdri_end default 75;   
param N15_ccs_cost_ngdri_start default 180;  
param N15_ccs_cost_ngdri_end default 85;   

# Other parameters
param labor_cost default 20;            
param maintenance_cost default 15;      
param other_opex default 10;

