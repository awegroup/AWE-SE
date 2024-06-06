%% AWE-Power and AWE-Eco coupling test

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:\PhD\GitHubRepo\AWE-Power\src'));
addpath(genpath('C:\PhD\GitHubRepo\AWE-Eco\src'));

% Add inputFiles to path
addpath(genpath([pwd '\inputFiles']));

% Run AWE-Power
% Load defined input sheet
inputSheet_MW_scale_SE

inputs.numDeltaLelems  = 1;
inputs.S               = 70;
inputs.Ft_max          = 3*inputs.S; %[kN]
% Get results
[inputs, outputs, optimDetails, processedOutputs] = main_awePower(inputs);

% Plot results
% plotResults_awePower(inputs, processedOutputs);

% Run AWE-Eco

% Import inputs
inp = eco_system_inputs_Example_SE(inputs, processedOutputs);

% Run EcoModel by parsing the inputs
[inp,par,eco] = eco_main(inp);

% Display results
eco_displayResults(eco)




























