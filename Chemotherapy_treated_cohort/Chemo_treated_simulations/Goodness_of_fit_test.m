%% Goodness-of-fit test (R²) combined by timepoint with cell type fits
close all;
clear all;
clc;

%% ---------------- Load Data ----------------
data = readtable('Goodness_of_fit_test.csv');

%% ---------------- Define Cell Types, Timepoints, Colors ----------------
cellTypes = {'CC','Treg','Teff','M','EC','F'};
timePoints = {'T0','T1','T2'};

% Define specific colors for each cell type
celltype_colors = [
    0 0 1;           % CC - cancercells (Blue)
    1 0 1;           % Treg - regulatorytcell (Magenta)
    0 1 1;           % Teff - effectortcells (Cyan)
    0 1 0;           % M - macrophages (Green)
    0.294 0 0.510;   % EC - endothelialcells (Dark Purple)
    1 0 0;           % F - fibroblast (Red)
];

%% ---------------- Initialize R² matrix ----------------
R2_matrix = zeros(length(cellTypes), length(timePoints));

%% ---------------- Individual Cell Type Fits per Timepoint ----------------
for t = 1:length(timePoints)
    tp = timePoints{t};
    
    figure('Name',['Goodness-of-fit ' tp],'NumberTitle','off');
    tiledlayout(2,3,'Padding','compact','TileSpacing','compact'); % 2x3 grid for cell types
    
    for c = 1:length(cellTypes)
        ct = cellTypes{c};
        
        % Extract predicted and measured values
        pred = data{:, sprintf('%s_Pred_%s', ct, tp)};
        meas = data{:, sprintf('%s_Meas_%s', ct, tp)};
        
        % Compute R²
        SS_res = sum((meas - pred).^2);
        SS_tot = sum((meas - mean(meas)).^2);
        R2 = 1 - (SS_res / SS_tot);
        R2_matrix(c,t) = R2;
        
        % Plot Predicted vs Measured
        nexttile;
        scatter(meas, pred, 60, 'filled', 'MarkerFaceColor', celltype_colors(c,:)); hold on;
        lsline; % regression line
        xlabel('Measured'); ylabel('Predicted');
        title(sprintf('%s - %s (R²=%.2f)', ct, tp, R2));
        grid on; axis square;
    end
end

%% ---------------- Display R² matrix ----------------
disp('R² values (rows=cell types, cols=T0,T1,T2):');
disp(array2table(R2_matrix, 'RowNames', cellTypes, 'VariableNames', timePoints));

%% ---------------- Heatmap of R² ----------------
figure;
heatmap(timePoints, cellTypes, R2_matrix, 'Colormap', parula, 'ColorbarVisible','on');
title('Goodness-of-fit (R²) across Cell Types and Timepoints');
xlabel('Timepoint'); ylabel('Cell Type');

%% ---------------- Overall R² pooled across all cell types per timepoint ----------------
figure('Name','Overall Goodness-of-fit by Timepoint','NumberTitle','off');
tiledlayout(1,length(timePoints),'Padding','compact','TileSpacing','compact'); % one plot per timepoint

for t = 1:length(timePoints)
    tp = timePoints{t};
    
    all_pred = [];
    all_meas = [];
    all_labels = [];
    
    % Collect all cell types for this timepoint
    for c = 1:length(cellTypes)
        ct = cellTypes{c};
        pred = data{:, sprintf('%s_Pred_%s', ct, tp)};
        meas = data{:, sprintf('%s_Meas_%s', ct, tp)};
        all_pred = [all_pred; pred];
        all_meas = [all_meas; meas];
        all_labels = [all_labels; repmat(c, length(pred), 1)]; % store cell type index
    end
    
    % Compute overall R²
    SS_res = sum((all_meas - all_pred).^2);
    SS_tot = sum((all_meas - mean(all_meas)).^2);
    R2_overall = 1 - (SS_res / SS_tot);
    
    % Plot pooled scatter with colors by cell type
    nexttile; hold on;
    for c = 1:length(cellTypes)
        idx = (all_labels == c);
        scatter(all_meas(idx), all_pred(idx), 60, 'filled', 'MarkerFaceColor', celltype_colors(c,:));
    end
    
    % Add regression line (pooled)
    coeffs = polyfit(all_meas, all_pred, 1);
    x_fit = linspace(min(all_meas), max(all_meas), 100);
    y_fit = polyval(coeffs, x_fit);
    plot(x_fit, y_fit, 'k-', 'LineWidth', 1.5);
    
    xlabel('Measured Data'); ylabel('Simulated Data');
    title(sprintf('%s - (R²=%.2f)', tp, R2_overall));
    grid on; axis square;
    legend(cellTypes, 'Location', 'bestoutside');
end

%