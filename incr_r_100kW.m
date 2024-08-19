%% Design space exploraton: 100 kW: Increased r

% r is set to 0.15

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
inputs = loadInputs('inputFile_100kW_baseCase.yml');

% Define range for wing area 
WA_values = [10, 20, 30]; % m^2

% Define range for wing loading
WL_values = [1e3, 2e3, 3e3]; % N/m^2

% Evaluate design space
[designSpace_100kW_WA_WL_var] = wingArea_wingLoading_variation(WA_values, WL_values, inputs);

% Save design space results
save('outPutFiles/designSpace_100kW_WA_WL_var_incr_r.mat', 'designSpace_100kW_WA_WL_var');

% Load saved design space results
load('outPutFiles/designSpace_100kW_WA_WL_var_incr_r.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_100kW_WA_WL_var);

%% Wing loading and sigma_t_max var
clearvars

% Load input file
inputs = loadInputs('inputFile_100kW_baseCase.yml');

% Define range for wing loading
WL_values = [1e3, 2e3, 3e3]; % N/m^2

% Define the range for sigma_t_max
sigma_t_max_values = [2e8, 3e8, 4e8]; % Pa

[designSpace_100kW_WL_sigma_t_var] = wingLoading_sigma_t_max_variation(WL_values, sigma_t_max_values, inputs);

% Save design space results
save('outPutFiles/designSpace_100kW_WL_sigma_t_var_incr_r.mat','designSpace_100kW_WL_sigma_t_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WL_sigma_t_var_incr_r.mat');

% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_100kW_WL_sigma_t_var)

%% Wing area an aspect ratio variation 
clearvars

% Load input file
inputs = loadInputs('inputFile_100kW_baseCase.yml');

% Fixed WL
WL_max = 2e3;

% Define the range for wing area and aspect ratio
WA_values = [10, 20, 30]; % m^2
AR_values = [12, 14, 16]; % -

% Evaluate design space
[designSpace_100kW_WA_AR_var] = wingArea_aspectRatio_variation(WA_values, AR_values, inputs, WL_max);

% Save design space results
save('outPutFiles/designSpace_100kW_WA_AR_var_incr_r.mat','designSpace_100kW_WA_AR_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_AR_var_incr_r.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_100kW_WA_AR_var)

%% WA and f_crest variation
clearvars

% Load input file
inputs = loadInputs('inputFile_100kW_baseCase.yml');

% Define the range for wing area and aspect ratio
WA_values          = [10, 20, 30]; % m^2
crestFactor_values = [1.5, 2, 2.5]; % -

% Fixed WL
WL_max = 2e3;

% Evaluate design space
[designSpace_100kW_WA_crestFactor_var] = wingArea_crestFactor_variation(WA_values, crestFactor_values, inputs, WL_max);

% Save design space results
save('outPutFiles/designSpace_100kW_WA_crestFactor_var_incr_r.mat','designSpace_100kW_WA_crestFactor_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_crestFactor_var_incr_r.mat');

% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_100kW_WA_crestFactor_var)

%% Reference 100 kW system design
clearvars

perfInputs = loadInputs('inputFile_100kW_baseCase.yml');

[perfInputs, perfOutputs, ecoInputs, ecoOutputs] = evalDesignObjective(perfInputs);

systemData_100kW.perfInputs  = perfInputs;
systemData_100kW.perfOutputs = perfOutputs;
systemData_100kW.ecoInputs   = ecoInputs;
systemData_100kW.ecoOutputs  = ecoOutputs;

save('outputFiles/systemData_100kW_incr_r.mat');

%% Plot results

load('outputFiles/systemData_100kW_incr_r.mat');

figure('units','inch','Position', [8.2 0.5 3.5 2.2])
hold on
grid on
box on
plot(systemData_100kW.perfInputs.vw_ref(1):systemData_100kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_100kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
xlabel('Wind speed at 100 m (m/s)');
ylabel('Power (kW)');
hold off

% Eco results
eco_displayResults_mod_SE(systemData_100kW.ecoInputs, systemData_100kW.ecoOutputs)

%% All plots

% Load saved design space results
load('outPutFiles/designSpace_100kW_WA_WL_var_incr_r.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_100kW_WA_WL_var);

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WL_sigma_t_var_incr_r.mat');
% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_100kW_WL_sigma_t_var);

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_AR_var_incr_r.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_100kW_WA_AR_var)

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_crestFactor_var_incr_r.mat');
% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_100kW_WA_crestFactor_var)