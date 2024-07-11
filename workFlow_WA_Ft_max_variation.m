%% WA and Ft_max variation

clc;
clearvars;

% Add the source code folders and necessary paths
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));
addpath(genpath([pwd '/inputFiles']));
addpath(genpath([pwd '/src']));

% Load input file (adjust as needed)
inputFile_100kW_awePower;
% inputFile_1MW_awePower;

% Define range for wing area and Ft_max
WA_values = [15, 20]; % Wing area values (m^2)

% Calculate Ft_max_values based on WA_values
Ft_guess = 4*mean(WA_values)*1000; % N
Ft_max_values = [Ft_guess*0.8, Ft_guess,Ft_guess*1.2]; % Range for Ft_max

% Initialize structure array to store design space results
designSpace_WA_Ft_var = struct([]);

% Initialize counter for storing results
counter = 1;

% Loop over each wing area value
for i = 1:length(WA_values)
  % Loop over each Ft_max value
  for j = 1:length(Ft_max_values)

    % Set wing area and Ft_max
    inputs.S = WA_values(i); % Wing area (m^2)
    inputs.Ft_max = Ft_max_values(j); % Maximum thrust (N)

    % Dependent changes in inputs
    inputs.b = sqrt(inputs.AR * inputs.S);

    % Initial guess (example values)
    inputs.nx = ones(1, inputs.numDeltaLelems);
    inputs.x0 = [200, deg2rad(30), deg2rad(5), 5 * sqrt(inputs.AR * inputs.S), ...
      inputs.v_d_max * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, ...
      0.8 * inputs.nx, 90 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];
    inputs.lb = [50, deg2rad(1), deg2rad(1), 5 * sqrt(inputs.AR * inputs.S), 1 * inputs.nx, 0.1 * inputs.nx, ...
      0.8 * inputs.nx, 1 * inputs.nx, 0.1 * inputs.nx];
    inputs.ub = [500, deg2rad(90), deg2rad(60), 10 * sqrt(inputs.AR * inputs.S), inputs.v_d_max * inputs.nx, ...
      inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, inputs.v_d_max * inputs.nx, ...
      200 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];

    % Save parameter values
    designSpace_WA_Ft_var(counter).S_value = inputs.S;
    designSpace_WA_Ft_var(counter).Ft_max_value = inputs.Ft_max;

    % Evaluate design objective
    [designSpace_WA_Ft_var(counter).systemInputs, designSpace_WA_Ft_var(counter).perfOutputs, ...
      designSpace_WA_Ft_var(counter).ecoInputs, designSpace_WA_Ft_var(counter).ecoOutputs] = evalDesignObjective(inputs);

    % Increment counter
    counter = counter + 1;
  end
end

% Save design space results
save('outPutFiles/designSpace_WA_Ft_var.mat', 'designSpace_WA_Ft_var');

%% Plotting Results

% Load saved design space results
load('outPutFiles/designSpace_WA_Ft_var.mat');

% Plot results using the plotting function
plotResults_two_param_variation('WA', 'm^2', 'F_{t,max}', 'N', designSpace_WA_Ft_var);

