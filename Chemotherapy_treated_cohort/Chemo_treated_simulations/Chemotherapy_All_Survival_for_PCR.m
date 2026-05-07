% MATLAB Script to Consolidate Multiple CSV Files (PCR and RD Patients)
% This script finds all CSV files starting with "PCR_Patient" or "RD_Patient",
% reads them, adds a 'Survival' column ("PCR" or "RD"), and combines them vertically.

clc;
clear all;

function consolidatedData = consolidatePCR_RD_Files(folderPath)
    % If no folder path provided, use current directory
    if nargin < 1
        folderPath = pwd;
    end

    % --- Find all PCR and RD CSV files ---
    pcrFiles = dir(fullfile(folderPath, 'PCR_Patient*.csv'));
    rdFiles  = dir(fullfile(folderPath, 'RD_Patient*.csv'));
    allFiles = [pcrFiles; rdFiles];

    % Check if any files found
    if isempty(allFiles)
        error('No CSV files found starting with "PCR_Patient" or "RD_Patient".');
    end

    fprintf('Found %d CSV files to process.\n', length(allFiles));

    % Initialize combined table
    consolidatedData = table();

    % --- Loop through all files ---
    for i = 1:length(allFiles)
        filePath = fullfile(folderPath, allFiles(i).name);
        fprintf('Reading file %d of %d: %s\n', i, length(allFiles), allFiles(i).name);

        try
            % Read the current file
            currentData = readtable(filePath);

            % Determine survival type from filename
            if startsWith(allFiles(i).name, 'PCR_Patient', 'IgnoreCase', true)
                survivalType = "PCR";
            elseif startsWith(allFiles(i).name, 'RD_Patient', 'IgnoreCase', true)
                survivalType = "RD";
            else
                survivalType = "Unknown";
            end

            % Add survival column
            currentData.Survival = repmat(survivalType, height(currentData), 1);

            % Append to consolidated data
            consolidatedData = [consolidatedData; currentData];

        catch e
            warning('Error reading file %s: %s', allFiles(i).name, e.message);
        end
    end

    % Display summary
    fprintf('Consolidation complete. The combined dataset has %d rows and %d columns.\n', ...
        height(consolidatedData), width(consolidatedData));

    % --- Write to new CSV file ---
    outputFile = fullfile(folderPath, 'Chemotherapy_Consolidated_Data_ALL_Patient_for_PCA.csv');
    writetable(consolidatedData, outputFile);
    fprintf('Consolidated data saved to: %s\n', outputFile);
end

% Example usage:
consolidatedData = consolidatePCR_RD_Files();
