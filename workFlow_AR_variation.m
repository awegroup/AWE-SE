%% AR variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Add functions to path
addpath(genpath([pwd '/functions']));

% Defined input sheet
inputFile_100kW_awePower;

% Define the range for wing area
 AR_values = [10, 12, 14, 16]; % Wing area values

% Loop over each wing area value
for i = 1:length(AR_values)
  inputs.AR = AR_values(i);

  % Dependent changes in inputs
  inputs.b      = sqrt(inputs.AR * inputs.S); %[m]
  
  % Initial guess
  inputs.nx = ones(1, inputs.numDeltaLelems);
  % [deltaL, avgPattEle,  coneAngle, Rp_start, v_i, CL_i, v_o, kinematicRatio, CL]
  inputs.x0 = [200, deg2rad(30), deg2rad(5), 5 * inputs.b, ...
    inputs.v_d_max * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, ...
    0.8 * inputs.nx, 90 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];
  % Bounds
  inputs.lb = [50, deg2rad(1), deg2rad(1), 5 * inputs.b, 1 * inputs.nx, 0.1 * inputs.nx, ...
    0.8 * inputs.nx, 1 * inputs.nx, 0.1 * inputs.nx];
  inputs.ub = [500, deg2rad(90), deg2rad(60), 10*inputs.b, inputs.v_d_max * inputs.nx, ...
    inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, inputs.v_d_max * inputs.nx, ...
    200 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];

  % Save parameter values
  designSpace_AR_var(i).paramValue   = AR_values(i);

  % Evaluate design objective
  [designSpace_AR_var(i).systemInputs, designSpace_AR_var(i).perfOutputs, designSpace_AR_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_AR_var.mat','designSpace_AR_var');

%% Plots
% Load saved results
load("outputFiles/designSpace_AR_var.mat");

% Plot
plotResults_single_param_variation('AR', '', designSpace_AR_var);


