%% Figure 3 – Wind Speed
% Effect of wind speed on fire spread and vegetation burned
%
% X-axis: Wind speed
% Left Y-axis: Vegetation burned (%)
% Right Y-axis: Ticks
%
% Unsuccessful runs (vegetation_burned = 0 and ticks = 0)
% are excluded from the analysis.

clear;
clc;
close all;

%% 1. Load data

data = readtable('Experiment2_WindSpeed.csv');

%% 2. Remove unsuccessful runs

validData = data(data.vegetation_burned > 0 & data.ticks > 0, :);

%% 3. Identify wind speed levels

windLevels = unique(validData.wind_speed);

%% 4. Calculate mean values for each wind speed

meanBurned = zeros(size(windLevels));
meanTicks = zeros(size(windLevels));

for i = 1:length(windLevels)

    currentData = validData(validData.wind_speed == windLevels(i), :);

    meanBurned(i) = mean(currentData.vegetation_burned);
    meanTicks(i) = mean(currentData.ticks);

end

%% 5. Display results

results = table(windLevels, meanBurned, meanTicks, ...
    'VariableNames', {'WindSpeed', 'MeanVegetationBurned', 'MeanTicks'});

disp(results);

%% 6. Create figure

figure;

% --- Left Y-axis: Vegetation burned ---

yyaxis left

plot(windLevels, meanBurned, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 6);

ylabel('Vegetation burned (%)');

% Set vegetation burned axis to 0–100%
ylim([0 100]);

% --- Right Y-axis: Ticks ---

yyaxis right

plot(windLevels, meanTicks, '-s', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 6);

ylabel('Ticks');

%% 7. Labels and title

xlabel('Wind speed');

title('Effect of Wind Speed on Fire Spread');

grid on;

%% 8. Legend

legend('Vegetation burned', 'Ticks', ...
    'Location', 'best');