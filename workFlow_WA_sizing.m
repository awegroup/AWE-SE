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

% Define the range for wing area
WA_values = [10, 15, 20, 25, 30]; % Wing area values

% Initialize variables to store results
num_points_WA = length(WA_values);
LCoE_values = zeros(num_points_WA, 1);

% Loop over each wing area value
for i = 1:num_points_WA
  inputs.S = WA_values(i);

  % Dependent changes in inputs
  inputs.b      = sqrt(inputs.AR * inputs.S); %[m]
  inputs.Ft_max = 2*inputs.S*1000; %[N]
  % Initial guess
  inputs.nx = ones(1, inputs.numDeltaLelems);
  % [deltaL, avgPattEle,  coneAngle, Rp_start, v_i, CL_i, v_o, kinematicRatio, CL]
  inputs.x0 = [200, deg2rad(30), deg2rad(5), 5 * inputs.b, ...
    inputs.v_d_max * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, ...
    0.8 * inputs.nx, 90 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];
  % Bounds
  inputs.lb = [50, deg2rad(1), deg2rad(1), 5 * inputs.b, 1 * inputs.nx, 0.1 * inputs.nx, ...
    0.8 * inputs.nx, 1 * inputs.nx, 0.1 * inputs.nx];
  inputs.ub = [500, deg2rad(90), deg2rad(60), 100, inputs.v_d_max * inputs.nx, ...
    inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, inputs.v_d_max * inputs.nx, ...
    200 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];

  % AWE-Power
  [~, ~, designSpace(i).perfOutputs] = main_awePower(inputs);

  % AWE-Eco
  eco_inputs = eco_system_inputs_awePower(inputs, designSpace(i).perfOutputs);
  [~, ~, designSpace(i).ecoOutputs] = eco_main(eco_inputs);

  % Extract LCoEs
  LCoE_values(i) = designSpace(i).ecoOutputs.metrics.LCoE;

  % Save inputs
  designSpace(i).systemInputs = inputs;
end

% Find the optimal wing area that minimizes the LCoE
[minLCoE, optIdx_WA] = min(LCoE_values);
optWA = WA_values(optIdx_WA);

%% Plots
% Plotting power curves for each wing area
figure;
hold on;
grid on;
xlabel('Wind Speed [m/s]');
ylabel('Average Power Output [MW]');
title('Power Curves');

% Initialize legend entries cell array
legend_entries = cell(length(WA_values), 1);

for i = 1:length(WA_values)
    % Extract power curve data
    avg_power_output = designSpace(i).perfOutputs.P_e_avg;

    % Plot power curve
    plot(avg_power_output / 1e6, '-o', 'LineWidth', 2);

    % Construct legend entry for this wing area
    legend_entries{i} = ['WA = ' num2str(WA_values(i)) ' m^2'];
end

% Add legend with all entries
legend(legend_entries, 'Location', 'Best');
hold off;

% Plotting LCoE vs Wing Area
figure;
hold on;
grid on;
xlabel('Wing Area (WA) [m^2]');
ylabel('Levelized Cost of Energy (LCoE) [$/MWh]');
title('LCoE vs Wing Area');

% Plot LCoE for each wing area
plot(WA_values, LCoE_values, '-o', 'LineWidth', 2);

% Add legend to the plot
legend('LCoE', 'Location', 'Best');
hold off;

% Display results
disp('Optimized Wing Area (WA) [m^2]:');
disp(optWA);

disp('Minimum LCoE [$/MWh]:');
disp(minLCoE);


