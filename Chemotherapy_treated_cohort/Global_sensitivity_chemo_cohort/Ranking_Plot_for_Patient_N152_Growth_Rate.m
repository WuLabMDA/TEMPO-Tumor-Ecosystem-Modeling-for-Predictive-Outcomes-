% ============================================================
% Global Relative Sensitivity Metrics by Parameter
% Grouped bar plot using the updated dataset
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'Gr\_teff','Gr\_cc','Gr\_f','Gr\_m','Gr\_ec','Gr\_treg'};

rd_msqr = [3.9487e-01  3.3888e-01  2.2746e-01  1.5840e-01  1.2342e-01  3.0019e-02];
rd_mabs = [1.6209e+00  1.5057e+00  9.7779e-01  6.0244e-01  4.8856e-01  9.9730e-02];
rd_mean = [6.4924e-01 -7.8686e-01  1.9446e-02  2.1817e-01  2.8387e-01  4.8109e-02];
rd_max  = [1.1462e+01  7.6111e+00  6.4859e+00  4.3610e+00  3.0508e+00  1.3392e+00];
rd_min  = [-7.5980e+00 -1.0694e+01 -5.7515e+00 -2.2958e+00 -1.2746e+00 -3.4372e-01];

% Arrange into matrix: rows = parameters, columns = metrics
Y = [rd_msqr(:), rd_mabs(:), rd_mean(:), rd_max(:), rd_min(:)];

% -------------------------
% Plot
% -------------------------
fig = figure('Color','w','Position',[9, 9, 700, 450]);
b = bar(Y, 'grouped', 'LineWidth', 1.0);
hold on;

% -------------------------
% Colors to match legend
% -------------------------
b(1).FaceColor = [0.00 0.4470 0.7410];   % blue   -> rd_msqr
b(2).FaceColor = [0.8500 0.3250 0.0980]; % orange -> rd_mabs
b(3).FaceColor = [0.4660 0.6740 0.1880]; % green  -> rd_mean
b(4).FaceColor = [0.6350 0.0780 0.1840]; % red    -> rd_max
b(5).FaceColor = [0.4940 0.1840 0.5560]; % purple -> rd_min

for i = 1:numel(b)
    b(i).EdgeColor = 'none';
end

% -------------------------
% Axes formatting
% -------------------------
ax = gca;
ax.XTick = 1:numel(params);
ax.XTickLabel = params;
ax.FontSize = 13;
ax.FontWeight = 'bold';
ax.LineWidth = 1.2;
ax.Box = 'off';
ax.TickDir = 'out';
xtickangle(35);

xlabel('Parameters', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Sensitivity Index', 'FontSize', 14, 'FontWeight', 'bold');


lgd = legend;
lgd.AutoUpdate = 'off';

% Create legend ONLY from bar objects
legend([b(1), b(2), b(3), b(4), b(5)], ...
       {'rd\_msqr','rd\_mabs','rd\_mean','rd\_max','rd\_min'}, ...
       'Location','northeast', ...
       'FontSize',12, ...
       'Box','on');


yline(0, 'k-', 'LineWidth', 1.2);

grid on;
ax.GridAlpha = 0.15;

% -------------------------
% Save high-resolution outputs
% -------------------------
exportgraphics(fig, 'Patient_152_global_relative_sensitivity_grouped_barplot.png', 'Resolution', 600);
savefig(fig, 'Patient_152_global_relative_sensitivity_grouped_barplot.fig');