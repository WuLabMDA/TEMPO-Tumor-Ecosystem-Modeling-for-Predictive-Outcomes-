% $Header: svn://.../trunk/AMIGO2R2016/IMC_BC_Analysis/Chemotherapy/Chemo_Immuno_Patient_NT218.m 2410 2015-12-07 13:58:57Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: TITLE: The Imaging Mass Cytometry (IMC) Breast Cancer Data
%
%        Type :
%                > help circadian_tutorial
%        for a more detailed description of the model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        INPUT FILE TO ESTIMATE MODEL UKNOWNS
%
%        This is the minimum input file to simualate with real data.
%        Default values are assigned to non defined inputs.
%
%        Minimum required inputs:
%           > Paths related data
%           > Model:               model_type; n_st; n_par; n_stimulus; 
%                                  st_names; par_names; stimulus_names;  
%                                  eqns; par
%           > Experimental scheme: n_exp; exp_y0{iexp}; t_f{iexp}; 
%                                  u_interp{iexp}; t_con{iexp}; u{iexp}
%                                  n_obs{iexp}; obs_names{iexp}; obs{iexp} 
%
%                (AMIGO_PE)==>>    n_s{iexp}; t_s{iexp}; 
%                                  data_type; noise_type; 
%                                  exp_data{iexp}; [error_data{iexp}]
%                                  id_global_theta; [id_global_theta_y0]
%                                  [id_local_theta{iexp}];[id_local_theta_y0{iexp}]global_theta_max; global_theta_min
%                                  [global_theta_y0_max];[global_theta_y0_min]
%                                  [local_theta_max{iexp}];[local_theta_min{iexp}]
%                                  [local_theta_y0_max{iexp}];[local_theta_yo_min{iexp}]
%                                  [global_theta_guess];[global_theta_y0_guess];
%                                  [local_theta_guess{iexp}];[local_theta_y0_guess{iexp}]
%                                  [PEcost_type];[lsq_type];[llk_type]
%                                  []:optional inputs
%                                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='imc_bc_chemo_immunotherapy_54';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='imc_chemo_immuno_p54';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================


inputs.model.input_model_type='charmodelC';                 % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost                              
inputs.model.n_st=6;                                       % Number of states   
%====================================================================================
% Cancer Cells = CC
% Regulatory T-Cells = Treg
% Effector T-Cells = Teff
% Macrophages = M
% Endothelial Cells = EC
% Fibroblast = F
% Chemotherapy Drug = D
%
%
%=======================================================================================
inputs.model.n_par=54;                   

inputs.model.st_names=char('CC','Treg','Teff','M','EC','F');     % Names of the states 

inputs.model.par_names=char('Gr_cc','K_cc','alpha_ar','alpha_ki67','k_cd68','k_cd163','k_vimentin','k_sma','k_caveolin1','k_cd31c','k_pd1','k_cd8','k_gzmb','kcarb_cc', 'mu_cc',...
                            'Gr_treg','K_treg','alpha_cd4','alpha_hladr','k_ido','k_cd31t','k_tox','k_foxp3','k_helios', 'kcarb_treg', 'mu_treg',...
                            'Gr_teff','K_teff','alpha_ox40','alpha_icos','alpha_cd3', 'k_immun','k_cd45','kcarb_teff','mu_teff',...
                            'Gr_m','K_m','alpha_cd11c','alpha_cd68m', 'k_cd31m', 'k_pdpn', 'k_pdl1',  'kcarb_m','mu_m',...
                            'Gr_ec','K_ec','kcarb_ec','mu_ec',...
                            'Gr_f','K_f','alpha_pdgfrb','k_caveolin1e','kcarb_f','mu_f');                          % Names of the parameters   

inputs.model.eqns = char(...
    'dCC = Gr_cc*CC*(1- (CC/K_cc)) + (alpha_ar+alpha_ki67)*CC + (k_cd68+k_cd163)*M*CC + (k_vimentin+k_sma+k_caveolin1)*F*CC + k_cd31c*EC*CC - k_pd1*CC - (k_cd8+k_gzmb)*Teff*CC - kcarb_cc*CC - mu_cc*CC; CC = max(CC, 1)', ...
    'dTreg = Gr_treg*Treg*(1- (Treg/K_treg)) + (alpha_cd4+alpha_hladr)*Treg - k_ido*M*Treg + k_cd31t*EC*Treg - k_tox*Teff*Treg - k_foxp3*Treg - k_helios*Treg - kcarb_treg*Treg - mu_treg*Treg; Treg = max(Treg, 0.5)', ...
    'dTeff = Gr_teff*Teff*(1- (Teff/K_teff)) + (alpha_ox40+alpha_icos+alpha_cd3)*Teff + k_tox*Teff*Treg + k_immun*Teff - (k_cd8+k_gzmb)*Teff*CC - k_cd45*Teff*M - kcarb_teff*Teff - mu_teff*Teff; Teff = max(Teff, 1)', ...
    'dM = Gr_m*M*(1- (M/K_m)) + (alpha_cd11c + alpha_cd68m)*M + k_cd45*Teff*M + k_cd31m*EC*M + k_pdpn*F*M - (k_cd163+k_cd68)*M*CC - k_ido*M*Treg - k_pdl1*M - kcarb_m*M - mu_m*M; M = max(M, 0.5)', ...
    'dEC = Gr_ec*EC*(1- (EC/K_ec)) - (k_vimentin-k_caveolin1)*F*EC - k_cd31c*EC*CC - k_cd31t*EC*Treg - k_cd31m*EC*M - kcarb_ec*EC - mu_ec*EC; EC = max(EC, 0.5)', ...
    'dF = Gr_f*F*(1- (F/K_f)) + alpha_pdgfrb*F - k_caveolin1e*EC*F + k_vimentin*EC*F - k_pdpn*M*F - (k_vimentin+k_sma+k_caveolin1)*F*CC - kcarb_f*F - mu_f*F; F = max(F,1)');   



inputs.model.par=[0.015 45 0.116 0.103 0.098 0.126 0.388 0.122 0.224 0.135 0.618 0.333 0.230 0.118 0.198...   % CC parameters
                 0.0015 15 0.72 0.980 0.110 0.328 0.0099 0.0134 0.080 0.108 0.235...   % Treg parameters
                 8.095 50 0.300 0.421 0.128 0.467 0.113  0.105 0.001... % Teff parameters
                 4.510 30 0.30 0.298 0.1 0.112 0.120 0.109 0.02...   % M parameters
                 8.0431 10 0.104 0.021...      % EC parameters
                 9.485 65 0.1996 0.064 0.101 0.001]; % F parameters % These values may be updated during optimization  


% 0.015 0.198 0.0015 0.235 8.095 0.467 0.001 4.510 0.02 8.0431 0.021 0.485 0.001
% 
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=1;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
 inputs.exps.exp_y0{iexp}=[33.15 6.97 35.92 18.32 1.64 4.09];  %Initial conditions for each experiment          
 inputs.exps.t_f{iexp}= 2;  %Experiments duration
 end



 % OBSEVABLES DEFINITION  
 for iexp=1:inputs.exps.n_exp  
 inputs.exps.n_obs{iexp}=6;                            % Number of observed quantities per experiment  
 inputs.exps.obs_names{iexp}=char('Cancer_Cells','Regulatory_T_Cells','Effector_T_Cells','Macrophages','Endothelial_Cells','Fibroblast');      % Name of the observed quantities per experiment    
 inputs.exps.obs{iexp}=char('Cancer_Cells=CC','Regulatory_T_Cells=Treg','Effector_T_Cells=Teff','Macrophages=M','Endothelial_Cells=EC','Fibroblast=F');   % Observation function
 end 

 % inputs.exps.u_interp{1}='sustained';                  %Stimuli definition for experiment 1:
 %                                                       %OPTIONS:u_interp: 'sustained' |'step'|'linear'(default)|'pulse-up'|'pulse-down' 
 % inputs.exps.t_con{1}=[0 3];                         % Input swithching times: Initial and final time    
 % inputs.exps.u{1}=[1];                                 % Values of the inputs 

 %==================================
% EXPERIMENTAL DATA RELATED INFO
%==================================                                                            
 inputs.exps.n_s{1}=2;                                % [] Number of sampling times for each experiment.
%inputs.exps.n_s{2}=25;                                %    Optative input. By default "continuous" measurements are assumed.
 inputs.exps.t_s{1}=[0 2];                      % [] Sampling times for each experiment, by default equidistant
% inputs.exps.t_s{2}=[0 5 7 ...];                      % [] Sampling times for each experiment, by default equidistant

 inputs.exps.data_type='real';                         % Type of experimental data: 'real'|'pseudo'|'pseudo_pos'(>=0)  
 inputs.exps.noise_type='homo_var';                    % Type of experimental noise: Gaussian with zero mean and 
                                                       %                             Homoscedastic with constant variance: 'homo'
                                                       %                             Homoscedastic with varying variance:'homo_var'
                                                       %                             Heteroscedastic: 'hetero' 

                                                       % Experimental data per experiment n_s{iexp}x n_obs{iexp}
inputs.exps.exp_data{1}=[                              
		33.15 6.97 35.92 18.32 1.64 4.09
        %18.39 6.84 16.77 15.87 2.71 39.42 
       3.79 0.546 25.48 36.34 0.63 41.03 
		];

% Experimental noise, n_s{iexp}x n_obs{iexp}
% inputs.exps.error_data{1}=[  
%     %0.6890 0.8015 0.937 0.0789 0.7630 0.6545 
%     0.9890 0.015 0.997 0.8989 1.0130 1.40745 
% 	0.10890 0.0315 0.1397 0.1499 1.01430 1.10745 
% 		];

%==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)


inputs.PEsol.id_global_theta=char('Gr_cc', 'mu_cc',...
                            'Gr_treg', 'mu_treg',...
                            'Gr_teff','k_immun','mu_teff',...
                            'Gr_m','mu_m',...
                            'Gr_ec','mu_ec',...
                            'Gr_f','mu_f');  %  'all'|User selected 
inputs.PEsol.global_theta_guess=[0.015 0.198 0.0015 0.235 8.095 0.467 0.001 4.510 0.02 8.0431 0.021 0.485 0.001];
inputs.PEsol.global_theta_max=10*ones(1,13);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0*ones(1,13); % Minimum allowed values for the paramters



%==================================
% COST FUNCTION RELATED DATA
%==================================
         
inputs.PEsol.PEcost_type='lsq';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost' 
inputs.PEsol.llk_type='homo_var';                     % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero' 



%==================================
% NUMERICAL METHODS
%==================================

%
% SIMULATION
%
 inputs.ivpsol.ivpsolver='rkf45';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|


 inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)


 inputs.ivpsol.rtol=1.0D-6;                            % [] IVP solver integration tolerances
 inputs.ivpsol.atol=1.0D-6; 
 
%
% OPTIMIZATION
%
inputs.nlpsol.nlpsolver='hyb_de_fmincon';                        % [] NLP solver: 
%                                                       % LOCAL: 'local_fmincon'|'local_n2fb'|'local_dn2fb'|'local_dhc'|
%                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'||'local_nl2sol'
%                                                       %        'local_lsqnonlin'
%                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
%                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|'multi_nl2sol'
%                                                       %            'multi_lsqnonlin'
%                                                       % GLOBAL: 'de'|'sres'
%                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_n2fb'|'hyb_de_dn2fb'|'hyb_de_dhc'|'hyp_de_ipopt'|
%                                                       %         'hyb_de_solnp'|'hyb_de_nomad'|
%                                                       %         'hyb_sres_fmincon'|'hyb_sres_n2fb'|'hyb_sres_dn2fb'|'hyb_sres_dhc'|
%                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'
%                                                       % METAHEURISTICS:
%                                                       % 'ess' or 'eSS' (default)
%                                                       % Note that the corresponding defaults are in files: 
%                                                       % OPT_solvers\DE\de_options.m; OPT_solvers\SRES\sres_options.m; 
%                                                       % OPT_solvers\eSS_**\ess_options.m
%                                                       
                                                       
%inputs.nlpsol.eSS.log_var = 1:9;
inputs.nlpsol.eSS.maxeval = 100000;
inputs.nlpsol.eSS.maxtime = 2;


inputs.nlpsol.eSS.local.solver = 'lsqnonlin';
inputs.nlpsol.eSS.local.finish = 'lsqnonlin';



% %==================================
% % DISPLAY OF RESULTS
% %==================================
% 
% 
inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot'  