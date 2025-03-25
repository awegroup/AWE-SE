%% Example script demonstrating AWE-Power and AWE-Eco coupling
clc; clearvars;

% Add AWE-Power and AWE-Eco to path
addpath(genpath([pwd '/AWE-Power']));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles folder to path
addpath(genpath([pwd '/inputFiles']));

% Add inputFiles folder to path
addpath(genpath([pwd '/outputFiles']));

%% Run AWE-Power
% Load defined input file
inputs = loadInputs('inputFile_500kW_example.yml');

% Run AWE-Power
[inputs, outputs, optimDetails, processedOutputs] = main_awePower(inputs);

% Plot AWE-Power results
plotResults(inputs);

%% Run AWE-Eco
% Initialise inputs
inp = eco_system_inputs_awePower(inputs, processedOutputs);

% Run AWE-Eco by parsing the inputs
[inp,par,eco] = eco_main(inp);

% Plot AWE-Eco results
eco_displayResults(inp,eco)




























