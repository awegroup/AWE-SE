%% Design space exploraton: 500 kW 0 Wind Shear and 10m/s wind speed

% Change alpha to 0 and v_w,mean to 10

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
inputs = loadInputs('inputFile_500kW_high_wind_0_shear.yml');

% Define range for wing area 
WA_values = [50, 60, 70]; % m^2

% Define range for wing loading
WL_values = [2e3, 3e3, 4e3]; % N/m^2

% Evaluate design space
[designSpace_500kW_WA_WL_var] = wingArea_wingLoading_variation(WA_values, WL_values, inputs);

% Save design space results
save('outPutFiles/designSpace_500kW_WA_WL_var_high_wind_0_shear.mat', 'designSpace_500kW_WA_WL_var');

% Load saved design space results
load('outPutFiles/designSpace_500kW_WA_WL_var_high_wind_0_shear.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_500kW_WA_WL_var);

%% Wing loading and sigma_t_max var
clearvars

% Load input file
inputs = loadInputs('inputFile_500kW_high_wind_0_shear.yml');

% Define range for wing loading
WL_values = [2e3, 3e3, 4e3]; % N/m^2

% Define the range for sigma_t_max
sigma_t_max_values = [3e8, 4e8, 5e8]; % Pa

[designSpace_500kW_WL_sigma_t_var] = wingLoading_sigma_t_max_variation(WL_values, sigma_t_max_values, inputs);

% Save design space results
save('outPutFiles/designSpace_500kW_WL_sigma_t_var_high_wind_0_shear.mat','designSpace_500kW_WL_sigma_t_var');

% Load the saved design space results
load('outPutFiles/designSpace_500kW_WL_sigma_t_var_high_wind_0_shear.mat');

% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_500kW_WL_sigma_t_var)

%% Wing area an aspect ratio variation 
clearvars

% Load input file
inputs = loadInputs('inputFile_500kW_high_wind_0_shear.yml');

% Fixed WL
WL_max = 3e3;

% Define the range for wing area and aspect ratio
WA_values = [50, 60, 70]; % m^2
AR_values = [6, 8, 10]; % -

% Evaluate design space
[designSpace_500kW_WA_AR_var] = wingArea_aspectRatio_variation(WA_values, AR_values, inputs, WL_max);

% Save design space results
save('outPutFiles/designSpace_500kW_WA_AR_var_high_wind_0_shear.mat','designSpace_500kW_WA_AR_var');

% Load the saved design space results
load('outPutFiles/designSpace_500kW_WA_AR_var_high_wind_0_shear.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_500kW_WA_AR_var)

%% WA and f_crest variation
clearvars

% Load input file
inputs = loadInputs('inputFile_500kW_high_wind_0_shear.yml');

% Define the range for wing area and aspect ratio
WA_values          = [50, 60, 70]; % m^2
crestFactor_values = [1.5, 2, 2.5]; % -

% Fixed WL
WL_max = 3e3;

% Evaluate design space
[designSpace_500kW_WA_crestFactor_var] = wingArea_crestFactor_variation(WA_values, crestFactor_values, inputs, WL_max);

% Save design space results
save('outPutFiles/designSpace_500kW_WA_crestFactor_var_high_wind_0_shear.mat','designSpace_500kW_WA_crestFactor_var');

% Load the saved design space results
load('outPutFiles/designSpace_500kW_WA_crestFactor_var_high_wind_0_shear.mat');

% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_500kW_WA_crestFactor_var)

%% Reference 500 kW system design
clearvars
perfInputs = loadInputs('inputFile_500kW_high_wind_0_shear.yml');

[perfInputs, perfOutputs, ecoInputs, ecoOutputs] = evalDesignObjective(perfInputs);

systemData_500kW.perfInputs  = perfInputs;
systemData_500kW.perfOutputs = perfOutputs;
systemData_500kW.ecoInputs   = ecoInputs;
systemData_500kW.ecoOutputs  = ecoOutputs;
save('outputFiles/systemData_500kW_high_wind_0_shear.mat');

%% Plot results

load('outputFiles/systemData_500kW_high_wind_0_shear.mat');

figure('units','inch','Position', [8.2 0.5 3.5 2.2])
hold on
grid on
box on
plot(systemData_500kW.perfInputs.vw_ref(1):systemData_500kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_500kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
xlabel('Wind speed at 100 m (m/s)');
ylabel('Power (kW)');
hold off

% Eco results
eco_displayResults_mod_SE(systemData_500kW.ecoInputs, systemData_500kW.ecoOutputs)

%% Plotting saved results

% Load saved design space results
load('outPutFiles/designSpace_500kW_WA_WL_var_high_wind_0_shear.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_500kW_WA_WL_var);

% Load the saved design space results
load('outPutFiles/designSpace_500kW_WL_sigma_t_var_high_wind_0_shear.mat');
% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_500kW_WL_sigma_t_var)

% Load the saved design space results
load('outPutFiles/designSpace_500kW_WA_AR_var_high_wind_0_shear.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_500kW_WA_AR_var)

% Load the saved design space results
load('outPutFiles/designSpace_500kW_WA_crestFactor_var_high_wind_0_shear.mat');
% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_500kW_WA_crestFactor_var)


%% Archived

% %% Crest factor and System rated power variation 
% clearvars
% 
% % Load input file
% inputs = loadInputs('inputFile_500kW_awePower.yml');
% 
% % Define the range for wing area and aspect ratio
% crestFactor_values = [1.5, 2, 2.5]; % -
% P_rated_values   = [250e3, 500e3, 750e3]; % W
% 
% % Evaluate design space
% [designSpace_500kW_crestFactor_P_rated_var] = crestFactor_P_rated_variation(crestFactor_values, P_rated_values, inputs);
% 
% % Save design space results
% save('outPutFiles/designSpace_500kW_crestFactor_P_rated_var.mat','designSpace_500kW_crestFactor_P_rated_var');
% 
% % Load the saved design space results
% load('outPutFiles/designSpace_500kW_crestFactor_P_rated_var.mat');
% 
% % Plot
% plotResults_two_param_variation('crestFactor', '-', 'P_{rated}','W', designSpace_500kW_crestFactor_P_rated_var)

