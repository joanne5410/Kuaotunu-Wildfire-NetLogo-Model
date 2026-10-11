
%% Figure 7: Effect of Water Source and Distance
clear; clc; close all;

% Import experiment data
T = readtable('Experiment6_Watersource_DistanceToWater.csv', ...
    'VariableNamingRule', 'preserve');

% Check the actual column names
disp(T.Properties.VariableNames)

% Keep completed simulations only
% Change 200 if your actual endpoint is different
T = T(T.("ticks") == 200, :);

% Remove rows with missing values
T = T(~isnan(T.("distance-to-water")) & ...
    ~isnan(T.("vegetation-burned")), :);

% Identify water source types and distances
waterTypes = unique(string(T.("water-source-type")), 'stable');
distances = sort(unique(T.("distance-to-water")));

% Calculate mean and standard deviation
meanBurned = nan(numel(distances), numel(waterTypes));
sdBurned = nan(numel(distances), numel(waterTypes));

for i = 1:numel(waterTypes)
    for j = 1:numel(distances)

        idx = string(T.("water-source-type")) == waterTypes(i) & ...
            T.("distance-to-water") == distances(j);

        values = T.("vegetation-burned")(idx);

        if ~isempty(values)
            meanBurned(j,i) = mean(values, 'omitnan');
            sdBurned(j,i) = std(values, 'omitnan');
        end
    end
end

% Draw grouped bar chart
figure('Color', 'w');

b = bar(distances, meanBurned, 'grouped');
hold on;

% Add standard deviation error bars
for i = 1:numel(waterTypes)
    x = b(i).XEndPoints;
    errorbar(x, meanBurned(:,i), sdBurned(:,i), ...
        'k', 'LineStyle', 'none', 'LineWidth', 1);
end

xlabel('Distance to Water');
ylabel('Vegetation Burned (%)');
title('Effect of Water Source and Distance on Vegetation Burned');

legend(waterTypes, 'Location', 'best', ...
    'Interpreter', 'none');

ylim([0 100]);
grid on;
box on;
hold off;
