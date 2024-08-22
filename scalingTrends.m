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
addpath(genpath([pwd '/lib']));

%% Load Base case scenario
load('outputFiles/systemData_100kW_baseCase.mat');
load('outputFiles/systemData_500kW_baseCase.mat');
load('outputFiles/systemData_1000kW_baseCase.mat');
load('outputFiles/systemData_2000kW_baseCase.mat');

LCoE_baseCase = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

%% Load Reduced kite mass scenario
load('outputFiles/systemData_100kW_decr_mk.mat');
load('outputFiles/systemData_500kW_decr_mk.mat');
load('outputFiles/systemData_1000kW_decr_mk.mat');
load('outputFiles/systemData_2000kW_decr_mk.mat');

LCoE_decr_mk = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

%% Load Increased discount rate scenario
load('outputFiles/systemData_100kW_incr_r.mat');
load('outputFiles/systemData_500kW_incr_r.mat');
load('outputFiles/systemData_1000kW_incr_r.mat');
load('outputFiles/systemData_2000kW_incr_r.mat');

LCoE_decr_r = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

%% Load zero wind shear scenario
load('outputFiles/systemData_100kW_0_windShear.mat');
load('outputFiles/systemData_500kW_0_windShear.mat');
load('outputFiles/systemData_1000kW_0_windShear.mat');
load('outputFiles/systemData_2000kW_0_windShear.mat');

LCoE_0_windShear = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

%% Load high wind zero shear scenario
load('outputFiles/systemData_100kW_high_wind_0_shear.mat');
load('outputFiles/systemData_500kW_high_wind_0_shear.mat');
load('outputFiles/systemData_1000kW_high_wind_0_shear.mat');
load('outputFiles/systemData_2000kW_high_wind_0_shear.mat');

LCoE_high_wind_0_shear = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

%% LCoE comparison 
systemSizes = [100, 500, 1000, 2000];

figure()
hold on
box on
grid on
plot(systemSizes, LCoE_baseCase,'k-o', 'LineWidth',2,'MarkerSize',4);
plot(systemSizes, LCoE_decr_mk,'-o', 'LineWidth',1,'MarkerSize',4);
plot(systemSizes, LCoE_decr_r,'-o', 'LineWidth',1,'MarkerSize',4);
plot(systemSizes, LCoE_0_windShear,'-o', 'LineWidth',1,'MarkerSize',4);
plot(systemSizes, LCoE_high_wind_0_shear,'-o', 'LineWidth',1,'MarkerSize',4);
legend('Base-case: r=10%, α=0.2, v_{w,mean}=8.5m/s', 'Reduced m_k by 50%', 'Increased r to 15%','α=0', 'α=0, v_{w,mean}=10m/s');
ylabel('LCoE (€/MWh)');
xticks([100, 500, 1000, 1500, 2000]);
xlabel('System size (kW)');
hold off


%% Single scenario plots

systemSizes = [100, 500, 1000, 2000];

% Load Base case scenario
load('outputFiles/systemData_100kW_baseCase.mat');
load('outputFiles/systemData_500kW_baseCase.mat');
load('outputFiles/systemData_1000kW_baseCase.mat');
load('outputFiles/systemData_2000kW_baseCase.mat');

LCoE = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

CF   = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];

WASP = [systemData_100kW.perfInputs.P_ratedElec/systemData_100kW.perfInputs.S, ...
        systemData_500kW.perfInputs.P_ratedElec/systemData_500kW.perfInputs.S, ...
        systemData_1000kW.perfInputs.P_ratedElec/systemData_1000kW.perfInputs.S, ...
        systemData_2000kW.perfInputs.P_ratedElec/systemData_2000kW.perfInputs.S];

% Power curves
figure('units','inch','Position', [1 1 3.5 2.2])
hold on
grid on
box on
plot(systemData_100kW.perfInputs.vw_ref(1):systemData_100kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_100kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
plot(systemData_500kW.perfInputs.vw_ref(1):systemData_500kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_500kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
plot(systemData_1000kW.perfInputs.vw_ref(1):systemData_1000kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_1000kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
plot(systemData_2000kW.perfInputs.vw_ref(1):systemData_2000kW.perfOutputs.vw_h_ref_operRange(end), ...
    systemData_2000kW.perfOutputs.P_e_avg./1e3,'-o', 'MarkerSize',3, 'LineWidth',1);
xlabel('Wind speed at 100 m (m/s)');
ylabel('Power (kW)');
hold off

% LCoE and CF
figure('units','inch','Position', [5 1 3.5 2.2])
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 500, 1000, 1500, 2000]);
yyaxis left
plot(systemSizes, LCoE, '-o', 'linewidth', 1 ,'markersize', 4);
ylabel('LCoE (€/MWh)');
yyaxis right
plot(systemSizes, CF, '-x', 'linewidth', 1 , 'markersize', 4);
ylabel('Capacity factor (-)');
xlabel('System size (kW)');
hold off

% WASP
figure('units','inch','Position', [9 1 3.5 2.2])
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 500, 1000, 1500, 2000]);
plot(systemSizes, WASP, '-s', 'linewidth', 1 , 'markersize', 5);
ylabel('WASP (W/m^2)');
xlabel('System size (kW)');
hold off  

% Design matrix table
kW100 = [systemData_100kW.perfInputs.P_ratedElec/1e3, ...
         systemData_100kW.perfInputs.S,...
         systemData_100kW.perfInputs.Ft_max/systemData_100kW.perfInputs.S,...
         systemData_100kW.perfInputs.Te_matStrength/1e9,...
         systemData_100kW.perfInputs.AR,...
         systemData_100kW.perfInputs.crestFactor_power];
kW500 = [systemData_500kW.perfInputs.P_ratedElec/1e3, ...
         systemData_500kW.perfInputs.S,...
         systemData_500kW.perfInputs.Ft_max/systemData_500kW.perfInputs.S,...
         systemData_500kW.perfInputs.Te_matStrength/1e9,...
         systemData_500kW.perfInputs.AR,...
         systemData_500kW.perfInputs.crestFactor_power];
kW1000 = [systemData_1000kW.perfInputs.P_ratedElec/1e3, ...
         systemData_1000kW.perfInputs.S,...
         systemData_1000kW.perfInputs.Ft_max/systemData_1000kW.perfInputs.S,...
         systemData_1000kW.perfInputs.Te_matStrength/1e9,...
         systemData_1000kW.perfInputs.AR,...
         systemData_1000kW.perfInputs.crestFactor_power];
kW2000 = [systemData_2000kW.perfInputs.P_ratedElec/1e3, ...
         systemData_2000kW.perfInputs.S,...
         systemData_2000kW.perfInputs.Ft_max/systemData_2000kW.perfInputs.S,...
         systemData_2000kW.perfInputs.Te_matStrength/1e9,...
         systemData_2000kW.perfInputs.AR,...
         systemData_2000kW.perfInputs.crestFactor_power];
% Combine all data into one matrix
data = [kW100; kW500; kW1000; kW2000];

% Define column names
columnNames = {'P_{rated}','S', 'Ft_max/S', 'Te_matStrength (GPa)', 'AR', 'Crest Factor'};

% Create the table with data for each attribute
designMatrixTable = table(data(:,1), data(:,2), data(:,3), data(:,4), data(:,5), data(:,6), 'VariableNames', columnNames);

% Display the table
disp(designMatrixTable);



% % Spider plot
% % Data Matrix
% D1 = [20 14 2 0.3 2];
% D2 = [60 14 3 0.4 2];
% D3 = [100 14 3 0.4 2];
% D4 = [140 14 4 0.5 2.5];
% data = [D1; D2; D3; D4]; 
% 
% axes_limits = [min(data(:,1)), min(data(:,2))-1, min(data(:,3)), min(data(:,4)), min(data(:,5)); 
%                max(data(:,1)), max(data(:,2)), max(data(:,3)), max(data(:,4)), max(data(:,5))];
% 
% axis_labels = {'S (m^2)', 'AR (-)', 'W_{l,max} (kN/m^2)', 'σ_{t,max} (GPa)', 'P_{crest} (-)'};
% 
% % Spider Plot
% figure;
% hold on
% spider_plot(data, ...
%     'AxesLimits', axes_limits,'AxesLabels',axis_labels); % Pass the calculated axis limits
% title