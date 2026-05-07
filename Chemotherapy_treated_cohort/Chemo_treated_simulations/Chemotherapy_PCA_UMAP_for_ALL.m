%% Chemotherapy PCA + UMAP Comparison (Celltype + PCR/RD + Colors/Markers)
clear; clc; close all;

%% ---------------- Load the Data ----------------
filePCR = 'Chemotherapy_Consolidated_PCR_Data.csv';
fileRD  = 'Chemotherapy_Consolidated_RD_Data.csv';

fprintf('Loading data...\n');
tPCR = readtable(filePCR);
tRD  = readtable(fileRD);

fprintf('Loaded PCR data (%d rows, %d cols)\n', size(tPCR,1), size(tPCR,2));
fprintf('Loaded RD data (%d rows, %d cols)\n', size(tRD,1), size(tRD,2));

%% ---------------- Normalize Column Names ----------------
normalizeNames = @(names) lower(regexprep(names, '[^a-zA-Z0-9]', ''));
stdNamesPCR = normalizeNames(tPCR.Properties.VariableNames);
stdNamesRD  = normalizeNames(tRD.Properties.VariableNames);

%% ---------------- Fuzzy Matching Columns ----------------
matchedPCR = [];
matchedRD  = [];
matchPairs = {};
simScores  = [];

for i = 1:length(stdNamesPCR)
    n1 = stdNamesPCR{i};
    distances = cellfun(@(n2) editDistance(n1, n2), stdNamesRD);
    [minDist, idx] = min(distances);
    simScore = 1 - (minDist / max(strlength(n1), strlength(stdNamesRD{idx})));
    if simScore > 0.85
        matchedPCR(end+1) = i;
        matchedRD(end+1)  = idx;
        matchPairs{end+1,1} = n1;
        matchPairs{end,2}   = stdNamesRD{idx};
        simScores(end+1) = simScore;
    end
end

fprintf('Matched columns (fuzzy): %d\n', numel(matchedPCR));
if isempty(matchedPCR), error('No matching columns found.'); end

tPCR = tPCR(:, matchedPCR);
tRD  = tRD(:, matchedRD);

commonNames = stdNamesPCR(matchedPCR);
tPCR.Properties.VariableNames = commonNames;
tRD.Properties.VariableNames  = commonNames;

% Save fuzzy match report
matchSummary = table(matchPairs(:,1), matchPairs(:,2), simScores', ...
    'VariableNames', {'PCR_Name','RD_Name','Similarity'});
writetable(matchSummary, 'Fuzzy_Match_Report.csv');
fprintf('📄 Fuzzy match summary saved to Fuzzy_Match_Report.csv\n');

%% ---------------- Harmonize Data Types ----------------
for v = 1:numel(commonNames)
    colPCR = tPCR.(commonNames{v});
    colRD  = tRD.(commonNames{v});
    if iscell(colPCR) && isnumeric(colRD), tPCR.(commonNames{v}) = str2double(colPCR); end
    if iscell(colRD) && isnumeric(colPCR), tRD.(commonNames{v}) = str2double(colRD); end
    if iscell(tPCR.(commonNames{v})), tPCR.(commonNames{v}) = string(tPCR.(commonNames{v})); end
    if iscell(tRD.(commonNames{v})), tRD.(commonNames{v}) = string(tRD.(commonNames{v})); end
end

%% ---------------- Combine Data ----------------
tPCR.SurvivalStatus = repmat("PCR", height(tPCR), 1);
tRD.SurvivalStatus  = repmat("RD", height(tRD), 1);
T = [tPCR; tRD];

%% ---------------- Define Base Cell Types ----------------
base_cell_types = {'cancercells','regulatorytcell','effectortcells',...
                   'macrophages','endothelialcells','fibroblast'};

% Collect columns for each base cell type
cell_cols = cell(length(base_cell_types),1);
for i = 1:length(base_cell_types)
    idx = find(contains(lower(T.Properties.VariableNames), base_cell_types{i}));
    if isempty(idx)
        warning('No columns found for %s', base_cell_types{i});
    end
    cell_cols{i} = idx;
end

%% ---------------- Extract Numeric Data ----------------
all_cols = [cell_cols{:}];
X = T{:, all_cols};
X = fillmissing(X,'constant',0);
labels_survival = T.SurvivalStatus;

%% ---------------- Global PCA & UMAP by SurvivalStatus ----------------
[~, score, ~, ~, explained] = pca(X);

% Figure 1: PCA by SurvivalStatus
f1 = figure('Color','w');
gscatter(score(:,1), score(:,2), labels_survival, 'rb', 'o^', 8);
xlabel(sprintf('PC1 (%.1f%%)', explained(1)));
ylabel(sprintf('PC2 (%.1f%%)', explained(2)));
title('Global PCA - SurvivalStatus');
legend('PCR','RD','Location','best');
grid on; set(gca,'FontSize',12,'FontWeight','bold');
exportgraphics(f1,'Figure1_GlobalPCA_Survival.png','Resolution',600);

% Figure 2: UMAP by SurvivalStatus with jitter
rng(42);
jitter_amount = 0.05;
try
    Y = run_umap(score(:,1:min(10,size(score,2))), 'n_neighbors', 15, 'min_dist', 0.3);
catch
    Y = tsne(score(:,1:min(10,size(score,2))));
end

f2 = figure('Color','w'); hold on;
for g = ["PCR","RD"]
    grp_idx = strcmp(labels_survival,g);
    if g=="PCR"
        color=[0 0 1]; marker='o';
    else
        color=[1 0 0]; marker='>';
    end
    scatter(Y(grp_idx,1)+(rand(sum(grp_idx),1)-0.5)*jitter_amount,...
            Y(grp_idx,2)+(rand(sum(grp_idx),1)-0.5)*jitter_amount,50,color,marker,'filled');
end
xlabel('UMAP1'); ylabel('UMAP2');
title('Global UMAP - SurvivalStatus');
legend('PCR','RD','Location','bestoutside');
grid on; set(gca,'FontSize',12,'FontWeight','bold');
exportgraphics(f2,'Figure2_GlobalUMAP_Survival.png','Resolution',600);

%% ---------------- Color Palette & Markers ----------------
celltype_colors = [
    0 0 1;      % Cancer_Cells
    1 0 1;      % Regulatory_T_Cells
    0 1 1;      % Effector_T_Cells
    0 1 0;      % Macrophages
    0 0 0;      % Endothelial_Cells
    1 0 0;      % Fibroblast
];
group_markers = containers.Map({'PCR','RD'},{'o','>'});

%% ---------------- PCA & UMAP by CellType + PCR/RD ----------------
X_pca_ct = [];
X_umap_ct = [];
labels_celltype = [];
labels_group = [];

for i = 1:length(base_cell_types)
    idx = cell_cols{i};
    if isempty(idx), continue; end
    Xct = X(:, idx);
    Xct = fillmissing(Xct, 'constant', 0);
    group_ct = labels_survival;

    % PCA 2D
    [~, score_ct, ~, ~, ~] = pca(Xct);
    if size(score_ct,2)<2, score_ct(:,2)=zeros(size(score_ct,1),1); else score_ct=score_ct(:,1:2); end
    X_pca_ct = [X_pca_ct; score_ct];
    labels_celltype = [labels_celltype; repmat(base_cell_types(i), size(score_ct,1),1)];
    labels_group = [labels_group; group_ct];

    % UMAP 2D with jitter
    rng(42);
    try
        Yct = run_umap(Xct, 'n_neighbors', 15, 'min_dist', 0.3);
    catch
        Yct = tsne(Xct);
    end
    if size(Yct,2)<2, Yct(:,2)=zeros(size(Yct,1),1); else Yct=Yct(:,1:2); end
    X_umap_ct = [X_umap_ct; Yct];
end

%% ---------------- Figure 3: PCA by CellType + PCR/RD ----------------
f3 = figure('Color','w'); hold on;
unique_types = unique(labels_celltype);

for t = 1:numel(unique_types)
    type_idx = strcmp(labels_celltype, unique_types{t});
    color = celltype_colors(t,:);
    for g = ["PCR","RD"]
        grp_idx = strcmp(labels_group,g) & type_idx;
        scatter(X_pca_ct(grp_idx,1)+(rand(sum(grp_idx),1)-0.5)*jitter_amount,...
                X_pca_ct(grp_idx,2)+(rand(sum(grp_idx),1)-0.5)*jitter_amount,...
                50,color,group_markers(g),'filled');
    end
end

xlabel('PC1'); ylabel('PC2'); title('PCA - CellType + PCR/RD');
legend_entries = strings(2*numel(unique_types),1);
for t=1:numel(unique_types)
    legend_entries(2*t-1)=unique_types(t)+" PCR";
    legend_entries(2*t)=unique_types(t)+" RD";
end
legend(legend_entries,'Location','bestoutside');
grid on; set(gca,'FontSize',12,'FontWeight','bold');
exportgraphics(f3,'Figure3_GlobalPCA_CellType_PCR_RD.png','Resolution',600);

%% ---------------- Figure 4: UMAP by CellType + PCR/RD ----------------
f4 = figure('Color','w'); hold on;
for t = 1:numel(unique_types)
    type_idx = strcmp(labels_celltype, unique_types{t});
    color = celltype_colors(t,:);
    for g = ["PCR","RD"]
        grp_idx = strcmp(labels_group,g) & type_idx;
        scatter(X_umap_ct(grp_idx,1)+(rand(sum(grp_idx),1)-0.5)*jitter_amount,...
                X_umap_ct(grp_idx,2)+(rand(sum(grp_idx),1)-0.5)*jitter_amount,...
                50,color,group_markers(g),'filled');
    end
end
xlabel('UMAP1'); ylabel('UMAP2'); title('UMAP - CellType + PCR/RD');
legend(legend_entries,'Location','bestoutside');
grid on; set(gca,'FontSize',12,'FontWeight','bold');
exportgraphics(f4,'Figure4_GlobalUMAP_CellType_PCR_RD.png','Resolution',600);

%% ---------------- Save UMAP Data Used in Figure 4 ----------------
UMAP_data_table = table(X_umap_ct(:,1), X_umap_ct(:,2), labels_celltype, labels_group, ...
                        'VariableNames', {'UMAP1','UMAP2','CellType','Group'});
writetable(UMAP_data_table, 'UMAP_CellType_PCR_RD.csv');
fprintf('✅ Figure 4 UMAP data saved to "UMAP_CellType_PCR_RD.csv"\n');

fprintf('✅ All figures and UMAP data saved successfully.\n');
