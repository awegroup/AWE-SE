%% sigma_t_max variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));
% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Add functions to path
addpath(genpath([pwd '/src']));

% Defined input sheet
inputFile_100kW_awePower;

% Define the range for sigma_t_max
sigma_t_max_values = [4e8, 5e8, 6e8, 7e8]; % Pa

% Loop over each sigma_t_max value
for i = 1:length(sigma_t_max_values)
  inputs.Te_matStrength = sigma_t_max_values(i);

  % Save parameter values
  designSpace_sigma_t_max_var(i).paramValue   = sigma_t_max_values(i);

  % Evaluate design objective
  [designSpace_sigma_t_max_var(i).systemInputs, designSpace_sigma_t_max_var(i).perfOutputs, designSpace_sigma_t_max_var(i).ecoInputs, designSpace_sigma_t_max_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_sigma_t_max_var.mat','designSpace_sigma_t_max_var');

%% Plots

% Load saved results
load("outputFiles/designSpace_sigma_t_max_var.mat");

% Plot
plotResults_single_param_variation('σ_{t,max}', 'Pa', designSpace_sigma_t_max_var);

