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

%% Load system data

load('outputFiles/systemData_100kW.mat');
load('outputFiles/systemData_250kW.mat');
load('outputFiles/systemData_500kW.mat');
load('outputFiles/systemData_750kW.mat');
load('outputFiles/systemData_1MW.mat');
load('outputFiles/systemData_2MW.mat');

systemSizes = [100, 250, 500, 750, 1000, 2000];

LCoE = [systemData_100kW.ecoOutputs.metrics.LCoE, systemData_250kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, systemData_750kW.ecoOutputs.metrics.LCoE, ...
        systemData_1MW.ecoOutputs.metrics.LCoE, systemData_2MW.ecoOutputs.metrics.LCoE];

CF   = [systemData_100kW.ecoOutputs.metrics.CF, systemData_250kW.ecoOutputs.metrics.CF, ...
      systemData_500kW.ecoOutputs.metrics.CF, systemData_750kW.ecoOutputs.metrics.CF, ...
      systemData_1MW.ecoOutputs.metrics.CF, systemData_2MW.ecoOutputs.metrics.CF];

WASP = [systemData_100kW.perfInputs.P_ratedElec/systemData_100kW.perfInputs.S, ...
        systemData_250kW.perfInputs.P_ratedElec/systemData_250kW.perfInputs.S, ...
        systemData_500kW.perfInputs.P_ratedElec/systemData_500kW.perfInputs.S, ...
        systemData_750kW.perfInputs.P_ratedElec/systemData_750kW.perfInputs.S, ...
        systemData_1MW.perfInputs.P_ratedElec/systemData_1MW.perfInputs.S, ...
        systemData_2MW.perfInputs.P_ratedElec/systemData_2MW.perfInputs.S];

figure()
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 250, 500, 750, 1000, 1250, 1500, 1750, 2000]);
yyaxis left
plot(systemSizes, LCoE, '-o', 'linewidth', 1 ,'markersize', 5);
ylabel('LCoE (€/MWh)');
yyaxis right
plot(systemSizes, CF, '-s', 'linewidth', 1 , 'markersize', 5);
ylabel('Capacity factor (-)');
xlabel('System size (kW)');
hold off

figure()
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 250, 500, 750, 1000, 1250, 1500, 1750, 2000]);
plot(systemSizes, WASP, '-s', 'linewidth', 1 , 'markersize', 5);
ylabel('WASP (W/m^2)');
xlabel('System size (kW)');
hold off

