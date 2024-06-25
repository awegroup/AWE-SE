%% Ft_max variation

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

% Define the range for Ft_max
Ft_guess  = 4*mean(inputs.S)*1000; % N
Ft_max_values = [Ft_guess*0.5, Ft_guess*0.75, Ft_guess, Ft_guess*1.25, Ft_guess*1.5]; % N

% Loop over each Ft_max value
for i = 1:length(Ft_max_values)
  inputs.Ft_max = Ft_max_values(i);

  % Save parameter values
  designSpace_Ft_max_var(i).paramValue   = Ft_max_values(i);

  % Evaluate design objective
  [designSpace_Ft_max_var(i).systemInputs, designSpace_Ft_max_var(i).perfOutputs, designSpace_Ft_max_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_Ft_max_var.mat','designSpace_Ft_max_var');

%% Plots

% Load saved results
load("outputFiles/designSpace_Ft_max_var.mat");

% Plot
plotResults_single_param_variation('F_{t,max}', 'N', designSpace_Ft_max_var);

