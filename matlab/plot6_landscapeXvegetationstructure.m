
%% Figure 6: Landscape Type x Vegetation Structure

% 1. Remove unsuccessful runs
T_clean = T(T.ticks > 0, :);

% 2. Define category labels
landscape_labels = {'Coastal Scrub', ...
    'Pine Plantation', ...
    'Native Bush', ...
    'Grassland'};

landscape_values = {'coastal-scrub', ...
    'pine-plantation', ...
    'native-bush', ...
    'grassland'};

structures = {'surface-scrub-only', ...
    'ladder-fuel-transition', ...
    'dense-crown-canopy'};

% 3. Initialise result matrices
mean_burned = nan(4, 3);
sd_burned = nan(4, 3);
n_runs = zeros(4, 3);

% 4. Calculate mean and SD for each combination
for i = 1:4
    for j = 1:3

        idx = strcmp(string(T_clean.("landscape-type")), ...
            landscape_values{i}) & ...
            strcmp(string(T_clean.("vegetation-structure")), ...
            structures{j});

        values = T_clean.("vegetation-burned")(idx);

        if ~isempty(values)
            mean_burned(i,j) = mean(values);
            sd_burned(i,j) = std(values);
            n_runs(i,j) = numel(values);
        end
    end
end

% 5. Draw grouped bar chart
figure('Color', 'w');

b = bar(mean_burned, 'grouped');
hold on;

% Add standard deviation error bars
for j = 1:3
    x = b(j).XEndPoints;
    errorbar(x, mean_burned(:,j), sd_burned(:,j), ...
        'k', 'linestyle', 'none', 'LineWidth', 1);
end

% 6. Format chart
set(gca, 'XTick', 1:4, ...
    'XTickLabel', landscape_labels);

xlabel('Landscape Type');
ylabel('Mean Vegetation Burned (%)');

title(['Landscape Type × Vegetation Structure: ', ...
    'Fire Susceptibility']);

legend({'Surface Scrub Only', ...
    'Ladder Fuel Transition', ...
    'Dense Crown Canopy'}, ...
    'Location', 'best');

ylim([0 100]);
grid on;
box on;
hold off;

% 7. Export high-resolution figure
exportgraphics(gcf, 'Figure6_Landscape_Vegetation.png', ...
    'Resolution', 300);

% 8. Display sample sizes for quality checking
disp('Number of successful runs per combination:');
disp(array2table(n_runs, ...
    'RowNames', landscape_labels, ...
    'VariableNames', {'SurfaceScrub', ...
    'LadderFuel', 'DenseCanopy'}));
