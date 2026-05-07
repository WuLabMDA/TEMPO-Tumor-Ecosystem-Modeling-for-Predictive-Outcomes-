% $Header: svn://.../trunk/AMIGO2R2016/IMC_BC_Analysis/Chemotherapy/Chemo_Patient_Sobs_NT009.m 2410 2015-12-07 13:58:57Z evabalsa $
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

inputs.pathd.results_folder='sobs_imc_bc_chemotherapy_35';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='sobs_imc_chemo_p35';                      % To identify figures and reports for a given problem   

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
inputs.model.names_type= 'custom';

inputs.model.par_names=char('Gr_cc','K_cc','alpha_ar','alpha_ki67','k_cd68','k_cd163','k_vimentin','k_sma','k_caveolin1','k_cd31c','k_pd1','k_cd8','k_gzmb', 'mu_cc',...
                            'Gr_treg','K_treg','alpha_cd4','alpha_hladr','k_ido','k_cd31t','k_tox','k_foxp3','k_helios', 'mu_treg',...
                            'Gr_teff','K_teff','alpha_ox40','alpha_icos','alpha_cd3','k_cd45','k_pdl1', 'mu_teff',...
                            'Gr_m','K_m','alpha_cd11c','alpha_cd68m', 'k_cd31m', 'k_pdpn','mu_m',...
                            'Gr_ec','K_ec','mu_ec',...
                            'Gr_f','K_f','alpha_pdgfrb','k_caveolin1e','mu_f');                  % Names of the parameters   

inputs.model.stimulus_names=char('kcarb_cc', 'kcarb_treg', 'kcarb_teff', 'kcarb_m', 'kcarb_ec', 'kcarb_f' );        

inputs.model.eqns = char(...
    'dCC = Gr_cc*CC*(1- (CC/K_cc)) + (alpha_ar+alpha_ki67)*CC + (k_cd68+k_cd163)*M*CC + (k_vimentin+k_sma+k_caveolin1)*F*CC + k_cd31c*EC*CC - (k_pd1+k_cd8+k_gzmb)*Teff*CC - kcarb_cc*CC - mu_cc*CC; CC = max(CC, 1)', ...
    'dTreg = Gr_treg*Treg*(1- (Treg/K_treg)) + (alpha_cd4+alpha_hladr)*Treg - k_ido*M*Treg + k_cd31t*EC*Treg - k_tox*Teff*Treg - k_foxp3*Treg*Teff - k_helios*Treg*Teff - kcarb_treg*Treg - mu_treg*Treg; Treg = max(Treg, 0.85)', ...
    'dTeff = Gr_teff*Teff*(1- (Teff/K_teff)) + (alpha_ox40+alpha_icos+alpha_cd3)*Teff + k_tox*Teff*Treg - k_foxp3*Treg*Teff - k_helios*Treg*Teff - (k_pd1+k_cd8+k_gzmb)*Teff*CC - k_cd45*Teff*M - k_pdl1*M*Teff - kcarb_teff*Teff - mu_teff*Teff; Teff = max(Teff, 1)', ...
    'dM = Gr_m*M*(1- (M/K_m)) + (alpha_cd11c + alpha_cd68m)*M + k_cd45*Teff*M + k_cd31m*EC*M + k_pdpn*F*M - (k_cd163+k_cd68)*M*CC - k_ido*M*Treg - k_pdl1*M*Teff - kcarb_m*M - mu_m*M; M = max(M, 0.5)', ...
    'dEC = Gr_ec*EC*(1- (EC/K_ec)) - (k_vimentin-k_caveolin1)*F*EC - k_cd31c*EC*CC - k_cd31t*EC*Treg - k_cd31m*EC*M - kcarb_ec*EC - mu_ec*EC; EC = max(EC, 0.90)', ...
    'dF = Gr_f*F*(1- (F/K_f)) + alpha_pdgfrb*F - k_caveolin1e*EC*F + k_vimentin*EC*F - k_pdpn*M*F - (k_vimentin+k_sma+k_caveolin1)*F*CC - kcarb_f*F - mu_f*F; F = max(F, 1)');   


inputs.model.par=[8.5422e-02 60 0.114 0.132 0.067 0.12 0.205 0.12 0.107 0.106 0.107 0.128 0.124 9.6620e+00...   % CC parameters
                 4.8017e+00 20 0.199 0.249 0.103 0.129 0.085 0.059 0.077 4.8008e+00...   % Treg parameters
                 9.5335e+00 35 1.823 2.703 0.057 0.161 0.109  2.8091e-03... % Teff parameters
                 9.3386e-01 30 0.823 0.652 0.101 0.084 8.8685e+00...   % M parameters
                 8.0630e-01 5 6.6206e+00...      % EC parameters
                 6.5529e-01 65 0.62 0.108 7.4235e+00]; % F parameters % These values may be updated during optimization  

% 0.06 0.212 0.08 0.152 0.09 0.121 6.01 0.0015 0.091 0.115 8.085 0.0001

%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
 inputs.exps.n_exp=2;                                  %Number of experiments                                                                            
 for iexp=1:inputs.exps.n_exp   
 inputs.exps.exp_y0{iexp}=[52.02 3.49 16.13 5.57 4.51 20.29];  %Initial conditions for each experiment          
 inputs.exps.t_f{iexp}= 2;  %Experiments duration
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
    inputs.exps.n_s{iexp} = 2;  % Number of sampling times
    inputs.exps.t_s{iexp} = [0 2];  % Sampling times
end
% 
% % Experimental data for all experiments
% for iexp = 1:inputs.exps.n_exp
% 
%    inputs.exps.exp_data{1}=[                              
% 		73.50 2.78 6.31 6.99 5.49 10.94 
%         %1.06 9.03 48.02 23.48 4.85 13.56 
%         15.20 0.54 21.65 1.114 0.57 42.19 
% 		];
% 
% end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 % inputs.exps.u_interp{1}='sustained';                 %Stimuli definition for experiment 2
 % %inputs.exps.n_pulses{1}=10;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 % inputs.exps.u{1}=[0.155; 0.11; 0.09035; 0.155; 0.155; 0.1075];
 % % inputs.exps.u_min{1}=[0.155; 0.16; 0.090; 0.155; 0.005; 0.1075];
 % % inputs.exps.u_max{1}=[0.155; 0.16; 0.090; 0.155; 0.005; 0.1075];
 % % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 % inputs.exps.t_con{1}=[0 4];                    %Times of switching: Initial time, Intermediate times, Final time










 inputs.exps.u_interp{1}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{1}=8;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u{1}=[0.130; 0.108; 0.119; 0.138; 0.109; 0.123];
 inputs.exps.u_min{1}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 inputs.exps.u_max{1}=[0.130; 0.108; 0.119; 0.138; 0.109; 0.123];
 % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{1}=[0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75, 1.875, 4];   




 inputs.exps.u_interp{2}='pulse-down';                 %Stimuli definition for experiment 2
 inputs.exps.n_pulses{2}=16;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 inputs.exps.u{2}=[0.130; 0.108; 0.119; 0.138; 0.109; 0.123];
 inputs.exps.u_min{2}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 inputs.exps.u_max{2}=[0.130; 0.108; 0.119; 0.138; 0.109; 0.123];
 % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 inputs.exps.t_con{2}=[0 :0.125 :4];   


 
 % inputs.exps.u_interp{4}='pulse-down';                 %Stimuli definition for experiment 2
 % inputs.exps.n_pulses{4}=1;                            %Number of pulses |-|_|-|_|-|_|-|_|-|_    
 % inputs.exps.u{4}=[0.155; 0.11; 0.09035; 0.155; 0.155; 0.1075];
 % inputs.exps.u_min{4}=[0.0; 0; 0.0; 0.0; 0.0; 0.0];
 % inputs.exps.u_max{4}=[0.155; 0.11; 0.09035; 0.155; 0.155; 0.1075];
 % % inputs.exps.u_min{1}=0;inputs.exps.u_max{1}=1;        %Minimum and maximum value for the input
 % inputs.exps.t_con{4}=[0 :2 :4];   


inputs.ivpsol.rtol = 1e-10;
inputs.ivpsol.atol = 1e-10;
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




