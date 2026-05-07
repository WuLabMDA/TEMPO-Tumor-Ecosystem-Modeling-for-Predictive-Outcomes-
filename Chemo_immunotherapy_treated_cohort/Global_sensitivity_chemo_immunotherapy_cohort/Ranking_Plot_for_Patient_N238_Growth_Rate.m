% ============================================================
% Global Relative Sensitivity Metrics (Gr parameters - updated)
% Clean grouped bar plot (NO "data1" in legend)
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'Gr\_cc','Gr\_m','Gr\_treg','Gr\_teff','Gr\_f','Gr\_ec'};

rd_msqr = [3.0390e-01  1.9041e-01  1.6209e-01  1.5442e-01  1.2745e-01  1.2134e-01];
rd_mabs = [6.3211e-01  4.7444e-01  4.6113e-01  3.2660e-01  2.8545e-01  3.1801e-01];
rd_mean = [2.2400e-02  1.7574e-01  1.5919e-01  3.7944e-02 -1.9574e-02  8.8889e-02];
rd_max  = [2.7868e+01  1.1803e+01  1.2855e+01  8.5748e+00  6.7465e+00  6.1457e+00];
rd_min  = [-1.9811e+01 -8.6454e+00 -9.3132e+00 -9.3387e+00 -8.3219e+00 -6.1618e+00];

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
% Save outputs
% -------------------------
exportgraphics(fig, 'N238_Gr_relative_sensitivity_updated.png', 'Resolution', 600);
savefig(fig, 'N238_Gr_relative_sensitivity_updated.fig');