clear all;
clc;
close all;
fprintf('\n\n --->Computing global sensitivities, this may take a while...\n');
Patient_N047_Sens % Calls the script with the inputs: 
                           % Model
                           % Experimental scheme 
                           % Rank problem formulation: unknowns to be
                           % considered + value of unkwnowns for which the
                           % analysis is performed
                           % Numerical approaches for simulation and sensitivity
                           % analysis
AMIGO_Prep(inputs)         % Calls the task for pre-processing
[results] = AMIGO_GRank(inputs);        % Calls the task for Global Rank

% Get the sensitivity matrix
sensitivity_matrix = results.rank.g_d_obs_mean_mat{1, 1};

% Get parameter and observable names from the inputs
parameter_names = {'Gr_cc', 'Gr_treg','Gr_teff','Gr_m', 'Gr_ec', 'Gr_f' };
observable_names = {'Cancer_Cells', 'Regulatory_T_Cells', 'Effector_T_Cells', 'Macrophages', 'Endothelial_Cells', 'Fibroblast'};

% Save sensitivity matrix to CSV file with headers
% Create a table with parameter names as column headers
sensitivity_table = array2table(sensitivity_matrix, 'VariableNames', parameter_names, 'RowNames', observable_names);

% Define the output filename
output_filename = 'Patient_N047_RD_Growth_Rate_Sensitivity_Matrix.csv';

% Write the table to CSV file
writetable(sensitivity_table, output_filename, 'WriteRowNames', true);
fprintf('\n Sensitivity matrix has been saved to %s\n', output_filename);

% Create figure with good size and adjust position
figure('Position', [10, 10, 800, 500]);  % Increased size for better visibility

% Create heatmap
imagesc(sensitivity_matrix);
colormap('parula');
colorbar;

% Customize appearance with adjusted margins
axes_handle = gca;
axes_handle.Position = [0.15 0.2 0.7 0.7];  % Adjust axes position [left bottom width height]

% Set tick labels and properties
set(axes_handle, 'XTick', 1:size(sensitivity_matrix, 2));
set(axes_handle, 'YTick', 1:size(sensitivity_matrix, 1));
set(axes_handle, 'XTickLabel', parameter_names, 'XTickLabelRotation', 45);
set(axes_handle, 'YTickLabel', observable_names);
set(axes_handle, 'FontSize', 12, 'FontWeight', 'bold');

% Add labels and title
xlabel('Parameters', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Observables', 'FontSize', 14, 'FontWeight', 'bold');
title('Patient N047 Growth rate Sensitivity Analysis Results', 'FontSize', 14, 'FontWeight', 'bold');

% Add grid
grid on;
set(axes_handle, 'Layer', 'top');

% Adjust colorbar
c = colorbar;
c.Position = [0.87 0.2 0.03 0.7];  % Adjust colorbar position [left bottom width height]
c.FontSize = 12;
c.FontWeight = 'bold';
ylabel(c, 'Sensitivity', 'FontSize', 14, 'FontWeight', 'bold');

% Add numerical values to cells
for i = 1:size(sensitivity_matrix, 1)
    for j = 1:size(sensitivity_matrix, 2)
        text(j, i, num2str(sensitivity_matrix(i,j), '%.2f'), ...
            'HorizontalAlignment', 'center', ...
            'Color', 'black', 'FontSize', 18, ...
            'FontWeight', 'bold');
    end
end

% Adjust layout
set(gcf, 'Color', 'white');

% Save the figure as an image file
%saveas(gcf, 'Patient_NT009_Sensitivity_Heatmap.png');
%fprintf('Sensitivity heatmap has been saved as Patient_NT009_Sensitivity_Heatmap.png\n');

% Make sure everything fits
set(gcf, 'PaperPositionMode', 'auto');