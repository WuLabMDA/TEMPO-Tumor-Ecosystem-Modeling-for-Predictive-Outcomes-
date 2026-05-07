% MATLAB Script to calculate mean values for each cell type across patient IDs
% This script imports the consolidated dataset, finds the means of each cell type,
% and saves the results to a new CSV file.
clc;
clear all;
close all;


function meanData = calculateMeanRDData()
    % Import the consolidated data file
    try
        % Attempt to read the consolidated data file
        consolidatedData = readtable('Chemotherapy_Consolidated_RD_Data.csv');
        fprintf('Successfully imported Chemotherapy_Consolidated_RD_Data.csv\n');
    catch e
        error('Error importing consolidated data file: %s', e.message);
    end
    
    % Get column names
    columnNames = consolidatedData.Properties.VariableNames;
    
    % Identify unique cell types (without patient IDs)
    cellTypes = {};
    for i = 1:length(columnNames)
        % Extract the cell type by finding the underscore that separates cell type from patient ID
        parts = split(columnNames{i}, '_');
        if length(parts) >= 2
            % Combine all parts except the last one (which is the patient ID)
            cellType = strjoin(parts(1:end-1), '_');
            if ~ismember(cellType, cellTypes)
                cellTypes{end+1} = cellType;
            end
        end
    end
    
    fprintf('Identified %d unique cell types: %s\n', length(cellTypes), strjoin(cellTypes, ', '));
    
    % Create a new table for the mean values
    meanData = array2table(zeros(height(consolidatedData), length(cellTypes)), 'VariableNames', strcat(cellTypes, '_Mean'));
    
    % Calculate mean for each cell type
    for i = 1:length(cellTypes)
        cellType = cellTypes{i};
        fprintf('Calculating mean for %s...\n', cellType);
        
        % Find all columns that match this cell type
        matchingCols = contains(columnNames, [cellType, '_']);
        
        if sum(matchingCols) > 0
            % Extract the matching columns
            matchingData = consolidatedData(:, matchingCols);
            
            % Calculate the mean across these columns
            meanCol = mean(table2array(matchingData), 2, 'omitnan');
            
            % Add the mean column to the output table
            meanData.([cellType, '_Mean']) = meanCol;
        else
            warning('No columns found for cell type: %s', cellType);
        end
    end
    
    % Display summary
    fprintf('Mean calculation complete. Output table has %d rows and %d columns.\n', ...
        height(meanData), width(meanData));
    
    % Write the mean data to a new CSV file
    outputFile = 'Chemotherapy_Mean_RD_Data.csv';
    writetable(meanData, outputFile);
    fprintf('Mean data saved to: %s\n', outputFile);
    
    % Create line plots for each mean column
    plotMeanData(meanData, cellTypes);
end

function plotMeanData(meanData, cellTypes)
    % Function to create line plots for each mean column
    fprintf('Generating line plots for mean values...\n');
    
    % Create x-axis scaled from 0-2
    numRows = height(meanData);
    x = linspace(0, 2, numRows);
    
    % Create a figure with a nice size
    figure('Position', [100, 100, 1200, 800], 'Name', 'Cell Type Mean Values');
    
    % Calculate the grid layout based on the number of cell types
    numPlots = length(cellTypes);
    numRows = ceil(numPlots / 2);
    numCols = min(2, numPlots);
    
    % For debugging
    fprintf('Creating %d individual plots in a %dx%d grid\n', numPlots, numRows, numCols);
    
    % Create individual plots for each cell type
    for i = 1:length(cellTypes)
        cellType = cellTypes{i};
        columnName = [cellType, '_Mean'];
        
        % Debug info
        fprintf('Processing plot %d: %s\n', i, columnName);
        
        % Create a subplot
        subplot(numRows, numCols, i);
        
        % Plot the data
        plot(x, meanData.(columnName), 'LineWidth', 2);
        
        % Add labels and title
        title(strrep(cellType, '_', ' '), 'FontWeight', 'bold');
        xlabel('Time');
        ylabel('Mean Percentage');
        grid on;
        
        % Set x-axis limits to 0-2
        xlim([0 2]);
        
        % Add a text annotation with basic statistics
        meanVal = mean(meanData.(columnName), 'omitnan');
        maxVal = max(meanData.(columnName), [], 'omitnan');
        minVal = min(meanData.(columnName), [], 'omitnan');
        
        stats = sprintf('Mean: %.2f\nMax: %.2f\nMin: %.2f', meanVal, maxVal, minVal);
        text(0.05, 0.95, stats, 'Units', 'normalized', ...
            'VerticalAlignment', 'top', 'FontSize', 8, ...
            'BackgroundColor', [1 1 1 0.7]);
    end
    
    % Add an overall title
    sgtitle('Mean Values of Cell Types Across All Patients', 'FontSize', 16);
    
    % Adjust spacing between subplots
    tight = get(gcf, 'Position');
    set(gcf, 'Position', [tight(1:2), tight(3)*1.1, tight(4)*1.1]);
    
    % Save the figure as an image
    saveas(gcf, 'Chemotherapy_RD_Cell_Type_Mean_Values.png');
    saveas(gcf, 'Chemotherapy_RD_Cell_Type_Mean_Values.fig');
    fprintf('Plots saved as Cell_Type_Mean_Values.png and Cell_Type_Mean_Values.fig\n');
    
    % Create a combined plot with all means on one graph
    figure('Position', [100, 100, 1200, 800], 'Name', 'Combined Cell Type Mean Values');
    hold on;
    
    % Use different colors and line styles for each cell type
    lineStyles = {'-', '--', ':', '-.', '-', '--'};
    colorOrder = get(gca, 'ColorOrder');
    legendEntries = {};
    
    % Plot each cell type mean
    for i = 1:length(cellTypes)
        cellType = cellTypes{i};
        columnName = [cellType, '_Mean'];
        
        % Plot the data with specific line style and color
        colorIdx = mod(i-1, size(colorOrder, 1)) + 1;
        lineIdx = mod(i-1, length(lineStyles)) + 1;
        
        plot(x, meanData.(columnName), lineStyles{lineIdx}, ...
            'Color', colorOrder(colorIdx,:), 'LineWidth', 2);
        
        % Add to legend entries
        legendEntries{end+1} = strrep(cellType, '_', ' ');
    end
    
    % Add labels, title, and legend
    title('Comparison of Mean Cell Type Values', 'FontSize', 16, 'FontWeight', 'bold');
    xlabel('Time ', 'FontSize', 14);
    ylabel('Mean Percentage', 'FontSize', 14);
    grid on;
    legend(legendEntries, 'Location', 'best', 'FontSize', 12);
    
    % Set x-axis limits to 0-2 for the combined plot
    xlim([0 2]);
    
    % Save the combined figure
    saveas(gcf, 'Chemotherapy_RD_Combined_Cell_Type_Mean_Values.png');
    saveas(gcf, 'Chemotherapy_RD_Combined_Cell_Type_Mean_Values.fig');
    fprintf('Combined plot saved as Combined_Cell_Type_Mean_Values.png and Combined_Cell_Type_Mean_Values.fig\n');
end

% Execute the function
meanData = calculateMeanRDData();