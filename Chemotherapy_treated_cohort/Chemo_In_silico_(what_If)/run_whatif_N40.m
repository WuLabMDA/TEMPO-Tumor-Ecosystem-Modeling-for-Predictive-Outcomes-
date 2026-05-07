clc;
clear all;
close all;
rng('default');

whatif_N40  % Calls the script with the inputs: 
                             % Model
                             % Experimental scheme (number of experiments, initial 
                             % & stimulation conditions, OBSERVABLES, final time - per experiment) 
                             % Numerical approaches for simulation 

AMIGO_Prep(inputs)           % Calls the task for pre-processing


AMIGO_SObs(inputs);           % Calls the task for simulating observables



% outputs = AMIGO_SObs(inputs);           % Calls the task for simulating observables
% 
% % Plotting the results for all experiments
% figure('Position', [10, 10, 800, 500]);
% 
% 
% % Define colors and line styles for each experiment
% colors = {'b', 'r', 'g'};
% linestyles = {'-', '--', ':'};
% legends = {'Experiment 1 (Original)', 'Experiment 2 (Higher Growth, Lower Inhibition)', 'Experiment 3 (Lower Growth, Higher Inhibition)'};
% 
% % For each state variable
% for ist = 1:inputs.model.n_st
%     subplot(2, 3, ist);
%     hold on;
% 
%     % For each experiment
%     for iexp = 1:inputs.exps.n_exp
%         plot(outputs.sim.tsim{iexp}, outputs.sim.states{iexp}(:, ist), [colors{iexp}, linestyles{iexp}], 'LineWidth', 2);
%     end
% 
%     title(inputs.model.st_names(ist, :), 'FontSize', 12, 'FontWeight', 'bold');
%     xlabel('Time (days)', 'FontSize', 10);
%     ylabel('Cell Count', 'FontSize', 10);
%     grid on;
% 
%     % Add legend to the first subplot
%     if ist == 1
%         legend(legends, 'Location', 'best');
%     end
% 
%     hold off;
% end
% 
% % Add a main title
% sgtitle('Comparison of Cell Populations Across Three Experiments with Different Growth and Inhibition Rates', 'FontSize', 14);
% 
% % Save the figure
% saveas(gcf, [inputs.pathd.results_folder, '/comparison_plot.png']);
% saveas(gcf, [inputs.pathd.results_folder, '/comparison_plot.fig']);
% 
% 
% 
% 
