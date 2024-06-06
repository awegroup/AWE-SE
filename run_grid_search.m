%% Design space exploration 

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:\PhD\GitHubRepo\AWE-Power\src'));
addpath(genpath('C:\PhD\GitHubRepo\AWE-Eco\src'));

% Add inputFiles to path
addpath(genpath([pwd '\inputFiles']));


%% plotting LCoEs for a range of WA and wing loading 

clc; clearvars;

% Defined input sheet
inputSheet_MW_scale_SE

% Changes in inputs
inputs.numDeltaLelems  = 1; %[num]

WA    = [80, 100, 120]; % m^2
maxWL = [2,3,4]; % kN/m^2


for i = 1:length(WA)
  designSpace(i).WA = WA(i);
  inputs.S = designSpace(i).WA;
  for j = 1:length(maxWL)

    % Performance
    inputs.Ft_max = maxWL(j)*designSpace(i).WA;
    % Get results
    [designSpace(i).systemInputs(j), ~, ~, designSpace(i).perfOutputs(j)] = main_awePower(inputs);

    % Economics
    designSpace(i).ecoInputs(j) = eco_system_inputs_Example_SE(designSpace(i).systemInputs(j), designSpace(i).perfOutputs(j));     
    [~,~,designSpace(i).ecoOutputs(j)] = eco_main(designSpace(i).ecoInputs(j));

  end
end

% Plotting script for LCoE vs Wing Area (WA) for different Wing Loadings (WL)
% Initialize the figure
figure;
hold on;
grid on;
xlabel('Wing Area (WA) [m^2]');
ylabel('Levelized Cost of Energy (LCoE) [$/MWh]');
title('LCoE vs Wing Area for different Wing Loadings');

% Define legend entries
legendEntries = cell(1, length(maxWL));

% Loop through each Wing Loading (WL)
for j = 1:length(maxWL)
    LCoE_values = [];
    
    % Loop through each Wing Area (WA)
    for i = 1:length(WA)
        LCoE_values(i) = designSpace(i).ecoOutputs(j).metrics.LCoE;
    end
    
    % Plot LCoE for the current WL
    plot(WA, LCoE_values, '-o', 'LineWidth', 2);
    
    % Store legend entry for the current WL
    legendEntries{j} = ['WL = ' num2str(maxWL(j)) ' kN/m^2'];
end

% Add legend to the plot
legend(legendEntries, 'Location', 'Best');

% Show the plot
hold off;

% Plotting power curves for each wing area in separate plots
% Loop through each wing area
for i = 1:length(WA)
    % Initialize the figure
    figure;
    hold on;
    grid on;
    xlabel('Wind Speed [m/s]');
    ylabel('Average Power Output [MW]');
    title(['Power Curve for WA = ' num2str(WA(i)) ' m^2']);
    
    % Loop through each wing loading (WL) for the current wing area
    for j = 1:length(maxWL)
        % Extract power curve data
        %wind_speeds = desSpace(i).perfOutputs(j).windSpeeds;
        avg_power_output = designSpace(i).perfOutputs(j).P_e_avg;
        
        % Plot power curve
        plot(avg_power_output / 1e6, '-o', 'LineWidth', 2);
    end
    
    % Add legend
    legendEntries = cell(1, length(maxWL));
    for j = 1:length(maxWL)
        legendEntries{j} = ['WL = ' num2str(maxWL(j)) ' kN/m^2'];
    end
    legend(legendEntries, 'Location', 'Best');
    
    % Show the plot
    hold off;
end



%% Grid search or Exhaustive search
clc; clearvars; 

% Defined input sheet
inputSheet_MW_scale_SE

% Changes in inputs
inputs.numDeltaLelems = 1; %[num]

% Define the range and step size for wing area and maxWL
WA_values = 80:20:140; % Wing area values
maxWL_values = 2:1:4; % Maximum wing loading values

% Initialize variables to store results
num_points_WA = length(WA_values);
num_points_maxWL = length(maxWL_values);
LCoE_values = zeros(num_points_WA, num_points_maxWL);

% Loop over each combination of wing area and maxWL
for i = 1:num_points_WA
  inputs.S = WA_values(i);
    for j = 1:num_points_maxWL
        WA = WA_values(i);
        maxWL = maxWL_values(j);
        [LCoE, processedOutputs, eco] = objectiveFunction(maxWL, WA, inputs);

        % Save outputs
        designSpace(i).systemInputs(j) = inputs;
        designSpace(i).perfOutputs(j)  = processedOutputs;
        designSpace(i).ecoOutputs(j)   = eco;
        LCoE_values(i,j)               = LCoE;
    end
end

% Find the optimal combination of maxWL and WA that minimizes the LCoE
[minLCoE, minIdx] = min(LCoE_values(:));
[optIdx_WA, optIdx_maxWL] = ind2sub(size(LCoE_values), minIdx);
optWA = WA_values(optIdx_WA);
optMaxWL = maxWL_values(optIdx_maxWL);

% Plotting
figure;
contourf(maxWL_values, WA_values, LCoE_values, 20);
colorbar;
hold on;
plot(optMaxWL, optWA, 'ro', 'MarkerSize', 10); % Plot optimal solution
xlabel('Maximum Wing Loading (maxWL) [kN/m^2]');
ylabel('Wing Area (WA) [m^2]');
title('LCoE Contour Plot');
grid on;
hold off;

% Display results
disp('Optimized Wing Area (WA) [m^2]:');
disp(optWA);

disp('Optimized Maximum Wing Loading (maxWL) [kN/m^2]:');
disp(optMaxWL);

disp('Minimum LCoE [$/MWh]:');
disp(minLCoE);

% Objective function for optimization
function [LCoE, processedOutputs, eco] = objectiveFunction(maxWL, WA, inputs)
    inputs.Ft_max = maxWL * WA;
    [~, ~, ~, processedOutputs] = main_awePower(inputs);
    inp = eco_system_inputs_Example_SE(inputs, processedOutputs);
    [~, ~, eco] = eco_main(inp);
    LCoE = eco.metrics.LCoE;
end