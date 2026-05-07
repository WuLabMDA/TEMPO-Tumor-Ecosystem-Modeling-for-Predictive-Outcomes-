% $Header: svn://.../trunk/AMIGO2R2016/IMC_BC_Analysis/Chemotherapy_Immunotherapy/Chemo_Immuno_Patient_Sobs_NT107.m 2410 2015-12-07 13:58:57Z evabalsa $
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

inputs.pathd.results_folder='sens_imc_bc_chemotherapy_immuno_p107_inhib';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='sens_imc_chemo_immuno_p107_inhib';                      % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

%inputs.model.exe_type='charmodelC';                % Model introduction: 'charmodelC'|'c_model'|'charmodelM'|'matlabmodel'|'sbmlmodel'|                        
                                                           %                     'blackboxmodel'|'blackboxcost    
inputs.model.input_model_type='charmodelC'; % Changed from 'charmodelC' to 'standard'

% % Add simulation settings
% inputs.ivpsol.ivpsolver = 'rkf45';
% inputs.ivpsol.senssolver = 'sensmat';

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

inputs.model.n_stimulus=7;   

inputs.model.st_names=char('CC','Treg','Teff','M','EC','F');     % Names of the states 
inputs.model.names_type= 'custom';

inputs.model.par_names=char('Gr_cc','K_cc','alpha_ar','alpha_ki67','k_cd68','k_cd163','k_vimentin','k_sma','k_caveolin1','k_cd31c','k_pd1','k_cd8','k_gzmb', 'mu_cc',...
                            'Gr_treg','K_treg','alpha_cd4','alpha_hladr','k_ido','k_cd31t','k_tox','k_foxp3','k_helios', 'mu_treg',...
                            'Gr_teff','K_teff','alpha_ox40','alpha_icos','alpha_cd3', 'k_cd45','mu_teff',...
                            'Gr_m','K_m','alpha_cd11c','alpha_cd68m', 'k_cd31m', 'k_pdpn', 'k_pdl1',  'mu_m',...
                            'Gr_ec','K_ec','mu_ec',...
                            'Gr_f','K_f','alpha_pdgfrb','k_caveolin1e','mu_f');                          % Names of the parameters   
             % Names of the parameters   

inputs.model.stimulus_names=char('kcarb_cc', 'kcarb_treg', 'k_immun', 'kcarb_teff', 'kcarb_m', 'kcarb_ec', 'kcarb_f' );



inputs.model.eqns = char(...
    'dCC = Gr_cc*CC*(1- (CC/K_cc)) + (alpha_ar+alpha_ki67)*CC + (k_cd68+k_cd163)*M*CC + (k_vimentin+k_sma+k_caveolin1)*F*CC + k_cd31c*EC*CC - k_pd1*CC - (k_cd8+k_gzmb)*Teff*CC - kcarb_cc*CC - mu_cc*CC; CC = max(CC, 1)', ...
    'dTreg = Gr_treg*Treg*(1- (Treg/K_treg)) + (alpha_cd4+alpha_hladr)*Treg - k_ido*M*Treg + k_cd31t*EC*Treg - k_tox*Teff*Treg - k_foxp3*Treg - k_helios*Treg - kcarb_treg*Treg - mu_treg*Treg; Treg = max(Treg, 0.5)', ...
    'dTeff = Gr_teff*Teff*(1- (Teff/K_teff)) + (alpha_ox40+alpha_icos+alpha_cd3)*Teff + k_tox*Teff*Treg + k_immun*Teff - (k_cd8+k_gzmb)*Teff*CC - k_cd45*Teff*M - kcarb_teff*Teff - mu_teff*Teff; Teff = max(Teff, 1)', ...
    'dM = Gr_m*M*(1- (M/K_m)) + (alpha_cd11c + alpha_cd68m)*M + k_cd45*Teff*M + k_cd31m*EC*M + k_pdpn*F*M - (k_cd163+k_cd68)*M*CC - k_ido*M*Treg - k_pdl1*M - kcarb_m*M - mu_m*M; M = max(M, 0.5)', ...
    'dEC = Gr_ec*EC*(1- (EC/K_ec)) - (k_vimentin-k_caveolin1)*F*EC - k_cd31c*EC*CC - k_cd31t*EC*Treg - k_cd31m*EC*M - kcarb_ec*EC - mu_ec*EC; EC = max(EC, 0.5)', ...
    'dF = Gr_f*F*(1- (F/K_f)) + alpha_pdgfrb*F - k_caveolin1e*EC*F + k_vimentin*EC*F - k_pdpn*M*F - (k_vimentin+k_sma+k_caveolin1)*F*CC - kcarb_f*F - mu_f*F; F = max(F,1)');   



inputs.model.par=[2.5967e-01 45 0.116 0.103 0.098 0.126 0.388 0.122 0.224 0.135 0.618 0.333 0.230 3.5074e+00...   % CC parameters
                 8.5393e+00 10 0.12 0.130 0.110 0.128 0.0099 0.0134 0.080 4.0441e+00...   % Treg parameters
                 8.9108e+00 30 0.130 0.211 0.228 0.113 6.0717e-01... % Teff parameters
                 6.7624e+00 30 0.60 0.898 0.7 0.112 0.120 9.1317e+00...   % M parameters
                 2.8224e+00 10 1.0176e-01...      % EC parameters
                 9.9412e+00 70 0.9696 0.064 6.7157e-01]; % F parameters % These values may be updated during optimization  


% 0.178 0.138 4.0753e+00 0.135 0.109 0.144 0.0138
% 
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=1;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
 inputs.exps.exp_y0{iexp}=[46.39 7.36 18.17 5.11 3.33 19.64];  %Initial conditions for each experiment          
 inputs.exps.t_f{iexp}= 3;  %Experiments duration
 end




 % OBSEVABLES DEFINITION  
 for iexp=1:inputs.exps.n_exp  
 inputs.exps.n_obs{iexp}=6;                            % Number of observed quantities per experiment  
 inputs.exps.obs_names{iexp}=char('Cancer_Cells','Regulatory_T_Cells','Effector_T_Cells','Macrophages','Endothelial_Cells','Fibroblast');      % Name of the observed quantities per experiment    
 inputs.exps.obs{iexp}=char('Cancer_Cells=CC','Regulatory_T_Cells=Treg','Effector_T_Cells=Teff','Macrophages=M','Endothelial_Cells=EC','Fibroblast=F');   % Observation function
 end 




  % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Sampling times and experimental data for each experiment
for iexp = 1:inputs.exps.n_exp
    inputs.exps.n_s{iexp} = 10;  % Number of sampling times
    inputs.exps.t_s{iexp} = linspace(0, inputs.exps.t_f{iexp}, inputs.exps.n_s{iexp}); % Sampling times
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 inputs.exps.u_interp{1}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{1}=8;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u{1}=[0.178 0.138 4.0753e+00 0.135 0.109 0.144 0.0138];
 inputs.exps.u_min{1}=[0.0; 0.0; 0.0; 0.0; 0.0; 0.0; 0.0];
 inputs.exps.u_max{1}=[0.178 0.138 4.0753e+00 0.135 0.109 0.144 0.0138];
 % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{1}=[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75, 1.875, 4];   
 

 
 %==================================
% UNKNOWNS RELATED DATA
%==================================

% GLOBAL UNKNOWNS (SAME VALUE FOR ALL EXPERIMENTS)

inputs.PEsol.id_global_theta=char('mu_cc','mu_treg','mu_teff','mu_m','mu_ec','mu_f');  %  'all'|User selected  
inputs.PEsol.global_theta_max=15*ones(1,6);  % Maximum allowed values for the paramters
inputs.PEsol.global_theta_min=0*ones(1,6); % Minimum allowed values for the paramters
inputs.PESol.global_theta_guess= rand(1,6).*inputs.model.par([14 24 31 39 42 47]);  % Value of the parameters for which the analysis will be performed    


%In_CC In_Teff Gr_EC Gr_Teff Gr_CC In_M Gr_M Gr_Treg In_F In_Treg
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









