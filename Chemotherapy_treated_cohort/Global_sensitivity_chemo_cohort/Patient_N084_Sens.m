% $Header: svn://.../trunk/AMIGO2R2016/IMC_BC_Analysis/Sensitivity_Analysis/Chemotherapy/Patient_NT084.m 2410 2015-12-07 13:58:57Z evabalsa $
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
%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='sens_imc_bc_chemotherapy_N84';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='sens_imc_chemo_pN84';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

%inputs.model.exe_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost    
inputs.model.input_model_type='charmodelC'; % Changed from 'charmodelC' to 'standard'

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
                            'Gr_treg','K_treg','alpha_cd4','alpha_hladr','k_ido','k_cd31t','k_tox','k_foxp3','k_helios','mu_treg',...
                            'Gr_teff','K_teff','alpha_ox40','alpha_icos','alpha_cd3','k_cd45','k_pdl1', 'mu_teff',...
                            'Gr_m','K_m','alpha_cd11c','alpha_cd68m', 'k_cd31m', 'k_pdpn', 'mu_m',...
                            'Gr_ec','K_ec','mu_ec',...
                            'Gr_f','K_f','alpha_pdgfrb','k_caveolin1e','mu_f');                  % Names of the parameters   


  
inputs.model.stimulus_names=char('kcarb_cc', 'kcarb_treg', 'kcarb_teff', 'kcarb_m', 'kcarb_ec', 'kcarb_f' );                                        % Names of the stimuli, inputs or controls 


inputs.model.eqns = char(...
    'dCC = Gr_cc*CC*(1- (CC/K_cc)) + (alpha_ar+alpha_ki67)*CC + (k_cd68+k_cd163)*M*CC + (k_vimentin+k_sma+k_caveolin1)*F*CC + k_cd31c*EC*CC - (k_pd1+k_cd8+k_gzmb)*Teff*CC - kcarb_cc*CC - mu_cc*CC; CC = max(CC, 1)', ...
    'dTreg = Gr_treg*Treg*(1- (Treg/K_treg)) + (alpha_cd4+alpha_hladr)*Treg - k_ido*M*Treg + k_cd31t*EC*Treg - k_tox*Teff*Treg - k_foxp3*Treg*Teff - k_helios*Treg*Teff - kcarb_treg*Treg - mu_treg*Treg; Treg = max(Treg, 0.85)', ...
    'dTeff = Gr_teff*Teff*(1- (Teff/K_teff)) + (alpha_ox40+alpha_icos+alpha_cd3)*Teff + k_tox*Teff*Treg - k_foxp3*Treg*Teff - k_helios*Treg*Teff - (k_pd1+k_cd8+k_gzmb)*Teff*CC - k_cd45*Teff*M - k_pdl1*M*Teff - kcarb_teff*Teff - mu_teff*Teff; Teff = max(Teff, 1)', ...
    'dM = Gr_m*M*(1- (M/K_m)) + (alpha_cd11c + alpha_cd68m)*M + k_cd45*Teff*M + k_cd31m*EC*M + k_pdpn*F*M - (k_cd163+k_cd68)*M*CC - k_ido*M*Treg - k_pdl1*M*Teff - kcarb_m*M - mu_m*M; M = max(M, 0.5)', ...
    'dEC = Gr_ec*EC*(1- (EC/K_ec)) - (k_vimentin-k_caveolin1)*F*EC - k_cd31c*EC*CC - k_cd31t*EC*Treg - k_cd31m*EC*M - kcarb_ec*EC - mu_ec*EC; EC = max(EC, 0.90)', ...
    'dF = Gr_f*F*(1- (F/K_f)) + alpha_pdgfrb*F - k_caveolin1e*EC*F + k_vimentin*EC*F - k_pdpn*M*F - (k_vimentin+k_sma+k_caveolin1)*F*CC - kcarb_f*F - mu_f*F; F = max(F, 1)');   




inputs.model.par=[8.05E-02 90 0.114 0.132 0.067 0.12 0.205 0.12 0.107 0.106 0.107 0.128 0.124 9.88E+00...   % CC parameters
                 4.11E+00 10 0.699 0.749 0.103 0.129 0.085 0.059 0.077 5.45E+00...   % Treg parameters
                 8.94E+00 17 0.823 0.703 0.057 0.561 0.109 1.71E+00... % Teff parameters
                 2.94E-01 35 0.823 0.652 0.101 0.084 6.91E+00...   % M parameters
                 2.90E+00 15 5.39E+00...      % EC parameters
                 5.50E+00 90 0.362 0.108 9.79E-02]; % F parameters % These values may be updated during optimization  


% 0.128; 0.068; 0.089; 0.113; 0.091; 0.129 
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=1;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
 inputs.exps.exp_y0{iexp}=[32.87 2.24 32.77 18.84 2.51 10.8];  %Initial conditions for each experiment          
 inputs.exps.t_f{iexp}= 3;  %Experiments duration
 end


 % OBSEVABLES DEFINITION  
 for iexp=1:inputs.exps.n_exp  
 inputs.exps.n_obs{iexp}=6;                            % Number of observed quantities per experiment  
 inputs.exps.obs_names{iexp}=char('Cancer_Cells','Regulatory_T_Cells','Effector_T_Cells','Macrophages','Endothelial_Cells','Fibroblast');      % Name of the observed quantities per experiment    
 inputs.exps.obs{iexp}=char('Cancer_Cells=CC','Regulatory_T_Cells=Treg','Effector_T_Cells=Teff','Macrophages=M','Endothelial_Cells=EC','Fibroblast=F');   % Observation functi
 end 





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 

% Sampling times and experimental data for each experiment
for iexp = 1:inputs.exps.n_exp
    inputs.exps.n_s{iexp} = 10;  % Number of sampling times
    % inputs.exps.t_s{iexp} = [0 2];  % Sampling times
    inputs.exps.t_s{iexp} = linspace(0, inputs.exps.t_f{iexp}, inputs.exps.n_s{iexp}); % Sampling times
end





 inputs.exps.u_interp{1}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{1}=8;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u{1}=[0.128; 0.068; 0.089; 0.113; 0.091; 0.129 ];
 inputs.exps.u_min{1}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 inputs.exps.u_max{1}=[0.128; 0.068; 0.089; 0.113; 0.091; 0.129 ];
 % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{1}=[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75, 1.875, 4];   



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

 %==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.PEsol.id_global_theta=char('Gr_cc','Gr_treg','Gr_teff','Gr_m','Gr_ec', 'Gr_f');  %  'all'|User selected  
inputs.PEsol.global_theta_max=15*ones(1,6);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0*ones(1,6); % Minimum allowed values for the paramters
inputs.PESol.global_theta_guess= rand(1,6).*inputs.model.par([1 15 25 33 40 43]);  % Value of the parameters for which the analysis will be performed    

%In_CC Gr_EC Gr_Treg Gr_CC Gr_M In_M In_Treg Gr_Teff In_F In_Teff
 %==================================
 % SIMULATION
 inputs.ivpsol.ivpsolver='cvodes';                     % [] IVP solver: 'radau5'(default, fortran)|'rkf45'|'lsodes'|


 inputs.ivpsol.senssolver='cvodes';                    % [] Sensitivities solver: 'cvodes' (C)


inputs.ivpsol.rtol = 1e-5;
inputs.ivpsol.atol = 1e-5;
 


 
%==================================
% GRank DATA
%==================================
 
 inputs.rank.gr_samples=10000;                         % [] Number of samples for global sensitivities and global rank within LHS (default: 10000)    
 
 
%==================================
% DISPLAY OF RESULTS
%==================================
% 
% 
inputs.plotd.plotlevel='full';                        % [] Display of figures: 'full'|'medium'(default)|'min' |'noplot' 
% inputs.plotd.figsave=1;









