%% Script to find the optimal system design within a given design space
clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/lib'));
addpath(genpath([pwd '/AWE-Eco']));

% Add folders to path
addpath(genpath([pwd '/inputFiles']));
addpath(genpath([pwd '/outputFiles']));
addpath(genpath([pwd '/src']));

% Load input file
inputs                = loadInputs('inputFile_100kW_awePower.yml');
inputs.name           = 'Opt_systDes_100kW';
% inputs.numDeltaLelems = 1;

lb = [10, 1e3, 2e8, 10, 1.5]; % Lower bounds
x0 = [20, 2e3, 3e8, 14, 2]; % Initial guess
ub = [50, 4e3, 5e8, 18, 3]; % Upper bounds

numStartPoints = 4;

[x_opt, ~, ~, optTime, all_x_0, all_x, all_fval] = findOptimalSystemDesign(inputs, lb, x0, ub, numStartPoints);

% % Rerunning with x_opt as x_0
% inputs.numDeltaLelems = 4;
% lb                    = [x_opt(1), x_opt(2), x_opt(3), x_opt(4), 2]; % Lower bounds
% x0                    = x_opt; % Initial guess
% ub                    = [x_opt(1), x_opt(2), x_opt(3), x_opt(4), 3]; % Upper bounds
% 
% numStartPoints        = 1;
% 
% [x_opt, fval, exitflag, ~, ~, ~, ~] = findOptimalSystemDesign(inputs, lb, x0, ub, numStartPoints);

% Power curve of optimal system design
inputs.S                 = x_opt(1);
inputs.Ft_max            = x_opt(2)*inputs.S;
inputs.Te_matStrength    = x_opt(3);
inputs.AR                = x_opt(4);
inputs.crestFactor_power = x_opt(5);

[perfInputs, ~, ~, perfOutputs] = main_awePower(inputs);

% Power curve
figure()
hold on
grid on
box on
plot(perfInputs.vw_ref(1):perfOutputs.vw_h_ref_operRange(end),perfOutputs.P_e_avg,'-o');
hold off

