% MATLAB Script to Horizontally Consolidate Multiple CSV Files
% This script finds all CSV files with names starting with "PCR_Patient",
% reads them, and combines them horizontally with PatientID in column names.

clc;
clear all;



function consolidatedData = consolidatePCRFiles(folderPath)
    % If no folder path provided, use current directory
    if nargin < 1
        folderPath = pwd;
    end
    
    % Find all CSV files in the folder that start with "PCR_Patient"
    filePattern = fullfile(folderPath, 'PCR_Patient*.csv');
    files = dir(filePattern);
    
    % Check if any files were found
    if isempty(files)
        error('No CSV files found with names starting with "PCR_Patient".');
    end
    
    fprintf('Found %d CSV files to process.\n', length(files));
    
    % Initialize variables to store data
    consolidatedData = [];
    columnLabels = {}; % Store column labels for all files
    allData = {}; % Store data from all files
    
    % First pass: Read all files and store their data and column names
    for i = 1:length(files)
        % Get the full file path
        filePath = fullfile(folderPath, files(i).name);
        fprintf('Reading file %d of %d: %s\n', i, length(files), files(i).name);
        
        try
            % Read the CSV file
            currentData = readtable(filePath);
            
            % Extract patient ID from filename
            patientID = extractBetween(files(i).name, 'PCR_Patient_', '_simulation');
            if ~isempty(patientID)
                patientID = patientID{1};
                
                % Store original column names and data
                allData{i} = currentData;
                columnLabels{i} = currentData.Properties.VariableNames;
            end
        catch e
            warning('Error reading file %s: %s', files(i).name, e.message);
        end
    end
    
    % Determine the row count (assuming all files have the same number of rows)
    if ~isempty(allData)
        rowCount = height(allData{1});
        
        % Create empty table with appropriate number of rows
        consolidatedData = array2table(zeros(rowCount, 0));
    else
        error('No valid data files were read.');
    end
    
    % Second pass: Construct the consolidated table
    for i = 1:length(allData)
        % Extract patient ID from filename
        patientID = extractBetween(files(i).name, 'PCR_Patient_', '_simulation');
        patientID = patientID{1};
        
        currentData = allData{i};
        currentLabels = columnLabels{i};
        
        % Process each column from the current file
        for j = 1:width(currentData)
            columnName = currentLabels{j};
            newColumnName = [columnName, '_', patientID];
            
            % Add this column to the consolidated data
            consolidatedData.(newColumnName) = currentData.(columnName);
        end
    end
    
    % Display summary
    fprintf('Consolidation complete. The combined dataset has %d rows and %d columns.\n', ...
        height(consolidatedData), width(consolidatedData));
    
    % Write the consolidated data to a new CSV file
    outputFile = fullfile(folderPath, 'Chemotherapy_Consolidated_PCR_Data.csv');
    writetable(consolidatedData, outputFile);
    fprintf('Consolidated data saved to: %s\n', outputFile);
end

% Example usage:
 consolidatedData = consolidatePCRFiles();