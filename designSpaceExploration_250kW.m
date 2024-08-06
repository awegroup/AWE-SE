%% 250 kW system
clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/lib'));
addpath(genpath([pwd '/AWE-Eco']));

% Add folders to path
addpath(genpath([pwd '/inputFiles']));
addpath(genpath([pwd '/outputFiles']));
addpath(genpath([pwd '/src']));

%% Wing area and wing loading variation
clearvars

% Load input file
inputs = loadInputs('inputFile_250kW_awePower.yml');

% Define range for wing area 
WA_values = [30, 40, 50]; % m^2

% Define range for wing loading
WL_values = [2e3, 3e3, 4e3]; % N/m^2

% Evaluate design space
[designSpace_250kW_WA_WL_var] = wingArea_wingLoading_variation(WA_values, WL_values, inputs);

% Save design space results
save('outPutFiles/designSpace_250kW_WA_WL_var.mat', 'designSpace_250kW_WA_WL_var');

% Load saved design space results
load('outPutFiles/designSpace_250kW_WA_WL_var.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_250kW_WA_WL_var);

%% Wing loading and sigma_t_max var
clearvars

% Load input file
inputs = loadInputs('inputFile_250kW_awePower.yml');

% Define range for wing loading
WL_values = [2e3, 3e3, 4e3]; % N/m^2

% Define the range for sigma_t_max
sigma_t_max_values = [3e8, 4e8, 5e8]; % Pa

[designSpace_250kW_WL_sigma_t_var] = wingLoading_sigma_t_max_variation(WL_values, sigma_t_max_values, inputs);

% Save design space results
save('outPutFiles/designSpace_250kW_WL_sigma_t_var.mat','designSpace_250kW_WL_sigma_t_var');

% Load the saved design space results
load('outPutFiles/designSpace_250kW_WL_sigma_t_var.mat');

% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_250kW_WL_sigma_t_var)

%% Wing area an aspect ratio variation 
clearvars

% Load input file
inputs = loadInputs('inputFile_250kW_awePower.yml');

% Define the range for wing area and aspect ratio
WA_values = [30, 40, 50]; % m^2
AR_values = [10, 12, 14, 16]; % -

% Evaluate design space
[designSpace_250kW_WA_AR_var] = wingArea_aspectRatio_variation(WA_values, AR_values, inputs);

% Save design space results
save('outPutFiles/designSpace_250kW_WA_AR_var.mat','designSpace_250kW_WA_AR_var');

% Load the saved design space results
load('outPutFiles/designSpace_250kW_WA_AR_var.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_250kW_WA_AR_var)

%% Crest factor and System rated power variation 
clearvars

% Load input file
inputs = loadInputs('inputFile_250kW_awePower.yml');

% Define the range for wing area and aspect ratio
crestFactor_values = [1, 1.5, 2, 2.5]; % -
P_rated_values   = [150e3, 250e3, 350e3]; % W

% Evaluate design space
[designSpace_250kW_crestFactor_P_rated_var] = crestFactor_P_rated_variation(crestFactor_values, P_rated_values, inputs);

% Save design space results
save('outPutFiles/designSpace_250kW_crestFactor_P_rated_var.mat','designSpace_250kW_crestFactor_P_rated_var');

% Load the saved design space results
load('outPutFiles/designSpace_250kW_crestFactor_P_rated_var.mat');

% Plot
plotResults_two_param_variation('crestFactor', '-', 'P_{rated}','W', designSpace_250kW_crestFactor_P_rated_var)

%% Plotting saved results

% Load saved design space results
load('outPutFiles/designSpace_250kW_WA_WL_var.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_250kW_WA_WL_var);

% Load the saved design space results
load('outPutFiles/designSpace_250kW_WL_sigma_t_var.mat');
% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_250kW_WL_sigma_t_var)

% Load the saved design space results
load('outPutFiles/designSpace_250kW_WA_AR_var.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_250kW_WA_AR_var)

% Load the saved design space results
load('outPutFiles/designSpace_250kW_crestFactor_P_rated_var.mat');
% Plot
plotResults_two_param_variation('crestFactor', '-', 'P_{rated}','W', designSpace_250kW_crestFactor_P_rated_var)

%% Reference 250 kW system design
clearvars
perfInputs = loadInputs('inputFile_250kW_awePower.yml');

[perfInputs, perfOutputs, ecoInputs, ecoOutputs] = evalDesignObjective(perfInputs);

systemData_250kW.perfInputs  = perfInputs;
systemData_250kW.perfOutputs = perfOutputs;
systemData_250kW.ecoInputs   = ecoInputs;
systemData_250kW.ecoOutputs  = ecoOutputs;
save('outputFiles/systemData_250kW.mat');

% Power curve
figure()
hold on
grid on
box on
plot(perfOutputs.P_e_avg,'-x');
hold off

% Eco results
eco_displayResults(ecoInputs, ecoOutputs)


