% Design space exploration: Scaling

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/lib'));
addpath(genpath([pwd '/AWE-Eco']));

% Add folders to path
addpath(genpath([pwd '/inputFiles']));
addpath(genpath([pwd '/outputFiles']));
addpath(genpath([pwd '/src']));

%% Wing area and P_rated variation

clearvars

% Load input file
inputs = loadInputs('inputFile_500kW_awePower.yml');

% Define the range for wing area and aspect ratio
WA_values      = [25, 50, 75, 100, 125, 150, 175, 200]; % m^2
P_rated_values = [100e3, 500e3, 1000e3, 1500e3, 2000e3, 2500e3]; % W

% Evaluate design space
[designSpace_WA_P_rated_var] = wingArea_P_rated_variation(WA_values, P_rated_values, inputs);

% Save design space results
save('outPutFiles/designSpace_WA_P_rated_var.mat','designSpace_WA_P_rated_var');

% Load the saved design space results
load('outPutFiles/designSpace_WA_P_rated_var.mat');

% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'P_{rated}','W', designSpace_WA_P_rated_var)

%% WA and f_crest variation: 500kW

clearvars

% Load input file
inputs = loadInputs('inputFile_500kW_awePower.yml');

% Define the range for wing area and aspect ratio
WA_values          = [40, 50, 60, 70]; % m^2
crestFactor_values = [1, 1.5, 2, 2.5, 3]; % -

% Evaluate design space
[designSpace_WA_crestFactor_var] = wingArea_crestFactor_variation(WA_values, crestFactor_values, inputs);

% Save design space results
save('outPutFiles/designSpace_WA_crestFactor_var.mat','designSpace_WA_crestFactor_var');

% Load the saved design space results
load('outPutFiles/designSpace_WA_crestFactor_var.mat');

% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_WA_crestFactor_var)
