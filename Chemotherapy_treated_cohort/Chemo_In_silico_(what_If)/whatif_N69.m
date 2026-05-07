% $Header: svn://.../trunk/AMIGO2R2016/IMC_BC_Analysis/Chemotherapy/Chemo_Patient_Sobs_NT069.m 2410 2015-12-07 13:58:57Z evabalsa $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: TITLE: The Imaging Mass Cytometry (IMC) Breast Cancer Data
%
%        Type :
%                > help circadian_tutorial
%        for a more detailed description of the model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        INPUT FILE TO SIMULATE OBSERVABLES
%
%        This is the minimum input file for observables simulation. 
%        Default values are assigned to non defined inputs.
%
%        Minimum required inputs:
%           > Paths related data
%           > Model:               model_type; n_st; n_par; n_stimulus; 
%                                  st_names; par_names; stimulus_names;  
%                                  eqns; par
%           > Experimental scheme: n_exp; exp_y0{iexp}; t_f{iexp}; 
%                                  u_interp{iexp}; t_con{iexp}; u{iexp}
%
%                 (AMIGO_SObs)==>> n_obs{iexp}; obs_names{iexp}; obs{iexp}    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='whatif_imc_bc_chemotherapy_N69';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='whatif_imc_chemo_N69';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

%inputs.model.exe_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost    
inputs.model.input_model_type='charmodelC'; % Changed from 'charmodelC' to 'standard'

% Add simulation settings
inputs.ivpsol.ivpsolver = 'rkf45';
inputs.ivpsol.senssolver = 'sensmat';

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
inputs.model.n_par=47;                   

inputs.model.n_stimulus=6;   

inputs.model.st_names=char('CC','Treg','Teff','M','EC','F');     % Names of the states 

inputs.model.names_type = 'custom';

inputs.model.par_names=char('Gr_cc','K_cc','alpha_ar','alpha_ki67','k_cd68','k_cd163','k_vimentin','k_sma','k_caveolin1','k_cd31c','k_pd1','k_cd8','k_gzmb', 'mu_cc',...
                            'Gr_treg','K_treg','alpha_cd4','alpha_hladr','k_ido','k_cd31t','k_tox','k_foxp3','k_helios', 'mu_treg',...
                            'Gr_teff','K_teff','alpha_ox40','alpha_icos','alpha_cd3','k_cd45','k_pdl1','mu_teff',...
                            'Gr_m','K_m','alpha_cd11c','alpha_cd68m', 'k_cd31m', 'k_pdpn', 'mu_m',...
                            'Gr_ec','K_ec','mu_ec',...
                            'Gr_f','K_f','alpha_pdgfrb','k_caveolin1e','mu_f');                  % Names of the parameters   

inputs.model.eqns = char(...
    'dCC = Gr_cc*CC*(1- (CC/K_cc)) + (alpha_ar+alpha_ki67)*CC + (k_cd68+k_cd163)*M*CC + (k_vimentin+k_sma+k_caveolin1)*F*CC + k_cd31c*EC*CC - (k_pd1+k_cd8+k_gzmb)*Teff*CC - kcarb_cc*CC - mu_cc*CC; CC = max(CC, 1)', ...
    'dTreg = Gr_treg*Treg*(1- (Treg/K_treg)) + (alpha_cd4+alpha_hladr)*Treg - k_ido*M*Treg + k_cd31t*EC*Treg - k_tox*Teff*Treg - k_foxp3*Treg*Teff - k_helios*Treg*Teff - kcarb_treg*Treg - mu_treg*Treg; Treg = max(Treg, 0.5)', ...
    'dTeff = Gr_teff*Teff*(1- (Teff/K_teff)) + (alpha_ox40+alpha_icos+alpha_cd3)*Teff + k_tox*Teff*Treg - k_foxp3*Treg*Teff - k_helios*Treg*Teff - (k_pd1+k_cd8+k_gzmb)*Teff*CC - k_cd45*Teff*M - k_pdl1*M*Teff - kcarb_teff*Teff - mu_teff*Teff; Teff = max(Teff, 1)', ...
    'dM = Gr_m*M*(1- (M/K_m)) + (alpha_cd11c + alpha_cd68m)*M + k_cd45*Teff*M + k_cd31m*EC*M + k_pdpn*F*M - (k_cd163+k_cd68)*M*CC - k_ido*M*Treg - k_pdl1*M*Teff - kcarb_m*M - mu_m*M; M = max(M, 0.5)', ...
    'dEC = Gr_ec*EC*(1- (EC/K_ec)) - (k_vimentin-k_caveolin1)*F*EC - k_cd31c*EC*CC - k_cd31t*EC*Treg - k_cd31m*EC*M - kcarb_ec*EC - mu_ec*EC; EC = max(EC, 0.90)', ...
    'dF = Gr_f*F*(1- (F/K_f)) + alpha_pdgfrb*F - k_caveolin1e*EC*F + k_vimentin*EC*F - k_pdpn*M*F - (k_vimentin+k_sma+k_caveolin1)*F*CC - kcarb_f*F - mu_f*F; F = max(F, 1)');   


inputs.model.stimulus_names=char('kcarb_cc', 'kcarb_treg', 'kcarb_teff', 'kcarb_m', 'kcarb_ec', 'kcarb_f' );                                        % Names of the stimuli, inputs or controls 


inputs.model.par=[1.6144e-02 65 0.114 0.132 0.056 0.123 0.575 0.129 0.186 0.128 0.135 0.131 0.123 9.8144e+00...   % CC parameters
                 2.0167e+00 35 0.464 0.39 0.109 0.104 0.082 0.407 0.085 5.0167e+00...   % Treg parameters
                 9.9167e+00 65 0.625 0.894 0.213 0.100 0.106 1.0167e-01... % Teff parameters
                 1.7167e-01 30 0.123 0.452 0.101 0.084 9.0167e+00...   % M parameters
                 2.5167e+00 25 4.6167e+00...      % EC parameters
                 7.0167e+00 65 0.362 0.108 8.0167e-01]; % F parameters % These values may be updated during optimization  


%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=2;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
 inputs.exps.exp_y0{iexp}=[14.40 15.56 38.95 5.52 3.95 21.54];  %Initial conditions for each experiment          
 inputs.exps.t_f{iexp}= 3;  %Experiments duration
 end



 % OBSEVABLES DEFINITION  
 for iexp=1:inputs.exps.n_exp  
 inputs.exps.n_obs{iexp}=6;                            % Number of observed quantities per experiment  
 inputs.exps.obs_names{iexp}=char('Cancer_Cells','Regulatory_T_Cells','Effector_T_Cells','Macrophages','Endothelial_Cells','Fibroblast');      % Name of the observed quantities per experiment    
 inputs.exps.obs{iexp}=char('Cancer_Cells=CC','Regulatory_T_Cells=Treg','Effector_T_Cells=Teff','Macrophages=M','Endothelial_Cells=EC','Fibroblast=F');   % Observation function
 end 



 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Sampling times and experimental data for each experiment
for iexp = 1:inputs.exps.n_exp
    inputs.exps.n_s{iexp} = 2;  % Number of sampling times
    inputs.exps.t_s{iexp} = [0 2];  % Sampling times
end

% % Experimental data for all experiments
% for iexp = 1:inputs.exps.n_exp
% 
%   inputs.exps.exp_data{1}=[                              
% 		50.39 3.69 21.45 4.16 5.72 14.59 
%         %18.39 6.84 16.77 15.87 2.71 39.42 
%         35.03 0.650 1.58 12.52 7.88 2.56 
% 		];
% 
% 
% 
% end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

 % inputs.exps.u_interp{1}='sustained';                 %Stimuli definition for experiment 2
 % %inputs.exps.n_pulses{1}=10;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 % inputs.exps.u{1}=[0.123; 0.121; 0.201; 0.107;0.111; 0.124];
 % % inputs.exps.u_min{1}=[0.155; 0.16; 0.090; 0.155; 0.005; 0.1075];
 % % inputs.exps.u_max{1}=[0.155; 0.16; 0.090; 0.155; 0.005; 0.1075];
 % % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 % inputs.exps.t_con{1}=[0 4];                    %Times of switching: Initial time, Intermediate times, Final time










 inputs.exps.u_interp{1}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{1}=8;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u{1}=[0.105; 0.177; 0.111; 0.147;0.0104; 0.136];
 inputs.exps.u_min{1}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 inputs.exps.u_max{1}=[0.105; 0.177; 0.111; 0.147;0.0104; 0.136];
  % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{1}=[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75, 1.875, 4]; 





 inputs.exps.u_interp{2}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{2}=16;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u{2}=[0.105; 0.177; 0.111; 0.147;0.0104; 0.136];
 inputs.exps.u_min{2}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 inputs.exps.u_max{2}=[0.105; 0.177; 0.111; 0.147;0.0104; 0.136];
 % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{2}=[0 :0.125 :4];   


 
 % inputs.exps.u_interp{4}='pulse-down';                 %Stimuli definition for experiment 2
 % inputs.exps.n_pulses{4}=1;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 % inputs.exps.u{4}=[0.123; 0.121; 0.201; 0.107;0.111; 0.124];
 % inputs.exps.u_min{4}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 % inputs.exps.u_max{4}=[0.123; 0.121; 0.201; 0.107;0.111; 0.124];
 % % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 % inputs.exps.t_con{4}=[0 :2 :4];   


inputs.ivpsol.rtol = 1e-10;
inputs.ivpsol.atol = 1e-10;
 











%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%