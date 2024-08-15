%% Design space exploraton: 100 kW Base case
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
WA_values = [10, 20, 30, 40]; % m^2

% Define range for wing loading
WL_values = [1e3, 2e3, 3e3, 4e3]; % N/m^2

% Evaluate design space
[designSpace_100kW_WA_WL_var] = wingArea_wingLoading_variation(WA_values, WL_values, inputs);

% Save design space results
save('outPutFiles/designSpace_100kW_WA_WL_var_baseCase.mat', 'designSpace_100kW_WA_WL_var');

% Load saved design space results
load('outPutFiles/designSpace_100kW_WA_WL_var_baseCase.mat');

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
save('outPutFiles/designSpace_100kW_WL_sigma_t_var_baseCase.mat','designSpace_100kW_WL_sigma_t_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WL_sigma_t_var_baseCase.mat');

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
save('outPutFiles/designSpace_100kW_WA_AR_var_baseCase.mat','designSpace_100kW_WA_AR_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_AR_var_baseCase.mat');

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
save('outPutFiles/designSpace_100kW_WA_crestFactor_var_baseCase.mat','designSpace_100kW_WA_crestFactor_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_crestFactor_var_baseCase.mat');

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

save('outputFiles/systemData_100kW_baseCase.mat');

%% Plot results

load('outputFiles/systemData_100kW_baseCase.mat');

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
load('outPutFiles/designSpace_100kW_WA_WL_var_baseCase.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'WL', 'N/m^2', designSpace_100kW_WA_WL_var);

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WL_sigma_t_var_baseCase.mat');
% Plot
plotResults_two_param_variation('WL', 'N/m^2', 'σ_{t,max}','Pa', designSpace_100kW_WL_sigma_t_var);

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_AR_var_baseCase.mat');
% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','-', designSpace_100kW_WA_AR_var)

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_crestFactor_var_baseCase.mat');
% Plot
plotResults_two_param_variation('Wing area', 'm^2', 'f_{crest}','-', designSpace_100kW_WA_crestFactor_var)


%% Discount rate calculation
% 
%   r_d     = 0.10; % cost of debt
%   r_e     = 0.10; % cost of equity
%   TaxRate = 0; % Tax rate (25%)
%   DtoE    = 50/50; % Debt-Equity-ratio
% 
%   r = DtoE/(1+ DtoE)*r_d*(1-TaxRate) + 1/(1+DtoE)*r_e;

%% %%%%%%%%%%%%%%%%%%%%%
% Archived
%%%%%%%%%%%%%%%%%%%%%%%%


% %% Crest factor and System rated power variation 
% clearvars
% 
% % Load input file
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for wing area and aspect ratio
% crestFactor_values = [1.5, 2, 2.5]; % -
% P_rated_values   = [100e3, 125e3]; % W
% 
% % Evaluate design space
% [designSpace_100kW_crestFactor_P_rated_var] = crestFactor_P_rated_variation(crestFactor_values, P_rated_values, inputs);
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_crestFactor_P_rated_var.mat','designSpace_100kW_crestFactor_P_rated_var');
% 
% % Load the saved design space results
% load('outPutFiles/designSpace_100kW_crestFactor_P_rated_var.mat');
% 
% % Plot
% plotResults_two_param_variation('crestFactor', '-', 'P_{rated}','W', designSpace_100kW_crestFactor_P_rated_var)



% 
% %% Wing area variation
% clearvars
% 
% % Load input file
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for wing area
% WA_values = [10, 15, 20, 25]; % m
% 
% % Evaluate design space
% [designSpace_100kW_WA_var] = wingArea_variation(WA_values, inputs);
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_WA_var.mat','designSpace_100kW_WA_var');
% 
% % Load saved results
% load("outputFiles/designSpace_100kW_WA_var.mat");
% 
% % Plots
% plotResults_single_param_variation('Wing area', 'm^2', designSpace_100kW_WA_var);
% tetherDetailsPlots('Wing area', 'm^2',designSpace_100kW_WA_var);
% 
% 
% %% AR var
% 
% % Load input file
% clearvars
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for wing area
% AR_values = [12,13,14,15,16]; % Wing area values
% 
% % Loop over each wing area value
% for i = 1:length(AR_values)
%   inputs.AR = AR_values(i);
% 
%   % Save parameter values
%   designSpace_100kW_AR_var(i).paramValue   = AR_values(i);
% 
%   % Evaluate design objective
%   [designSpace_100kW_AR_var(i).perfInputs, designSpace_100kW_AR_var(i).perfOutputs, designSpace_100kW_AR_var(i).ecoInputs, designSpace_100kW_AR_var(i).ecoOutputs] = evalDesignObjective(inputs);
% 
% end
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_AR_var.mat','designSpace_100kW_AR_var');
% 
% % Load saved results
% load("outputFiles/designSpace_100kW_AR_var.mat");
% 
% % Plot
% plotResults_single_param_variation('AR', '', designSpace_100kW_AR_var);
% 
% 
% %% Wingspan var
% 
% % Load input file
% clearvars
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for wingspan
% span_values = [12, 14, 16, 18]; % m
% 
% % Loop over each wing area value
% for i = 1:length(span_values)
% 
%   inputs.b = span_values(i);
% 
%   % Dependent changes in inputs
%   inputs.S      = inputs.b^2/inputs.AR; %[m^2]
%   inputs.Ft_max = 4*inputs.S*1000; %[N]
% 
%   % Save parameter values
%   designSpace_100kW_span_var(i).paramValue = span_values(i);
% 
%   % Evaluate design objective
%   [designSpace_100kW_span_var(i).perfInputs, designSpace_100kW_span_var(i).perfOutputs, designSpace_100kW_span_var(i).ecoInputs, designSpace_100kW_span_var(i).ecoOutputs] = evalDesignObjective(inputs);
% 
% end
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_span_var.mat','designSpace_100kW_span_var');
% 
% % Load saved results
% load("outputFiles/designSpace_100kW_WA_var.mat");
% 
% % Plot
% plotResults_single_param_variation('Wingspan', 'm', designSpace_100kW_span_var);
% 
% 
% %% Ft_max var
% 
% % Load input file
% clearvars
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for Ft_max
% Ft_guess           = 4*mean(inputs.S)*1000; % N
% Ft_max_values      = [Ft_guess*0.5, Ft_guess*0.75, Ft_guess, Ft_guess*1.25, Ft_guess*1.5]; % N
% 
% % Loop over each Ft_max value
% for i = 1:length(Ft_max_values)
%   inputs.Ft_max = Ft_max_values(i);
% 
%   % Save parameter values
%   designSpace_100kW_Ft_max_var(i).paramValue   = Ft_max_values(i);
% 
%   % Evaluate design objective
%   [designSpace_100kW_Ft_max_var(i).perfInputs, designSpace_100kW_Ft_max_var(i).perfOutputs, designSpace_100kW_Ft_max_var(i).ecoInputs, designSpace_100kW_Ft_max_var(i).ecoOutputs] = evalDesignObjective(inputs);
% 
% end
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_Ft_max_var.mat','designSpace_100kW_Ft_max_var');
% 
% % Load saved results
% load("outputFiles/designSpace_100kW_Ft_max_var.mat");
% 
% % Plot
% plotResults_single_param_variation('F_{t,max}', 'N', designSpace_100kW_Ft_max_var);
% 
% 
% %% sigma_t_max var
% 
% % Load input file
% clearvars
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for sigma_t_max
% sigma_t_max_values = [4e8, 5e8, 6e8, 7e8]; % Pa
% 
% % Loop over each sigma_t_max value
% for i = 1:length(sigma_t_max_values)
%   inputs.Te_matStrength = sigma_t_max_values(i);
% 
%   % Save parameter values
%   designSpace_100kW_sigma_t_max_var(i).paramValue   = sigma_t_max_values(i);
% 
%   % Evaluate design objective
%   [designSpace_100kW_sigma_t_max_var(i).perfInputs, designSpace_100kW_sigma_t_max_var(i).perfOutputs, designSpace_100kW_sigma_t_max_var(i).ecoInputs, designSpace_100kW_sigma_t_max_var(i).ecoOutputs] = evalDesignObjective(inputs);
% 
% end
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_sigma_t_max_var.mat','designSpace_100kW_sigma_t_max_var');
% 
% % Load saved results
% load("outputFiles/designSpace_100kW_sigma_t_max_var.mat");
% 
% % Plot
% plotResults_single_param_variation('σ_{t,max}', 'Pa', designSpace_100kW_sigma_t_max_var);
% 
% 
% %% WA and b var
% 
% % Load input file
% clearvars
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define the range for wing area and aspect ratio
% WA_values = [10,15,20]; % Wing area values
% b_values  = [10,12,14]; % wingspan values
% 
% % Initialize a counter for storing results
% counter = 1;
% 
% % Loop over each wing area value
% for i = 1:length(WA_values)
%   % Loop over each aspect ratio value
%   for j = 1:length(b_values)
% 
%     % Set wing area and wingspan
%     inputs.S = WA_values(i);
%     inputs.b = b_values(j);
% 
%     % Dependent changes in inputs
%     inputs.AR = inputs.b^2/inputs.S; %[]
%     inputs.Ft_max = 4 * inputs.S * 1000; %[N]
% 
%     % Save parameter values
%     designSpace_100kW_WA_b_var(counter).WA_value = WA_values(i);
%     designSpace_100kW_WA_b_var(counter).b_value = b_values(j);
% 
%     % Evaluate design objective
%     [designSpace_100kW_WA_b_var(counter).perfInputs, designSpace_100kW_WA_b_var(counter).perfOutputs, designSpace_100kW_WA_b_var(counter).ecoInputs, designSpace_100kW_WA_b_var(counter).ecoOutputs] = evalDesignObjective(inputs);
% 
%     % Increment the counter
%     counter = counter + 1;
%   end
% end
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_WA_b_var.mat','designSpace_100kW_WA_b_var');
% 
% % Load the saved design space results
% load('outPutFiles/designSpace_100kW_WA_b_var.mat');
% 
% % Plot
% plotResults_two_param_variation('WA', 'm^2', 'b','m', designSpace_100kW_WA_b_var)
% 
% %% WA and Ft_max var
% 
% % Load input file
% clearvars
% inputs = loadInputs('inputFile_100kW_awePower.yml');
% 
% % Define range for wing area and Ft_max
% WA_values = [15, 20]; % Wing area values (m^2)
% 
% % Calculate Ft_max_values based on WA_values
% Ft_guess = 4*mean(WA_values)*1000; % N
% Ft_max_values = [Ft_guess*0.8, Ft_guess,Ft_guess*1.2]; % Range for Ft_max
% 
% % Initialize structure array to store design space results
% designSpace_100kW_WA_Ft_var = struct([]);
% 
% % Initialize counter for storing results
% counter = 1;
% 
% % Loop over each wing area value
% for i = 1:length(WA_values)
%   % Loop over each Ft_max value
%   for j = 1:length(Ft_max_values)
% 
%     % Set wing area and Ft_max
%     inputs.S = WA_values(i); % Wing area (m^2)
%     inputs.Ft_max = Ft_max_values(j); % Maximum thrust (N)
% 
% 
%     % Save parameter values
%     designSpace_100kW_WA_Ft_var(counter).S_value = inputs.S;
%     designSpace_100kW_WA_Ft_var(counter).Ft_max_value = inputs.Ft_max;
% 
%     % Evaluate design objective
%     [designSpace_100kW_WA_Ft_var(counter).systemInputs, designSpace_100kW_WA_Ft_var(counter).perfOutputs, ...
%       designSpace_100kW_WA_Ft_var(counter).ecoInputs, designSpace_100kW_WA_Ft_var(counter).ecoOutputs] = evalDesignObjective(inputs);
% 
%     % Increment counter
%     counter = counter + 1;
%   end
% end
% 
% % Save design space results
% save('outPutFiles/designSpace_100kW_WA_Ft_var.mat', 'designSpace_100kW_WA_Ft_var');
% 
% % Load saved design space results
% load('outPutFiles/designSpace_100kW_WA_Ft_var.mat');
% 
% % Plot
% plotResults_two_param_variation('WA', 'm^2', 'F_{t,max}', 'N', designSpace_100kW_WA_Ft_var);


