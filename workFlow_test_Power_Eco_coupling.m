%% AWE-Power and AWE-Eco coupling test

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Run AWE-Power
% Load defined input file
%inputFile_example_SE;
inputFile_100kW_awePower;
% inputFile_1MW_awePower;

% Get results
[outputs, optimDetails, processedOutputs] = main_awePower(inputs);

% Plot results
% plotResults_awePower(inputs);

% Run AWE-Eco
% Import inputs
inp = eco_system_inputs_awePower(inputs, processedOutputs);

% Run EcoModel by parsing the inputs
[inp,par,eco] = eco_main(inp);

% Display results
eco_displayResults(inp,eco)




























