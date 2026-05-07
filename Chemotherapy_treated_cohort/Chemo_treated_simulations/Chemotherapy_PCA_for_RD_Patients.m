% Comprehensive Cell Type PCA Analysis
% Date: March 2025

% Initialization
clear all;
clc;
close all;

% Load dataset
try
    data = readtable('Chemotherapy_Consolidated_RD_Data.csv');
catch ME
    error('Error loading dataset: %s', ME.message);
end

% Define cell types
cell_types = {'Cancer_Cells', 'Regulatory_T_Cells', 'Effector_T_Cells', ...
              'Macrophages', 'Endothelial_Cells', 'Fibroblast'};

% Color palette for visualization
colors = [
    0 0 1;      % Blue
    1 0 1;      % Magenta
    0 1 1;      % Cyan
    0 1 0;      % Green
    0 0 0;      % Black
    1 0 0;      % Red
];

% Create figure for individual cell type PCAs
figure('Position', [100, 100, 1200, 800], 'Name', 'Individual Cell Type PCA');

% Preallocate storage for combined data
all_scores = [];
all_labels = [];
variance_explained = zeros(length(cell_types), 2);

% Perform PCA for each cell type
for i = 1:length(cell_types)
    cell_type = cell_types{i};
    
    % Find columns matching cell type
    matching_columns = contains(data.Properties.VariableNames, cell_type);
    cell_type_data = data(:, matching_columns);
    
    % Convert to numeric matrix
    numeric_data = table2array(cell_type_data);
    
    % Remove columns with all zeros or NaNs
    numeric_data = numeric_data(:, any(numeric_data ~= 0, 1));
    numeric_data = numeric_data(:, ~all(isnan(numeric_data), 1));
    
    % Skip if no valid data
    if isempty(numeric_data)
        warning('No valid numeric data for %s', cell_type);
        continue;
    end
    
    % Standardize data
    standardized_data = (numeric_data - mean(numeric_data)) ./ std(numeric_data);
    
    % Perform PCA
    [coeff, score, latent, ~, explained] = pca(standardized_data);
    
    % Store variance explained
    variance_explained(i, 1) = explained(1);
    variance_explained(i, 2) = explained(2);
    
    % Create subplot for individual cell type
    subplot(2, 3, i);
    
    % Scatter plot of first two principal components
    scatter(score(:,1), score(:,2), 50, colors(i,:), 'filled', 'MarkerFaceAlpha', 0.7);
    
    % Title and labels
    title(sprintf('%s PCA', cell_type), 'FontWeight', 'bold');
    xlabel('First Principal Component (PC1)');
    ylabel('Second Principal Component (PC2)');
    
    % Add variance explained to subtitle
    subtitle(sprintf('PC1: %.2f%%, PC2: %.2f%%', explained(1), explained(2)), ...
        'FontSize', 10);
    
    % Accumulate scores and labels for combined plot
    cell_type_labels = repmat(i, size(score, 1), 1);
    all_scores = [all_scores; score(:, 1:2)];
    all_labels = [all_labels; cell_type_labels];
end

% Overall figure formatting for individual plots
sgtitle('PCA Analysis by Cell Type', 'FontSize', 16, 'FontWeight', 'bold');

% Create a new figure for combined PCA with clustering
figure('Position', [100, 100, 1200, 800], 'Name', 'Combined Cell Type PCA with Clustering');

% Perform clustering on combined PCA scores
num_clusters = 3;
[cluster_idx, cluster_centroids] = kmeans(all_scores, num_clusters, ...
    'Replicates', 5, 'EmptyAction', 'singleton');

% Plot combined PCA with clustering
hold on;

% Plot each cell type with its distinct color
for i = 1:length(cell_types)
    cell_type_points = all_scores(all_labels == i, :);
    
    % Scatter plot for this cell type
    scatter(cell_type_points(:,1), cell_type_points(:,2), 50, colors(i,:), ...
        'filled', 'MarkerFaceAlpha', 0.7, 'DisplayName', cell_types{i});
end

% Plot cluster centroids
scatter(cluster_centroids(:,1), cluster_centroids(:,2), 200, 'k', 'x', ...
    'LineWidth', 2, 'DisplayName', 'Cluster Centroids');

% Formatting for combined plot
title('Combined PCA: All Cell Types', 'FontWeight', 'bold');
xlabel('First Principal Component (PC1)');
ylabel('Second Principal Component (PC2)');
legend('Location', 'best');
hold off;

% Print variance explained summary
fprintf('\nVariance Explained Summary:\n');
for i = 1:length(cell_types)
    fprintf('%s:\n', cell_types{i});
    fprintf('  PC1: %.2f%%\n', variance_explained(i,1));
    fprintf('  PC2: %.2f%%\n', variance_explained(i,2));
    fprintf('  Cumulative: %.2f%%\n', sum(variance_explained(i,:)));
end

% Cluster analysis
fprintf('\nClustering Analysis:\n');
for j = 1:num_clusters
    fprintf('Cluster %d:\n', j);
    for i = 1:length(cell_types)
        cluster_type_count = sum((cluster_idx == j) & (all_labels == i));
        fprintf('  %s: %d points\n', cell_types{i}, cluster_type_count);
    end
end