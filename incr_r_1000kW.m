%% Design space exploraton: 1000 kW Increased r

% Change r to 0.15

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
inputs = loadInputs('inputFile_1000kW_baseCase.yml');

% Define range for wing area 
WA_values = [80, 90, 100]; % m^2

% Define range for wing loading
WL_values = [3e3, 4e3, 5e3]; % N/m^2

% Evaluate design space
[designSpace_1000kW_WA_WL_var] = wingArea_wingLoading_variation(WA_values, WL_values, inputs);

% Save design space results
save('outPutFiles/designSpace_1000kW_WA_WL_var_incr_r.mat', 'designSpace_1000kW_WA_WL_var');

% Load saved design space results
load('outPutFiles/designSpace_1000kW_WA_WL_var_incr_r.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_1000kW_WA_WL_var);

%% Wing loading and sigma_t_max var
clearvars

% Load input file
inputs = loadInputs('inputFile_1000kW_baseCase.yml');

% Define range for wing loading
WL_values = [3e3, 4e3, 5e3]; % N/m^2

% Define the range for sigma_t_max
sigma_t_max_values = [3e8, 4e8, 5e8]; % Pa

[designSpace_1000kW_WL_sigma_t_var] = wingLoading_sigma_t_max_variation(WL_values, sigma_t_max_values, inputs);

% Save design space results
save('outPutFiles/designSpace_1000kW_WL_sigma_t_var_incr_r.mat','designSpace_1000kW_WL_sigma_t_var');

% Load the saved design space results
load('outPutFiles/designSpace_1000kW_WL_sigma_t_var_incr_r.mat');

% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_1000kW_WL_sigma_t_var)

%% Wing area an aspect ratio variation 
clearvars

% Load input file
inputs = loadInputs('inputFile_1000kW_baseCase.yml');

% Fixed WL
WL_max = 4e3;

% Define the range for wing area and aspect ratio
WA_values = [80, 90, 100]; % m^2
AR_values = [12, 14, 16]; % -

% Evaluate design space
[designSpace_1000kW_WA_AR_var] = wingArea_aspectRatio_variation(WA_values, AR_values, inputs, WL_max);

% Save design space results
save('outPutFiles/designSpace_1000kW_WA_AR_var_incr_r.mat','designSpace_1000kW_WA_AR_var');

% Load the saved design space results
load('outPutFiles/designSpace_1000kW_WA_AR_var_incr_r.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_1000kW_WA_AR_var)

%% WA and f_crest variation
clearvars

% Load input file
inputs = loadInputs('inputFile_1000kW_baseCase.yml');

% Define the range for wing area and aspect ratio
WA_values          = [80, 90, 100]; % m^2
crestFactor_values = [1.5, 2, 2.5]; % -

% Fixed WL
WL_max = 4e3;

% Evaluate design space
[designSpace_1000kW_WA_crestFactor_var] = wingArea_crestFactor_variation(WA_values, crestFactor_values, inputs, WL_max);

% Save design space results
save('outPutFiles/designSpace_1000kW_WA_crestFactor_var_incr_r.mat','designSpace_1000kW_WA_crestFactor_var');

% Load the saved design space results
load('outPutFiles/designSpace_1000kW_WA_crestFactor_var_incr_r.mat');

% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_1000kW_WA_crestFactor_var)

%% Reference 1 MW system design
clearvars
perfInputs = loadInputs('inputFile_1000kW_baseCase.yml');

[perfInputs, perfOutputs, ecoInputs, ecoOutputs] = evalDesignObjective(perfInputs);

systemData_1000kW.perfInputs  = perfInputs;
systemData_1000kW.perfOutputs = perfOutputs;
systemData_1000kW.ecoInputs   = ecoInputs;
systemData_1000kW.ecoOutputs  = ecoOutputs;
save('outputFiles/systemData_1000kW_incr_r.mat');

%% Plot results

load('outputFiles/systemData_1000kW_incr_r.mat');

figure('units','inch','Position', [8.2 0.5 3.5 2.2])
hold on
grid on
box on
plot(systemData_1000kW.perfInputs.vw_ref(1):systemData_1000kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_1000kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
xlabel('Wind speed at 100 m (m/s)');
ylabel('Power (kW)');
hold off

% Eco results
eco_displayResults_mod_SE(systemData_1000kW.ecoInputs, systemData_1000kW.ecoOutputs)

%% Plotting saved results

% Load saved design space results
load('outPutFiles/designSpace_1000kW_WA_WL_var_incr_r.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_1000kW_WA_WL_var);

% Load the saved design space results
load('outPutFiles/designSpace_1000kW_WL_sigma_t_var_incr_r.mat');
% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_1000kW_WL_sigma_t_var)

% Load the saved design space results
load('outPutFiles/designSpace_1000kW_WA_AR_var_incr_r.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_1000kW_WA_AR_var)

% Load the saved design space results
load('outPutFiles/designSpace_1000kW_WA_crestFactor_var_incr_r.mat');
% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_1000kW_WA_crestFactor_var)

% %% Crest factor and System rated power variation 
% clearvars
% 
% % Load input file
% inputs = loadInputs('inputFile_1000kW_baseCase.yml');
% 
% % Define the range for wing area and aspect ratio
% crestFactor_values = [1, 1.5, 2, 2.5, 3]; % -
% P_rated_values   = [750e3, 1000e3, 1250e3]; % W
% 
% % Evaluate design space
% [designSpace_1000kW_crestFactor_P_rated_var] = crestFactor_P_rated_variation(crestFactor_values, P_rated_values, inputs);
% 
% % Save design space results
% save('outPutFiles/designSpace_1000kW_crestFactor_P_rated_var_baseCase.mat','designSpace_1000kW_crestFactor_P_rated_var');
% 
% % Load the saved design space results
% load('outPutFiles/designSpace_1000kW_crestFactor_P_rated_var_baseCase.mat');
% 
% % Plot
% plotResults_two_param_variation('crestFactor', '-', 'P_{rated}','W', designSpace_1000kW_crestFactor_P_rated_var)

