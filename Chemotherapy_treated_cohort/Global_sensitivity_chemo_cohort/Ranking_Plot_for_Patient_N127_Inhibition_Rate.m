% ============================================================
% Global Relative Sensitivity Metrics (mu parameters - updated)
% Clean grouped bar plot (NO "data1" in legend)
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'In\_{cc}','In\_{m}','In\_{treg}','In\_{teff}','In\_{f}'};

rd_msqr = [2.1988e-01  2.1526e-01  1.1579e-01  9.8796e-02  3.8365e-02];
rd_mabs = [9.3330e-01  9.6179e-01  3.8457e-01  3.8620e-01  1.4779e-01];
rd_mean = [-9.0962e-02 -1.0874e-01 -2.9341e-01 -2.2242e-01 -8.2998e-02];
rd_max  = [5.9286e+00  4.0749e+00  7.7950e-01  2.0872e+00  5.9066e-01];
rd_min  = [-9.9815e+00 -6.0624e+00 -4.0991e+00 -3.5724e+00 -1.1919e+00];

% Combine into matrix
Y = [rd_msqr(:), rd_mabs(:), rd_mean(:), rd_max(:), rd_min(:)];

% -------------------------
% Plot
% -------------------------
fig = figure('Color','w','Position',[10 10 700 450]);
b = bar(Y, 'grouped', 'LineWidth', 1.0);
hold on;

% -------------------------
% Colors
% -------------------------
b(1).FaceColor = [0.00 0.4470 0.7410];   % rd_msqr
b(2).FaceColor = [0.8500 0.3250 0.0980]; % rd_mabs
b(3).FaceColor = [0.4660 0.6740 0.1880]; % rd_mean
b(4).FaceColor = [0.6350 0.0780 0.1840]; % rd_max
b(5).FaceColor = [0.4940 0.1840 0.5560]; % rd_min

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

% -------------------------
% Zero line (REMOVE from legend)
% -------------------------
hline = yline(0, 'k-', 'LineWidth', 1.2);
hline.Annotation.LegendInformation.IconDisplayStyle = 'off';

% -------------------------
% Clean legend (NO "data1")
% -------------------------
lgd = legend([b(1), b(2), b(3), b(4), b(5)], ...
       {'rd\_msqr','rd\_mabs','rd\_mean','rd\_max','rd\_min'}, ...
       'Location','southeast', ...
       'FontSize',12, ...
       'Box','on');
lgd.AutoUpdate = 'off';

% -------------------------
% Grid
% -------------------------
grid on;
ax.GridAlpha = 0.15;

% -------------------------
% Save outputs
% -------------------------
exportgraphics(fig, 'N127_mu_relative_sensitivity_plot_v2.png', 'Resolution', 600);
savefig(fig, 'N127_mu_relative_sensitivity_plot_v2.fig');