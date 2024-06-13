%% Tether force (wing loading) and max. stress for tether sizing variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:\PhD\GitHubRepo\AWE-Power\src'));
addpath(genpath('C:\PhD\GitHubRepo\AWE-Eco\src'));

% Add inputFiles to path
addpath(genpath([pwd '\inputFiles']));

%% Grid search or Exhaustive search
clc; clearvars; 

% Defined input sheet
inputSheet_100kW_scale;

% Define the design space
% tetherSigma = [5e8, 6e8]; % Pa % Max stress limit for tether diameter sizing
% maxWL_values = [2,3,4]; % kN/m^2 % Maximum wing loading values

tetherSigma = [4e8, 5e8, 6e8]; % Pa % Max stress limit for tether diameter sizing
maxWL_values = [2,3,4]; % kN/m^2 % Maximum wing loading values

% Initialize variables to store results
num_points_tetherSigma = length(tetherSigma);
num_points_maxWL = length(maxWL_values);
LCoE_values = zeros(num_points_tetherSigma, num_points_maxWL);

% Loop over each combination of wing area and maxWL
for i = 1:num_points_tetherSigma
    for j = 1:num_points_maxWL
        
        inputs.Ft_max         = maxWL_values(j) * inputs.S;
        inputs.Te_matStrength = tetherSigma(i);

        % Save inputs
        designSpace(i).systemInputs(j) = inputs;
    
        % AWE-Power
        [~, ~, ~, designSpace(i).perfOutputs(j)] = main_awePower(inputs);

        % AWE-Eco
        inp = eco_system_inputs_Example_SE(inputs, designSpace(i).perfOutputs(j));
        [~, ~, designSpace(i).ecoOutputs(j)] = eco_main(inp);
        LCoE_values(i,j) = designSpace(i).ecoOutputs(j).metrics.LCoE;     

    end
end

% Find the optimal combination of maxWL and WA that minimizes the LCoE
[minLCoE, minIdx]                  = min(LCoE_values(:));
[optIdx_tetherSigma, optIdx_maxWL] = ind2sub(size(LCoE_values), minIdx);
optTetherSigma                     = tetherSigma(optIdx_tetherSigma);
optMaxWL                           = maxWL_values(optIdx_maxWL);

% Plots

% Plotting power curves for each wing area in separate plots
for i = 1:length(tetherSigma)
    % Initialize the figure
    figure;
    hold on;
    grid on;
    xlabel('Wind Speed [m/s]');
    ylabel('Average Power Output [MW]');
    title(['Power Curve for Tether sigma = ' num2str(tetherSigma(i)) ' Pa']);
    
    % Loop through each wing loading (WL) for the current wing area
    for j = 1:length(maxWL_values)
        % Extract power curve data
        avg_power_output = designSpace(i).perfOutputs(j).P_e_avg;
        
        % Plot power curve
        plot(avg_power_output / 1e6, '-o', 'LineWidth', 2);
    end
    
    % Add legend
    legendEntries = cell(1, length(maxWL_values));
    for j = 1:length(maxWL_values)
        legendEntries{j} = ['WL = ' num2str(maxWL_values(j)) ' kN/m^2'];
    end
    legend(legendEntries, 'Location', 'Best');
    
    % Show the plot
    hold off;
end

% Plotting LCoE vs Tether sigma for different Wing Loadings (WL)
figure;
hold on;
grid on;
xlabel('Tether sigma [Pa]');
ylabel('Levelized Cost of Energy (LCoE) [$/MWh]');
title('LCoE vs Tether sigma for different Wing Loadings');

% Define legend entries
legendEntries = cell(1, length(maxWL_values));

% Loop through each Wing Loading (WL)
for j = 1:length(maxWL_values)
    LCoE_values_plot = [];
    
    % Loop through each Wing Area (WA)
    for i = 1:length(tetherSigma)
        LCoE_values_plot(i) = LCoE_values(i, j);
    end
    
    % Plot LCoE for the current WL
    plot(tetherSigma, LCoE_values_plot, '-o', 'LineWidth', 2);
    
    % Store legend entry for the current WL
    legendEntries{j} = ['WL = ' num2str(maxWL_values(j)) ' kN/m^2'];
end

% Add legend to the plot
legend(legendEntries, 'Location', 'Best');
hold off;

% Contour Plot
figure;
contourf(maxWL_values, tetherSigma, LCoE_values, 20);
colorbar;
hold on;
plot(optMaxWL, optTetherSigma, 'ro', 'MarkerSize', 10); % Plot optimal solution
xlabel('Maximum Wing Loading (maxWL) [kN/m^2]');
ylabel('Wing Area (WA) [m^2]');
title('LCoE Contour Plot');
grid on;
hold off;

% Display results
disp('Optimized tether sigma [Pa]:');
disp(optTetherSigma);

disp('Optimized Maximum Wing Loading (maxWL) [kN/m^2]:');
disp(optMaxWL);

disp('Minimum LCoE [$/MWh]:');
disp(minLCoE);

% % Objective function
% function [LCoE, processedOutputs, eco] = objectiveFunction(maxWL, tetherSigma, inputs)
% 
%     inputs.Ft_max = maxWL * inputs.S;
%     inputs.Te_matStrength = tetherSigma;
% 
%     [~, ~, ~, processedOutputs] = main_awePower(inputs);
%     inp = eco_system_inputs_Example_SE(inputs, processedOutputs);
%     [~, ~, eco] = eco_main(inp);
%     LCoE = eco.metrics.LCoE;
% end