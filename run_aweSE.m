%% AWE-SE
% A systems engineering tool-chain for airborne wind energy systems

clc; clearvars; clear global

%% Add AWE-Power and AWE-Eco to path
addpath(genpath('C:\PhD\GitHubRepo\AWE-Power'));
addpath(genpath('C:\PhD\GitHubRepo\AWE-Eco'));

%% Add inputFiles to path
addpath(genpath([pwd '\inputFiles']));

%% Run AWE-Power

% Load defined input sheet
% inputSheet_MW_scale_EcoModel;
inputSheet_Example;

[inputs, outputs, optimDetails, processedOutputs] = main_awePower(inputs);

%% Run AWE-Eco

% Import inputs
inp = eco_system_inputs_MW_scale(inputs, processedOutputs);

% Run EcoModel by parsing the inputs
[inp,par,eco] = eco_main(inp);

% Display results
eco_displayResults(eco)


