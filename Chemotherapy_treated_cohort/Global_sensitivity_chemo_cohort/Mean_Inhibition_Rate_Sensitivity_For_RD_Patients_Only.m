% Sensitivity Analysis for RD Growth Rate Files
% Clear previous workspace
clear all;
close all;
clc;

% Define the pattern for files to import
filePattern = fullfile(pwd, '*RD*Inhibition_Rate_Sensitivity_Matrix.csv');
csvFiles = dir(filePattern);

% Initialize storage for sensitivity matrices
allSensitivityMatrices = {};

% Import and process each CSV file
for k = 1:length(csvFiles)
    % Full file path
    baseFileName = csvFiles(k).name;
    fullFileName = fullfile(csvFiles(k).folder, baseFileName);
    
    % Import CSV file
    try
        % Read the CSV file, skipping the first row (headers)
        rawData = readtable(fullFileName, 'HeaderLines', 1);
        
        % Convert to matrix, excluding the first column (row labels)
        sensitivityMatrix = table2array(rawData(:, 2:end));
        
        % Store the matrix
        allSensitivityMatrices{end+1} = sensitivityMatrix;
        
        % Print filename for tracking
        fprintf('Processed file: %s\n', baseFileName);
    catch ME
        fprintf('Error processing file %s: %s\n', baseFileName, ME.message);
    end
end

% Ensure at least one file was found
if isempty(allSensitivityMatrices)
    error('No RD Inhibition Rate Sensitivity Matrix CSV files found in the current directory.');
end

% Define row and column labels in the order of the figure
rowLabels = {'Cancer\_Cells', 'Regulatory\_T\_Cells', 'Effector\_T\_Cells', 'Macrophages', ...
    'Endothelial\_Cells', 'Fibroblasts' };
columnLabels = {'mu\_cc',  'mu\_treg', 'mu\_teff', 'mu\_m',  'mu\_f'};

% Calculate mean sensitivity across all files
if length(allSensitivityMatrices) > 1
    meanSensitivityMatrix = mean(cat(3, allSensitivityMatrices{:}), 3);
else
    meanSensitivityMatrix = allSensitivityMatrices{1};
end

% --- Normalize mean sensitivity matrix between -1 and 1 ---
maxAbsVal = max(abs(meanSensitivityMatrix(:)));
if maxAbsVal > 0
    meanSensitivityMatrix = meanSensitivityMatrix ./ maxAbsVal;
end

% Create heatmap of mean sensitivities
figure('Position', [10, 10, 800, 500]);

% Create heatmap with custom options
% For older MATLAB versions, use the more compatible approach
h = heatmap(columnLabels, rowLabels, meanSensitivityMatrix, ...
    'ColorbarVisible', 'on', ...
    'CellLabelFormat', '%.3f');

title('Chemotherapy RD Patients Mean I\_R Sensitivity Matrix');
colormap('parula');

% Use a try-catch to handle different MATLAB versions
try
    % For newer MATLAB versions
    h.FontColor = 'black';  % Text color to black
    
    % For older MATLAB versions, try to use heatmap-specific properties
    % Find and modify the text elements after the heatmap is created
    drawnow;  % Force figure to update
    
    % Finding text objects after rendering
    hFig = gcf;
    axesObjs = findall(hFig, 'Type', 'Axes');
    
    for i = 1:length(axesObjs)
        textObjs = findall(axesObjs(i), 'Type', 'Text');
        set(textObjs, 'Color', 'black');
    end
catch
    warning('Could not set text color properties directly. Using alternative method.');
end

% Calculate sensitivity rankings for each label
max_rank = size(meanSensitivityMatrix, 1);
sensitivity_rankings = zeros(size(meanSensitivityMatrix));

for j = 1:size(meanSensitivityMatrix, 2)
    % Get the column and sort its absolute values
    column = abs(meanSensitivityMatrix(:, j));
    [sorted_vals, ranking] = sort(column, 'descend');
    
    % Assign rankings (6 for highest sensitivity, 1 for lowest)
    for i = 1:length(ranking)
        sensitivity_rankings(ranking(i), j) = max_rank - i + 1;
    end
end

% Create line plot for sensitivity rankings
figure('Position', [10, 10, 800, 500]);
hold on;

% Specific calculations for different ranking metrics
global_rd_msqr = sqrt(sensitivity_rankings(2, :));
global_rd_mabs = mean(sensitivity_rankings(3:4, :), 1);
global_rd_mean = mean(sensitivity_rankings, 1);
global_rd_max = max(sensitivity_rankings, [], 1);
global_rd_min = min(sensitivity_rankings, [], 1);

% Plot rankings with more distinctive style
plot(1:length(columnLabels), global_rd_msqr, 'ro-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'global rd msqr');
plot(1:length(columnLabels), global_rd_mabs, 'yo-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'global rd mabs');
plot(1:length(columnLabels), global_rd_mean, 'go-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'global rd mean');
plot(1:length(columnLabels), global_rd_max, 'mo-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'global rd max');
plot(1:length(columnLabels), global_rd_min, 'co-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'global rd min');

% Customize the plot
title('Global Relative Ranking of Parameters');
xlabel('Parameters (ordered by decreasing order)');
ylabel('Relative Ranking');
xlim([1 length(columnLabels)]);
ylim([min([global_rd_msqr, global_rd_mabs, global_rd_mean, global_rd_max, global_rd_min]) - 1, ...
       max([global_rd_msqr, global_rd_mabs, global_rd_mean, global_rd_max, global_rd_min]) + 1]);
xticks(1:length(columnLabels));
xticklabels(columnLabels);
legend('show', 'Location', 'best');
grid on;
hold off;

% Print out the sensitivity rankings
disp('Sensitivity Rankings:');
disp(array2table(sensitivity_rankings, ...
    'VariableNames', columnLabels, ...
    'RowNames', rowLabels));

% Print out the mean sensitivity matrix
disp('Mean Sensitivity Matrix:');
disp(array2table(meanSensitivityMatrix, ...
    'VariableNames', columnLabels, ...
    'RowNames', rowLabels));