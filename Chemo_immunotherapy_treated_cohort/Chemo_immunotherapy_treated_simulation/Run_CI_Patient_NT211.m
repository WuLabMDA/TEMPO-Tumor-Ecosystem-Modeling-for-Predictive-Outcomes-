clc;
clear all;
close all;
rng('default');
CI_Patient_NT211        % Calls the script with the inputs: 
                           % Model
 AMIGO_Prep(inputs)                            % Experimental scheme + data + noise
                           % PE problem formulation: cost function and unknowns to be estimated
                           % Numerical approaches for  simulation and optimization
[results] = AMIGO_PE(inputs);

% Check if simulation results exist
if isfield(results, 'sim') && isfield(results.sim, 'obs')
    % Extract simulation time points and observations
    sim_times = inputs.exps.t_s{1};
    sim_obs = results.sim.obs{1};
    
    % Prepare variable names
    var_names = {'Cancer_Cells', 'Regulatory_T_Cells', 'Effector_T_Cells', 'Macrophages', 'Endothelial_Cells', 'Fibroblast'};
    
    % Create output data with matching dimensions
    output_data = array2table(sim_obs, 'VariableNames', var_names);
    
    
    % Full path for CSV file
   csv_filename = fullfile('V:\dkmarri\Mathematical_Model\AMIGO2_R2019c\AMIGO2_R2019c\IMC_BC_Analysis\Chemotherapy_Immunotherapy', 'RD_CI_Patient_211_simulation_results.csv');
    
    % Write to CSV
    writetable(output_data, csv_filename);
    
    % Print confirmation message
    fprintf('Simulation results saved to %s\n', csv_filename);
    
else
    % Error handling if simulation results are not available
    error('Simulation results could not be retrieved. Please check the parameter estimation process.');
end

