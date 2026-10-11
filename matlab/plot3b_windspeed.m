%% Experiment 2 – Fixed 150 Ticks
% Effect of wind speed on vegetation burned
%
% X-axis: Wind speed
% Y-axis: Vegetation burned (%)
% Ticks are fixed at 150.
% Unsuccessful runs with vegetation_burned = 0 and ticks = 0
% are excluded from the analysis.

clear;
clc;
close all;

%% 1. Load data
data = readtable('Experiment2-1_WindSpeed.csv');

%% 2. Remove unsuccessful runs
validData = data(data.vegetation_burned > 0 & data.ticks > 0, :);

%% 3. Identify wind speed levels
windLevels = unique(validData.wind_speed);

%% 4. Calculate mean vegetation burned for each wind speed
meanBurned = zeros(size(windLevels));

for i = 1:length(windLevels)

    currentData = validData(validData.wind_speed == windLevels(i), :);

    meanBurned(i) = mean(currentData.vegetation_burned);

end

%% 5. Display results
results = table(windLevels, meanBurned, ...
    'VariableNames', {'WindSpeed', 'MeanVegetationBurned'});

disp(results);

%% 6. Create figure
figure;

plot(windLevels, meanBurned, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 6);

xlabel('Wind speed');
ylabel('Vegetation burned (%)');

title('Effect of Wind Speed on Vegetation Burned at 150 Ticks');

grid on;

%% 7. Set Y-axis to 0–100%
ylim([0 100]);
