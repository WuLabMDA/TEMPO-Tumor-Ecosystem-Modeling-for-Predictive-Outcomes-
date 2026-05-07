% Load CSV file
data = readtable('Goodness_of_fit_test.csv');

% Extract columns
R2 = data.Rsquared;
residual_norm = data.Residual_Norm;
groups = data.Survival;  % 'pCR' or 'RD'

% Function to compute pooled R² for a subset
compute_pooled_R2 = @(R2vals, normvals) ...
    (1 - sum(normvals.^2) / sum((normvals.^2) ./ (1 - R2vals)));

% --- Calculate pooled R² for subgroups ---
% pCR patients
mask_pCR = strcmp(groups, 'pCR');
R2_pooled_pCR = compute_pooled_R2(R2(mask_pCR), residual_norm(mask_pCR));

% RD patients
mask_RD = strcmp(groups, 'RD');
R2_pooled_RD = compute_pooled_R2(R2(mask_RD), residual_norm(mask_RD));

% Total population
R2_pooled_total = compute_pooled_R2(R2, residual_norm);

% --- Create results table ---
Results = table({'pCR'; 'RD'; 'Total Population'}, ...
                [R2_pooled_pCR; R2_pooled_RD; R2_pooled_total], ...
                'VariableNames', {'Group','Pooled_R2'});

% Display results
disp(Results);