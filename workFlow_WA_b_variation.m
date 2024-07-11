%% WA and b variation

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Add functions to path
addpath(genpath([pwd '/src']));

% Defined input sheet
inputFile_100kW_awePower;
% inputFile_1MW_awePower;

% Define the range for wing area and aspect ratio
WA_values = [10,15,20]; % Wing area values
b_values  = [10,12,14]; % wingspan values

% Initialize a counter for storing results
counter = 1;

% Loop over each wing area value
for i = 1:length(WA_values)
    % Loop over each aspect ratio value
    for j = 1:length(b_values)
        
        % Set wing area and wingspan
        inputs.S = WA_values(i);
        inputs.b = b_values(j);

        % Dependent changes in inputs
        inputs.AR = inputs.b^2/inputs.S; %[]
        inputs.Ft_max = 4 * inputs.S * 1000; %[N]

        % Initial guess
        inputs.nx = ones(1, inputs.numDeltaLelems);
        % [deltaL, avgPattEle,  coneAngle, Rp_start, v_i, CL_i, v_o, kinematicRatio, CL]
        inputs.x0 = [200, deg2rad(30), deg2rad(5), 5 * inputs.b, ...
            inputs.v_d_max * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, ...
            0.8 * inputs.nx, 90 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];
        % Bounds
        inputs.lb = [50, deg2rad(1), deg2rad(1), 5 * inputs.b, 1 * inputs.nx, 0.1 * inputs.nx, ...
            0.8 * inputs.nx, 1 * inputs.nx, 0.1 * inputs.nx];
        inputs.ub = [500, deg2rad(90), deg2rad(60), 10 * inputs.b, inputs.v_d_max * inputs.nx, ...
            inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx, inputs.v_d_max * inputs.nx, ...
            200 * inputs.nx, inputs.Cl_maxAirfoil * inputs.Cl_eff_F * inputs.nx];

        % Save parameter values
        designSpace_WA_b_var(counter).WA_value = WA_values(i);
        designSpace_WA_b_var(counter).b_value = b_values(j);

        % Evaluate design objective
        [designSpace_WA_b_var(counter).systemInputs, designSpace_WA_b_var(counter).perfOutputs, designSpace_WA_b_var(counter).ecoInputs, designSpace_WA_b_var(counter).ecoOutputs] = evalDesignObjective(inputs);

        % Increment the counter
        counter = counter + 1;
    end
end

% Save design space results
save('outPutFiles/designSpace_WA_b_var.mat','designSpace_WA_b_var');

%% Plots

% Load the saved design space results
load('outPutFiles/designSpace_WA_b_var.mat');

plotResults_two_param_variation('WA', 'm^2', 'b','m', designSpace_WA_b_var)



