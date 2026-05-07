% ============================================================
% Global Relative Sensitivity Metrics (mu parameters - FINAL)
% Clean grouped bar plot (NO "data1")
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'In\_{cc}','In\_{teff}','In\_{f}','In\_{ec}','In\_{treg}','In\_{m}'};

rd_msqr = [4.3099e-01  2.2014e-01  1.5077e-01  1.2244e-01  1.1729e-01  8.4793e-02];
rd_mabs = [1.8673e+00  8.0877e-01  5.5748e-01  4.2663e-01  3.7609e-01  2.7745e-01];
rd_mean = [4.6106e-01 -3.1614e-01 -1.7721e-01 -3.2177e-01 -3.0274e-01 -1.5855e-01];
rd_max  = [4.4607e+01  6.8139e+00  3.5050e+00  1.3715e+00  6.0069e-01  1.6871e+00];
rd_min  = [-5.5602e+01 -1.0604e+01 -5.5815e+00 -4.0051e+00 -3.2005e+00 -3.4576e+00];

% Combine
Y = [rd_msqr(:), rd_mabs(:), rd_mean(:), rd_max(:), rd_min(:)];

% -------------------------
% Plot
% -------------------------
fig = figure('Color','w','Position',[10 10 700 450]);
b = bar(Y, 'grouped', 'LineWidth', 1.0);
hold on;

% -------------------------
% Colors (consistent)
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
ylabel(' Sensitivity Index', 'FontSize', 14, 'FontWeight', 'bold');

% -------------------------
% Zero line (hidden from legend)
% -------------------------
hline = yline(0, 'k-', 'LineWidth', 1.2);
hline.Annotation.LegendInformation.IconDisplayStyle = 'off';

% -------------------------
% Clean legend (NO data1)
% -------------------------
lgd = legend([b(1), b(2), b(3), b(4), b(5)], ...
       {'rd\_msqr','rd\_mabs','rd\_mean','rd\_max','rd\_min'}, ...
       'Location','northeast', ...
       'FontSize',12, ...
       'Box','on');
lgd.AutoUpdate = 'off';

% -------------------------
% Grid
% -------------------------
grid on;
ax.GridAlpha = 0.15;

% -------------------------
% Save high-resolution
% -------------------------
exportgraphics(fig, 'N115_mu_relative_sensitivity_HIGH_DYNAMIC_FINAL.png', 'Resolution', 600);
savefig(fig, 'N115_mu_relative_sensitivity_HIGH_DYNAMIC_FINAL.fig');