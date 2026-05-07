% ============================================================
% Global Relative Sensitivity Metrics (mu parameters)
% Grouped bar plot (clean legend, no "data1")
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'In\_teff','In\_cc','In\_f','In\_m','In\_treg'};

rd_msqr = [2.5372e-01  2.4063e-01  1.7815e-01  1.3365e-01  7.0026e-02];
rd_mabs = [1.0268e+00  1.1086e+00  6.7794e-01  4.6851e-01  2.2642e-01];
rd_mean = [-4.4562e-01  3.3084e-01 -3.8362e-01 -2.8502e-01 -1.6561e-01];
rd_max  = [3.9817e+00  3.8001e+00  3.8894e+00  2.5514e+00  6.0280e-01];
rd_min  = [-1.2690e+01 -1.0577e+01 -7.0721e+00 -5.9662e+00 -2.5786e+00];

% Combine into matrix
Y = [rd_msqr(:), rd_mabs(:), rd_mean(:), rd_max(:), rd_min(:)];

% -------------------------
% Plot
% -------------------------
fig = figure('Color','w','Position',[9, 9, 700, 450]);
b = bar(Y, 'grouped', 'LineWidth', 1.0);
hold on;

% -------------------------
% Colors (consistent with previous)
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
ylabel(' Sensitivity Index', 'FontSize', 14, 'FontWeight', 'bold');

% -------------------------
% Horizontal zero line (hidden from legend)
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
% Save figure
% -------------------------
exportgraphics(fig, 'Patient_152_mu_relative_sensitivity_plot.png', 'Resolution', 600);
savefig(fig, 'Patient_152_mu_relative_sensitivity_plot.fig');