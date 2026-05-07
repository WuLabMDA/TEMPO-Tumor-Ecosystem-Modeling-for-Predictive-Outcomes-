% ============================================================
% Global Relative Sensitivity Metrics (mu parameters - updated)
% Clean grouped bar plot (NO "data1" in legend)
% ============================================================

clear; clc; close all;

% -------------------------
% Data
% -------------------------
params = {'In\_{cc}','In\_{treg}','In\_{f}','In\_{teff}','In\_{m}','In\_{ec}'};

rd_msqr = [3.8307e-01  1.9286e-01  1.7740e-01  9.7201e-02  9.1463e-02  8.4037e-02];
rd_mabs = [1.5333e+00  6.4574e-01  6.0167e-01  2.9538e-01  2.9726e-01  2.8538e-01];
rd_mean = [2.7912e-01 -3.4349e-01 -2.1239e-01 -9.1127e-02 -1.0399e-01 -1.8091e-01];
rd_max  = [5.9979e+01  2.9093e+00  4.3272e+00  3.8435e+00  2.8571e+00  1.8745e+00];
rd_min  = [-4.7781e+01 -8.1555e+00 -7.2946e+00 -5.3280e+00 -4.7422e+00 -3.1906e+00];

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
exportgraphics(fig, '238_mu_relative_sensitivity_updated.png', 'Resolution', 600);
savefig(fig, '238_mu_relative_sensitivity_updated.fig');