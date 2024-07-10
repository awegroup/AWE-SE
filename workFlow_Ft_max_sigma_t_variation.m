%% Ft_max and sigma_t variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Add functions to path
addpath(genpath([pwd '/functions']));

% Defined input sheet
inputFile_100kW_awePower;
% inputFile_1MW_awePower;

% Define the range for Ft_max and Te_matStrength
Ft_max_values = [5e4, 6e4]; % Ft_max values
sigma_t_values = [5e8, 7e8]; % Te_matStrength values

% Initialize a counter for storing results
counter = 1;

% Loop over each Ft_max value
for i = 1:length(Ft_max_values)
    % Loop over each Te_matStrength value
    for j = 1:length(sigma_t_values)
        
        % Set Ft_max and Te_matStrength
        inputs.Ft_max = Ft_max_values(i);
        inputs.Te_matStrength = sigma_t_values(j);

        % Save parameter values
        designSpace_Ft_max_sigma_t_var(counter).Ft_max_value = Ft_max_values(i);
        designSpace_Ft_max_sigma_t_var(counter).sigma_t_value = sigma_t_values(j);

        % Evaluate design objective
        [designSpace_Ft_max_sigma_t_var(counter).systemInputs, designSpace_Ft_max_sigma_t_var(counter).perfOutputs, designSpace_Ft_max_sigma_t_var(counter).ecoInputs, designSpace_Ft_max_sigma_t_var(counter).ecoOutputs] = evalDesignObjective(inputs);

        % Increment the counter
        counter = counter + 1;
    end
end

% Save design space results
save('outPutFiles/designSpace_Ft_max_sigma_t_var.mat','designSpace_Ft_max_sigma_t_var');

%% Plots

% Load the saved design space results
load('outPutFiles/designSpace_Ft_max_sigma_t_var.mat');

plotResults_two_param_variation('F_{t,max}', 'N', 'sigma_t','Pa', designSpace_Ft_max_sigma_t_var)
