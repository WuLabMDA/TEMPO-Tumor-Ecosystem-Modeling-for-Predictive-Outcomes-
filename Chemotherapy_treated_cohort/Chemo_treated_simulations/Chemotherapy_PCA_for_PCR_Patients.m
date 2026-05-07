
% Initialization
clear all;
clc;
close all;

% Load dataset
try
    data = readtable('Chemotherapy_Consolidated_PCR_Data.csv');
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

% Create figure for PCA plots
figure('Position', [100, 100, 1200, 900], 'Name', 'PCA Analysis by Cell Type');

% Storage for eigenvalues and eigenvectors
all_eigenvalues = cell(length(cell_types), 1);
mean_all_eigenvalues = zeros(length(cell_types), 1);
variance_explained = zeros(length(cell_types), 2);

% Calculate mean of all eigenvalues for each cell type
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
    
    % Just center the data without standardizing
    centered_data = numeric_data - mean(numeric_data);
    
    % Perform PCA on the centered data
    [coeff, score, latent, ~, explained] = pca(centered_data);
    
    % Store all eigenvalues and calculate mean
    all_eigenvalues{i} = latent;
    mean_all_eigenvalues(i) = mean(latent);
    
    % Store variance explained
    variance_explained(i, 1) = explained(1);
    variance_explained(i, 2) = explained(2);
    
    % Create subplot for cell type
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
    
    % Add mean eigenvalue text
    text_str = sprintf('Mean Eigenvalue: %.2f', mean_all_eigenvalues(i));
    text(min(score(:,1)), max(score(:,2)), text_str, 'FontSize', 10, 'FontWeight', 'bold');
end

% Overall figure formatting
sgtitle('PCA Analysis by Cell Type', 'FontSize', 16, 'FontWeight', 'bold');

% Create a figure for eigenvalue distribution
figure('Position', [100, 100, 1200, 600], 'Name', 'Eigenvalue Distribution by Cell Type');

% Plot eigenvalue distribution for each cell type
for i = 1:length(cell_types)
    if ~isempty(all_eigenvalues{i})
        subplot(2, 3, i);
        bar(all_eigenvalues{i}, 'FaceColor', colors(i,:));
        title(sprintf('%s Eigenvalue Distribution', cell_types{i}), 'FontWeight', 'bold');
        xlabel('Principal Component Index');
        ylabel('Eigenvalue');
        grid on;
        hold on;
        
        % Add a horizontal line for the mean
        yline(mean_all_eigenvalues(i), '--k', ['Mean: ' num2str(mean_all_eigenvalues(i), '%.2f')], ...
            'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
        hold off;
    end
end

% Overall formatting for eigenvalue distribution figure
sgtitle('Eigenvalue Distribution by Cell Type', 'FontSize', 16, 'FontWeight', 'bold');

% Create a figure for mean eigenvalue summary
figure('Position', [100, 100, 800, 400], 'Name', 'Mean of All Eigenvalues Summary');

% Create bar chart for mean of all eigenvalues
bar(mean_all_eigenvalues, 'FaceColor', [0.3 0.6 0.9]);
set(gca, 'XTick', 1:length(cell_types), 'XTickLabel', cell_types, 'XTickLabelRotation', 45);
title('Mean of All Eigenvalues by Cell Type', 'FontWeight', 'bold');
ylabel('Mean of All Eigenvalues');
grid on;

% Calculate overall mean across all cell types
valid_means = mean_all_eigenvalues(mean_all_eigenvalues > 0);
overall_mean = mean(valid_means);

% Print summary to command window
fprintf('Mean of All Eigenvalues Summary:\n');
fprintf('-------------------------------\n');
fprintf('Overall mean across all cell types: %.4f\n\n', overall_mean);

for i = 1:length(cell_types)
    fprintf('%s:\n', cell_types{i});
    fprintf('  Mean of All Eigenvalues: %.4f\n', mean_all_eigenvalues(i));
    
    % Calculate additional statistics for eigenvalues
    if ~isempty(all_eigenvalues{i})
        fprintf('  Eigenvalue Count: %d\n', length(all_eigenvalues{i}));
        fprintf('  Max Eigenvalue: %.4f\n', all_eigenvalues{i}(1));
        fprintf('  Min Eigenvalue: %.4f\n', all_eigenvalues{i}(end));
        fprintf('  Eigenvalue Standard Deviation: %.4f\n', std(all_eigenvalues{i}));
        
        % Show first several eigenvalues
        fprintf('  First 5 Eigenvalues: ');
        fprintf('%.4f ', all_eigenvalues{i}(1:min(5,length(all_eigenvalues{i}))));
        if length(all_eigenvalues{i}) > 5
            fprintf('...');
        end
        fprintf('\n');
    else
        fprintf('  Eigenvalue data not available');
    end
    fprintf('\n');
end