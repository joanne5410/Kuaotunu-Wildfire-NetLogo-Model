data = readtable("Experiment1_PlantMoisture.csv");

% Remove runs with no fire simulation
data = data(data.ticks > 0, :);

% Get moisture levels
levels = unique(data.plant_moisture);

% Calculate mean and standard deviation
mean_burned = zeros(size(levels));
sd_burned = zeros(size(levels));

for i = 1:length(levels)
    values = data.vegetation_burned(data.plant_moisture == levels(i));
    mean_burned(i) = mean(values);
    sd_burned(i) = std(values);
end

% Display results
table(levels, mean_burned, sd_burned)

figure

errorbar(levels, mean_burned, sd_burned, '-o', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 6)

xlabel('Plant moisture (%)')
ylabel('Vegetation burned (%)')
title('Effect of Plant Moisture on Vegetation Burned')

xlim([10 90])
ylim([0 105])

grid on
box on