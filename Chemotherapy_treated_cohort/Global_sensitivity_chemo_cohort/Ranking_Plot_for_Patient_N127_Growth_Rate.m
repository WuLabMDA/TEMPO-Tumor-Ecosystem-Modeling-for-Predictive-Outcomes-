% ============================================================
% Global Relative Sensitivity Metrics (Gr parameters - updated)
% Grouped bar plot (clean legend, no "data1")
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'Gr\_treg','Gr\_ec','Gr\_m','Gr\_cc','Gr\_f','Gr\_teff'};

rd_msqr = [1.2610e-01  9.9471e-02  7.7962e-02  7.4693e-02  4.7086e-02  4.1717e-02];
rd_mabs = [4.2770e-01  3.2296e-01  4.0830e-01  3.0719e-01  1.7520e-01  1.4523e-01];
rd_mean = [3.2335e-01  2.9042e-01 -6.2540e-02 -9.4936e-02  1.1362e-01  7.5547e-02];
rd_max  = [3.1970e+00  2.5045e+00  3.2280e+00  2.5597e+00  1.5277e+00  1.1936e+00];
rd_min  = [-6.1717e-01 -3.4361e-01 -1.7995e+00 -0.9950e+00 -8.5796e-01 -9.7595e-01];

% Combine into matrix
Y = [rd_msqr(:), rd_mabs(:), rd_mean(:), rd_max(:), rd_min(:)];

% -------------------------
% Plot
% -------------------------
fig = figure('Color','w','Position',[9, 9, 700, 450]);
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
% Save
% -------------------------
exportgraphics(fig, 'N127_Gr_relative_sensitivity_plot_updated.png', 'Resolution', 600);
savefig(fig, 'N127_Gr_relative_sensitivity_plot_updated.fig');