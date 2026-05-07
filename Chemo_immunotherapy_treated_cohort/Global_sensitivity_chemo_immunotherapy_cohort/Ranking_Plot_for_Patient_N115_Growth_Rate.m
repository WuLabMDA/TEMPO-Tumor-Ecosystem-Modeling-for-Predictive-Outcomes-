% ============================================================
% Global Relative Sensitivity Metrics (Gr parameters - FINAL)
% Clean grouped bar plot (NO "data1")
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'Gr\_cc','Gr\_teff','Gr\_ec','Gr\_f','Gr\_m','Gr\_treg'};

rd_msqr = [7.7858e-01  3.7870e-01  1.7492e-01  1.2921e-01  1.2668e-01  1.1554e-01];
rd_mabs = [2.8588e+00  1.3647e+00  6.3582e-01  4.8355e-01  4.5973e-01  3.9532e-01];
rd_mean = [-4.0868e-01  1.7898e-01  2.7381e-01 -1.2901e-02  1.4215e-01  2.1438e-01];
rd_max  = [2.6662e+01  1.3706e+01  5.1901e+00  4.5471e+00  4.0445e+00  3.1305e+00];
rd_min  = [-2.6384e+01 -1.4445e+01 -3.2111e+00 -4.4945e+00 -2.7280e+00 -1.1991e+00];

% Combine
Y = [rd_msqr(:), rd_mabs(:), rd_mean(:), rd_max(:), rd_min(:)];

% -------------------------
% Plot
% -------------------------
fig = figure('Color','w','Position',[9 9 700 450]);
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
exportgraphics(fig, 'N115_Gr_relative_sensitivity_HIGH_DYNAMIC.png', 'Resolution', 600);
savefig(fig, 'N115_Gr_relative_sensitivity_HIGH_DYNAMIC.fig');