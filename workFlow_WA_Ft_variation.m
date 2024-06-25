%% Wing area and wing loading variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath('C:/PhD/GitHubRepo/AWE-Eco/src'));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

%% Grid search or Exhaustive search
clc; clearvars; 

% Defined input sheet
inputFile_100kW_awePower;

% Define the range and step size for wing area and maxWL
WA_values = [15, 20, 25]; % Wing area values
Ft_guess  = 3*mean(WA_values)*1000; % N
Ft_values = [Ft_guess*0.5, Ft_guess, Ft_guess*1.5]; % Maximum wing loading values

% WA_values = [20, 25]; % Wing area values
% Ft_values = [75]; % Maximum tether force % N

% Initialize variables to store results
num_points_WA = length(WA_values);
num_points_maxFt = length(Ft_values);
LCoE_values = zeros(num_points_WA, num_points_maxFt);

% Loop over each combination of wing area and maxWL
for i = 1:num_points_WA
  inputs.S = WA_values(i);
  inputs.b = sqrt(inputs.AR*inputs.S); %[m]
  
  % Initial guess
  inputs.nx = ones(1,inputs.numDeltaLelems);
  %               [deltaL, avgPattEle,  coneAngle,     Rp_start, v_i,                      CL_i,                                           v_o,           kinematicRatio,         CL]
  inputs.x0     = [200,    deg2rad(30), deg2rad(5),    5*inputs.b,       inputs.v_d_max*inputs.nx, inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx, 0.8*inputs.nx, 90*inputs.nx,           inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx];
  
  % Bounds
  inputs.lb     = [50,   deg2rad(1),  deg2rad(1),  5*inputs.b,  1*inputs.nx, 0.1*inputs.nx, 0.8*inputs.nx, 1*inputs.nx, 0.1*inputs.nx]; % 
  inputs.ub     = [500,  deg2rad(90), deg2rad(60), 10*inputs.b, inputs.v_d_max*inputs.nx, inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx,...
      inputs.v_d_max*inputs.nx,  200*inputs.nx, inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx]; 

    for j = 1:num_points_maxFt
        WA = WA_values(i);
        maxFt = Ft_values(j);
        [LCoE, processedOutputs, eco] = objectiveFunction(maxFt, inputs);

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
optMaxFt = Ft_values(optIdx_maxWL);

%% Plots

% Display optimal design
disp('Optimized Wing Area (WA) [m^2]:');
disp(optWA);

disp('Optimized Maximum Tether Force (F_{t,max}) [N]:');
disp(optMaxFt);

disp('Minimum LCoE [€/MWh]:');
disp(minLCoE);


% Plotting power curves for each wing area in separate plots
for i = 1:length(WA_values)
    % Initialize the figure
    figure;
    hold on;
    grid on;
    xlabel('Wind speed at 100m height [m/s]');
    ylabel('Average Power Output [MW]');
    title(['Power Curve for WA = ' num2str(WA_values(i)) ' m^2']);
    
    % Loop through each wing loading (WL) for the current wing area
    for j = 1:length(Ft_values)
        % Extract power curve data
        avg_power_output = designSpace(i).perfOutputs(j).P_e_avg;
        
        % Plot power curve
        plot(avg_power_output / 1e6, '-o', 'LineWidth', 2);
    end
    
    % Add legend
    legendEntries = cell(1, length(Ft_values));
    for j = 1:length(Ft_values)
        legendEntries{j} = ['F_{t,max} = ' num2str(Ft_values(j)) ' N'];
    end
    legend(legendEntries, 'Location', 'Best');
    
    % Show the plot
    hold off;
end

% Plotting LCoE vs Wing Area for different tether forces
figure;
hold on;
grid on;
xlabel('Wing Area (WA) [m^2]');
ylabel('Levelized Cost of Energy (LCoE) [€/MWh]');
title('LCoE vs Wing Area for tether forces');
% Define legend entries
legendEntries = cell(1, length(Ft_values));
% Loop through each tether force
for j = 1:length(Ft_values)
    LCoE_values_plot = [];
    % Loop through each Wing Area (WA)
    for i = 1:length(WA_values)
        LCoE_values_plot(i) = LCoE_values(i, j);
    end
    % Plot LCoE for the current WL
    plot(WA_values, LCoE_values_plot, '-o', 'LineWidth', 2);
    
    % Store legend entry for the current tether force
    legendEntries{j} = ['F_{t,max} = ' num2str(Ft_values(j)) ' N'];
end
% Add legend to the plot
legend(legendEntries, 'Location', 'Best');
hold off;


% Plotting AEP vs Wing Area for different tether forces
figure;
hold on;
grid on;
xlabel('Wing Area (WA) [m^2]');
ylabel('AEP [MWh]');
title('AEP vs Wing Area for different tether forces');
% Define legend entries
legendEntries = cell(1, length(Ft_values));
% Loop through each tether force
for j = 1:length(Ft_values)
    AEP_values_plot  = [];
    % Loop through each Wing Area (WA)
    for i = 1:length(WA_values)
        AEP_values_plot(i)  = designSpace(i).ecoOutputs(j).metrics.AEP; % MWh  
    end
    % Plot LCoE for the current tether force
    plot(WA_values, AEP_values_plot, '-o', 'LineWidth', 2);
    % Store legend entry for the current WL
    legendEntries{j} = ['F_{t,max} = ' num2str(Ft_values(j)) ' N'];
end
% Add legend to the plot
legend(legendEntries, 'Location', 'Best');
hold off;

% Plotting ICC vs Wing Area for different tether forces
figure;
hold on;
grid on;
xlabel('Wing Area (WA) [m^2]');
ylabel('ICC [€]');
title('ICC vs Wing Area for different tether forces');
% Define legend entries
legendEntries = cell(1, length(Ft_values));
% Loop through each tether force
for j = 1:length(Ft_values)
    ICC_values_plot  = [];
    % Loop through each Wing Area (WA)
    for i = 1:length(WA_values)
        ICC_values_plot(i)  = designSpace(i).ecoOutputs(j).metrics.ICC; % € 
    end
    % Plot LCoE for the current tether force
    plot(WA_values, ICC_values_plot, '-o', 'LineWidth', 2);
    % Store legend entry for the current WL
    legendEntries{j} = ['F_{t,max} = ' num2str(Ft_values(j)) ' N'];
end
% Add legend to the plot
legend(legendEntries, 'Location', 'Best');
hold off;

% Plotting OMC vs Wing Area for different tether forces
figure;
hold on;
grid on;
xlabel('Wing Area (WA) [m^2]');
ylabel('OMC [€]');
title('OMC vs Wing Area for different tether forces');
% Define legend entries
legendEntries = cell(1, length(Ft_values));
% Loop through each tether force
for j = 1:length(Ft_values)
    OMC_values_plot  = [];
    % Loop through each Wing Area (WA)
    for i = 1:length(WA_values)
        OMC_values_plot(i)  = designSpace(i).ecoOutputs(j).metrics.OMC; % € 
    end
    % Plot LCoE for the current tether force
    plot(WA_values, OMC_values_plot, '-o', 'LineWidth', 2);
    % Store legend entry for the current WL
    legendEntries{j} = ['F_{t,max} = ' num2str(Ft_values(j)) ' N'];
end
% Add legend to the plot
legend(legendEntries, 'Location', 'Best');
hold off;


% Contour Plot
figure;
contourf(Ft_values, WA_values, LCoE_values, 20);
colorbar;
hold on;
plot(optMaxFt, optWA, 'ro', 'MarkerSize', 10); % Plot optimal solution
xlabel('Maximum Tether force (F_{t,max}) [N]');
ylabel('Wing Area (WA) [m^2]');
title('LCoE Contour Plot');
grid on;
hold off;

% Objective function for optimization
function [LCoE, processedOutputs, eco] = objectiveFunction(maxFt, inputs)
    inputs.Ft_max = maxFt;
    [~, ~, processedOutputs] = main_awePower(inputs);
    inp = eco_system_inputs_awePower(inputs, processedOutputs);
    [~, ~, eco] = eco_main(inp);
    LCoE = eco.metrics.LCoE;
end