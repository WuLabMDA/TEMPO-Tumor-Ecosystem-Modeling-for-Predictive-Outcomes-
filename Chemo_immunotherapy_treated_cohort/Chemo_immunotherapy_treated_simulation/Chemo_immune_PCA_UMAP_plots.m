%% MATLAB Code to plot and save high-resolution UMAP figure (Chemo-Immuno)
clear all;
close all;
clc;

%% 1. Load Data
try
    data = readtable('Chemo_Immuno_UMAP_CellType_PCR_RD.csv');
catch
    error('Could not load Chemo_Immuno_UMAP_CellType_PCR_RD.csv. Ensure the file is in the current folder.');
end

% Check if the expected columns exist
if ~all(ismember({'UMAP1', 'UMAP2', 'CellType', 'Group'}, data.Properties.VariableNames))
    error('CSV file must contain columns named UMAP1, UMAP2, CellType, and Group.');
end

%% 2. Define Colors and Names
celltype_colors = [
    0 0 1;           % cancercells (Blue)
    1 0 1;           % regulatorytcell (Magenta)
    0 1 1;           % effectortcells (Cyan)
    0 1 0;           % macrophages (Green)
    0.294 0 0.510;   % endothelialcells (Dark Purple)
    1 0 0;           % fibroblast (Red)
];

% Canonical Names (for exact matching with CSV)
celltype_canonical_names = {
    'cancercells';
    'regulatorytcell';
    'effectortcells';
    'macrophages';
    'endothelialcells';
    'fibroblast'
};

% Legend Names (for display)
celltype_legend_names = {
    'Cancer\_Cells';
    'Regulatory\_T\_Cells';
    'Effector\_T\_Cells';
    'Macrophages';
    'Endothelial\_Cells';
    'Fibroblast'
};

%% 3. Normalize Data's CellType Column
data.CellType = categorical(data.CellType);

%% 4. Define Marker Shapes for Groups
group_markers = {'o', '>'}; % PCR = circle, RD = right triangle
group_names = {'PCR', 'RD'};

%% 5. Initialize High-Quality Figure
fig = figure('Position', [50 50 900 600], 'Color', 'w');
hold on;
marker_size = 100;  % Larger marker size for easy identification

%% 6. Iterate and Plot Each CellType + Group
num_celltypes = length(celltype_canonical_names);
num_groups = length(group_names);

for i = 1:num_celltypes
    canonical_name = celltype_canonical_names{i};
    for j = 1:num_groups
        group = group_names{j};
        marker = group_markers{j};
        
        % Filter data by CellType and Group
        idx = (data.CellType == canonical_name) & strcmp(data.Group, group);
        subset = data(idx, :);
        
        if ~isempty(subset)
            scatter(subset.UMAP1, subset.UMAP2, marker_size, celltype_colors(i,:), ...
                marker, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
        end
    end
end

%% 7. Labels, Title, and Axis Formatting
xlabel('UMAP1', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('UMAP2', 'FontSize', 18, 'FontWeight', 'bold');
title('', ...
      'FontSize', 20, 'FontWeight', 'bold');
grid on; box on;

ax = gca;
ax.FontSize = 14;
ax.FontWeight = 'bold';
ax.LineWidth = 1.2;

%% 8. Create Custom Legend
celltype_legend_names = celltype_legend_names(:);
group_names = group_names(:);

% Cell Type (Color) Legend
h_color = gobjects(num_celltypes,1);
for i = 1:num_celltypes
    h_color(i) = plot(NaN, NaN, 'o', 'MarkerSize', 10, ...
        'MarkerFaceColor', celltype_colors(i,:), 'MarkerEdgeColor', 'k', ...
        'LineWidth', 1, 'DisplayName', celltype_legend_names{i});
end

% Group (Marker) Legend
h_marker = gobjects(num_groups,1);
for j = 1:num_groups
    h_marker(j) = plot(NaN, NaN, group_markers{j}, 'MarkerSize', 10, ...
        'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', 'k', ...
        'LineWidth', 1, 'DisplayName', group_names{j});
end

% Combine handles and names
legend([h_color; h_marker], [celltype_legend_names; group_names], ...
    'Location', 'bestoutside', 'NumColumns', 1, ...
    'FontSize', 12, 'Box', 'on');

hold off;

%% 9. Save Figure (Ultra-High Resolution and Vector Formats)
output_basename = 'Chemo_Immuno_UMAP_CellType_PCR_RD_HighRes';

% Save as MATLAB Figure (editable)
savefig(fig, [output_basename '.fig']);

% Save as High-Resolution PNG (1200 dpi)
print(fig, [output_basename '.png'], '-dpng', '-r1200');

% Save as High-Resolution TIFF (preferred by some journals)
print(fig, [output_basename '.tiff'], '-dtiff', '-r1200');

% Save as Vector PDF (for Cell/Nature/Science submissions)
print(fig, [output_basename '.pdf'], '-dpdf', '-painters', '-r1200');

disp(['✅ High-resolution figure saved as: ' output_basename ...
      ' (.fig, .png, .tiff, .pdf)']);
