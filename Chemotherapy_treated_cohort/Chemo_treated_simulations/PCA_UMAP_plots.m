%% MATLAB Code to plot and save high-resolution UMAP figure
clear all;
close all;
clc;

%% 1. Load Data
try
    data = readtable('UMAP_CellType_PCR_RD.csv');
catch
    error('Could not load UMAP_CellType_PCR_RD.csv. Ensure the file is in the current folder.');
end

% Check for required columns
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

celltype_canonical_names = {
    'cancercells';
    'regulatorytcell';
    'effectortcells';
    'macrophages';
    'endothelialcells';
    'fibroblast'
};

celltype_legend_names = {
    'Cancer\_Cells';
    'Regulatory\_T\_Cells';
    'Effector\_T\_Cells';
    'Macrophages';
    'Endothelial\_Cells';
    'Fibroblast'
};

%% 3. Normalize Data
data.CellType = categorical(data.CellType);

%% 4. Define Markers
group_markers = {'o', '>'}; % PCR = circle, RD = right triangle
group_names = {'PCR', 'RD'};

%% 5. Initialize Figure
fig = figure('Position', [50 50 900 600], 'Color', 'w');
hold on;
marker_size = 100;

%% 6. Plot Each CellType + Group
num_celltypes = length(celltype_canonical_names);
num_groups = length(group_names);

for i = 1:num_celltypes
    canonical_name = celltype_canonical_names{i};
    for j = 1:num_groups
        group = group_names{j};
        marker = group_markers{j};
        idx = (data.CellType == canonical_name) & strcmp(data.Group, group);
        subset = data(idx, :);
        if ~isempty(subset)
            scatter(subset.UMAP1, subset.UMAP2, marker_size, celltype_colors(i,:), ...
                marker, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
        end
    end
end

%% 7. Labels and Formatting
xlabel('UMAP1', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('UMAP2', 'FontSize', 18, 'FontWeight', 'bold');
title('', ...
      'FontSize', 20, 'FontWeight', 'bold');
grid on; box on;

ax = gca;
ax.FontSize = 14;
ax.FontWeight = 'bold';
ax.LineWidth = 1.2;

%% 8. Legends
celltype_legend_names = celltype_legend_names(:);
group_names = group_names(:);

h_color = gobjects(num_celltypes,1);
for i = 1:num_celltypes
    h_color(i) = plot(NaN, NaN, 'o', 'MarkerSize', 12, ...
        'MarkerFaceColor', celltype_colors(i,:), 'MarkerEdgeColor', 'k', ...
        'LineWidth', 1, 'DisplayName', celltype_legend_names{i});
end

h_marker = gobjects(num_groups,1);
for j = 1:num_groups
    h_marker(j) = plot(NaN, NaN, group_markers{j}, 'MarkerSize', 12, ...
        'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', 'k', ...
        'LineWidth', 1, 'DisplayName', group_names{j});
end

legend([h_color; h_marker], [celltype_legend_names; group_names], ...
    'Location', 'bestoutside', 'NumColumns', 1, 'FontSize', 12, 'Box', 'on');

hold off;

%% 9. Save Figure (High-Resolution)
output_basename = 'UMAP_CellType_PCR_RD_HighRes';

% Save as MATLAB figure (.fig)
savefig(fig, [output_basename '.fig']);

% Save as 1200 dpi PNG (journal quality)
print(fig, [output_basename '.png'], '-dpng', '-r1200');

% Optionally, also save as TIFF (some journals prefer this)
print(fig, [output_basename '.tiff'], '-dtiff', '-r1200');

disp(['Saved high-resolution figure as: ' output_basename '.png and .tiff']);
