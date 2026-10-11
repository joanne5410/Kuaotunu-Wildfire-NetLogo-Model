%% Figure 4 - Wind Speed × Slope Degree
% Two-way interaction under a fixed 200-tick period

clear;
clc;
close all;

%% 1. Load CSV data
data = readtable('Experiment3_WindxSlop_200ticks.csv');

%% 2. Remove unsuccessful runs
validData = data( ...
    data.vegetation_burned > 0 & data.ticks > 0, :);

%% 3. Check tick values
disp('Ticks recorded in valid data:');
disp(unique(validData.ticks));

%% 4. Identify wind speed and slope levels
windLevels = unique(validData.wind_speed);
slopeLevels = unique(validData.slope_degree);

%% 5. Calculate mean burned vegetation
% Rows = slope levels
% Columns = wind speed levels

meanBurned = NaN(length(slopeLevels), length(windLevels));

for i = 1:length(slopeLevels)
    for j = 1:length(windLevels)

        currentData = validData( ...
            validData.slope_degree == slopeLevels(i) & ...
            validData.wind_speed == windLevels(j), :);

        if ~isempty(currentData)
            meanBurned(i,j) = ...
                mean(currentData.vegetation_burned);
        end

    end
end

%% 6. Display mean values
results = array2table(meanBurned, ...
    'RowNames', compose('%g deg', slopeLevels), ...
    'VariableNames', ...
    matlab.lang.makeValidName( ...
    compose('Wind_%g', windLevels)));

disp('Mean vegetation burned (%) for each combination:');
disp(results);

%% 7. Create 3D surface plot
[W, S] = meshgrid(windLevels, slopeLevels);

figure;

surf(W, S, meanBurned);

xlabel('Wind speed');
ylabel('Slope degree (°)');
zlabel('Vegetation burned (%)');

title('Wind Speed × Slope Degree at 200 Ticks');

colorbar;
ylim([min(slopeLevels), max(slopeLevels)]);
zlim([0 100]);

grid on;
shading interp;
view(45, 30);