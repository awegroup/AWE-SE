%% P_gen variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath('C:/PhD/GitHubRepo/AWE-Eco/src'));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Add functions to path
addpath(genpath([pwd '/functions']));

% Defined input sheet
inputFile_100kW_awePower;

% Define the range for P_gen
P_gen_values = [100, 150, 200, 250, 300]; % kW

% Loop over each sigma_t_max value
for i = 1:length(P_gen_values)
  inputs.peakM2E_F = P_gen_values(i)/inputs.P_ratedElec*1000;

  % Save parameter values
  designSpace_P_gen_var(i).paramValue   = P_gen_values(i);

  % Evaluate design objective
  [designSpace_P_gen_var(i).systemInputs, designSpace_P_gen_var(i).perfOutputs, designSpace_P_gen_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_P_gen_var.mat','designSpace_P_gen_var');

%% Plots
% Load saved results
load("outputFiles/designSpace_P_gen_var.mat");

% Plot
plotResults_single_param_variation('P_{gen}', 'kW', designSpace_P_gen_var);


