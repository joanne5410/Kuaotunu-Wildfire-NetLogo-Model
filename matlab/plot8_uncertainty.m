
%% Figure 8: Model Uncertainty - Monte Carlo Boxplot
clear; clc; close all;

% 1. Import BehaviorSpace results
T = readtable('Experiment7_monte_carlo_uncertainty.csv', ...
    'VariableNamingRule', 'preserve');

% Check column names
disp(T.Properties.VariableNames)

% 2. Extract vegetation burned values
burned = T.("vegetation-burned");
burned = burned(~isnan(burned));

% 3. Check the number of valid runs
fprintf('Number of valid runs: %d\n', numel(burned));
fprintf('Mean burned: %.2f%%\n', mean(burned));
fprintf('Standard deviation: %.2f percentage points\n', ...
    std(burned));
fprintf('Median burned: %.2f%%\n', median(burned));

% 4. Draw boxplot
figure('Color', 'w');

boxplot(burned, ...
    'Labels', {'50 Monte Carlo Runs'});

ylabel('Vegetation Burned (%)');
title('Model Uncertainty: Monte Carlo Simulation');
ylim([0 100]);
grid on;
box on;

% 5. Save figure
exportgraphics(gcf, ...
    'Figure8_MonteCarlo_Boxplot.png', ...
    'Resolution', 300);
