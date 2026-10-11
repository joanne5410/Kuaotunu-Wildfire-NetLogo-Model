
%% Figure 5: Temperature × Relative Humidity Risk Heatmap
% Read CSV, clean data, calculate mean burned vegetation,
% and plot the heatmap.

clear;
clc;
close all;

%% 1. Load CSV data
data = readtable('Experiment4_Temperature_RH.csv');

%% 2. Check required column names

requiredColumns = {'air_temperature', ...
                   'relative_humidity', ...
                   'vegetation_burned', ...
                   'ticks'};

missingColumns = setdiff(requiredColumns, data.Properties.VariableNames);

if ~isempty(missingColumns)
    error('Missing CSV columns: %s', strjoin(missingColumns, ', '));
end

%% 3. Remove incomplete records

data = rmmissing(data, 'DataVariables', requiredColumns);

%% 4. Keep only runs that reached exactly 200 ticks

validData = data(data.ticks == 200, :);

fprintf('Rows remaining after ticks == 200: %d\n', ...
    height(validData));
fprintf('Rows removed: %d\n', height(data) - height(validData));

if isempty(validData)
    error('No records with ticks == 200. Check the CSV and tick settings.');
end

%% 5. Check temperature and humidity ranges

fprintf('Temperature levels:\n');
disp(unique(validData.air_temperature)');

fprintf('Relative humidity levels:\n');
disp(unique(validData.relative_humidity)');

%% 6. Calculate mean vegetation burned for each combination

temperatureLevels = sort(unique(validData.air_temperature));
humidityLevels = sort(unique(validData.relative_humidity));

% Rows = temperature; columns = relative humidity
meanBurned = nan(length(temperatureLevels), length(humidityLevels));
runCounts = zeros(length(temperatureLevels), length(humidityLevels));

for i = 1:length(temperatureLevels)
    for j = 1:length(humidityLevels)

        idx = validData.air_temperature == temperatureLevels(i) & ...
              validData.relative_humidity == humidityLevels(j);

        values = validData.vegetation_burned(idx);

        if ~isempty(values)
            meanBurned(i, j) = mean(values);
            runCounts(i, j) = numel(values);
        end
    end
end

%% 7. Report missing combinations

missingCells = isnan(meanBurned);

fprintf('Number of missing temperature-humidity combinations: %d\n', ...
    nnz(missingCells));

if any(runCounts(:) > 0)
    fprintf('Minimum runs in a represented combination: %d\n', ...
        min(runCounts(runCounts > 0)));
    fprintf('Maximum runs in a represented combination: %d\n', ...
        max(runCounts(:)));
end

%% 8. Plot heatmap

figure('Color', 'w', 'Position', [100 100 900 600]);

imagesc(humidityLevels, temperatureLevels, meanBurned);

set(gca, 'YDir', 'normal');
colormap(turbo(256));
cb = colorbar;
cb.Label.String = 'Mean vegetation burned (%)';

clim([0 100]);

xlabel('Relative Humidity (%)');
ylabel('Air Temperature (°C)');
title({'Figure 5: Temperature × Relative Humidity', ...
       'Mean Vegetation Burned at 200 Ticks'});

xticks(humidityLevels);
yticks(temperatureLevels);

set(gca, 'FontSize', 11, 'LineWidth', 1);

hold on;

%% 9. Mark the 11 January 2025 weather conditions
% Temperature = 28°C; Relative Humidity = 35%

plot(35, 28, 'kp', ...
    'MarkerSize', 15, ...
    'MarkerFaceColor', 'w', ...
    'LineWidth', 2);

% Annotate the observed weather point
text(35 + 2, 28, '11 Jan 2025 (28°C, 35% RH)', ...
    'Color', 'k', ...
    'FontSize', 9, ...
    'FontWeight', 'bold', ...
    'VerticalAlignment', 'bottom');

hold off;

%% 10. Save figure and processed data

exportgraphics(gcf, 'Figure5_Temperature_RH.png', ...
    'Resolution', 300);

writetable(validData, 'Figure5_CleanedData.csv');

fprintf('\nFigure 5 completed.\n');
fprintf('Saved: Figure5_Temperature_RH.png\n');
fprintf('Saved: Figure5_CleanedData.csv\n');
