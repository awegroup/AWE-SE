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

CF_baseCase = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];

%% Load Reduced kite mass scenario
load('outputFiles/systemData_100kW_decr_mk.mat');
load('outputFiles/systemData_500kW_decr_mk.mat');
load('outputFiles/systemData_1000kW_decr_mk.mat');
load('outputFiles/systemData_2000kW_decr_mk.mat');

LCoE_decr_mk = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

CF_decr_mk = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];
    
    %% No storage scenario
load('outputFiles/systemData_100kW_noStorage.mat');
load('outputFiles/systemData_500kW_noStorage.mat');
load('outputFiles/systemData_1000kW_noStorage.mat');
load('outputFiles/systemData_2000kW_noStorage.mat');

LCoE_noStorage = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

CF_noStorage = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];


%% Load Increased discount rate scenario
load('outputFiles/systemData_100kW_incr_r.mat');
load('outputFiles/systemData_500kW_incr_r.mat');
load('outputFiles/systemData_1000kW_incr_r.mat');
load('outputFiles/systemData_2000kW_incr_r.mat');

LCoE_decr_r = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

CF_decr_r = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];

%% Load zero wind shear scenario
load('outputFiles/systemData_100kW_0_windShear.mat');
load('outputFiles/systemData_500kW_0_windShear.mat');
load('outputFiles/systemData_1000kW_0_windShear.mat');
load('outputFiles/systemData_2000kW_0_windShear.mat');

LCoE_0_windShear = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

CF_0_windShear = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];

%% Load high wind zero shear scenario
load('outputFiles/systemData_100kW_high_wind_0_shear.mat');
load('outputFiles/systemData_500kW_high_wind_0_shear.mat');
load('outputFiles/systemData_1000kW_high_wind_0_shear.mat');
load('outputFiles/systemData_2000kW_high_wind_0_shear.mat');

LCoE_high_wind_0_shear = [systemData_100kW.ecoOutputs.metrics.LCoE, ...
        systemData_500kW.ecoOutputs.metrics.LCoE, ...
        systemData_1000kW.ecoOutputs.metrics.LCoE, ...
        systemData_2000kW.ecoOutputs.metrics.LCoE];

CF_high_wind_0_shear = [systemData_100kW.ecoOutputs.metrics.CF, ...
        systemData_500kW.ecoOutputs.metrics.CF, ...
        systemData_1000kW.ecoOutputs.metrics.CF, ...
        systemData_2000kW.ecoOutputs.metrics.CF];



%% LCoE and CF comparison 
systemSizes = [100, 500, 1000, 2000];

figure('units','inch','Position', [5 0.5 7 4])
hold on
box on
grid on
plot(systemSizes, LCoE_baseCase,'k-s', 'LineWidth',1.5,'MarkerSize',4);
plot(systemSizes, LCoE_decr_mk,'-x', 'LineWidth',1.5,'MarkerSize',4);
plot(systemSizes, LCoE_noStorage,'-^', 'LineWidth',1.5,'MarkerSize',4);
plot(systemSizes, LCoE_decr_r,'-v', 'LineWidth',1.5,'MarkerSize',4);
plot(systemSizes, LCoE_0_windShear,'-d', 'LineWidth',1.5,'MarkerSize',4);
plot(systemSizes, LCoE_high_wind_0_shear,'-o', 'LineWidth',1.5,'MarkerSize',4);
legend('Reference scenario', 'Reduced m_k by 50%', 'No storage', 'Increased r to 15%','α_{w}=0', 'α_{w}=0, v_{w,mean}=10m/s');
ylabel('LCoE (€/MWh)');
xticks([100, 500, 1000, 1500, 2000]);
xlabel('System rated power (kW)');
xlim([0 2100]);
hold off

figure('units','inch','Position', [5 5 7 4])
hold on
box on
grid on
plot(systemSizes, CF_baseCase,'k-o', 'LineWidth',2,'MarkerSize',4);
plot(systemSizes, CF_decr_mk,'-o', 'LineWidth',2,'MarkerSize',4);
plot(systemSizes, CF_noStorage,'-o', 'LineWidth',2,'MarkerSize',4);
plot(systemSizes, CF_decr_r,'-o', 'LineWidth',2,'MarkerSize',4);
plot(systemSizes, CF_0_windShear,'-o', 'LineWidth',2,'MarkerSize',4);
plot(systemSizes, CF_high_wind_0_shear,'-o', 'LineWidth',2,'MarkerSize',4);
legend('Reference scenario', 'Reduced m_k by 50%', 'No storage', 'Increased r to 15%','α=0', 'α=0, v_{w,mean}=10m/s');
ylabel('CF (-)');
xticks([100, 500, 1000, 1500, 2000]);
xlabel('System rated power (kW)');
xlim([0 2100]);
hold off


%% Single scenario plots: Base case

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

AEP = [systemData_100kW.ecoOutputs.metrics.AEP, ...
        systemData_500kW.ecoOutputs.metrics.AEP, ...
        systemData_1000kW.ecoOutputs.metrics.AEP, ...
        systemData_2000kW.ecoOutputs.metrics.AEP];

CapEx = [systemData_100kW.ecoOutputs.metrics.ICC, ...
        systemData_500kW.ecoOutputs.metrics.ICC, ...
        systemData_1000kW.ecoOutputs.metrics.ICC, ...
        systemData_2000kW.ecoOutputs.metrics.ICC];

OpEx  = [systemData_100kW.ecoOutputs.metrics.OMC, ...
        systemData_500kW.ecoOutputs.metrics.OMC, ...
        systemData_1000kW.ecoOutputs.metrics.OMC, ...
        systemData_2000kW.ecoOutputs.metrics.OMC];

SP_wingarea = [systemData_100kW.perfInputs.P_ratedElec/systemData_100kW.perfInputs.S, ...
        systemData_500kW.perfInputs.P_ratedElec/systemData_500kW.perfInputs.S, ...
        systemData_1000kW.perfInputs.P_ratedElec/systemData_1000kW.perfInputs.S, ...
        systemData_2000kW.perfInputs.P_ratedElec/systemData_2000kW.perfInputs.S];

WL_max   = [max(mean(systemData_100kW.perfOutputs.Ft,2))/systemData_100kW.perfInputs.S, ...
        max(mean(systemData_500kW.perfOutputs.Ft,2))/systemData_500kW.perfInputs.S, ...
        max(mean(systemData_1000kW.perfOutputs.Ft,2))/systemData_1000kW.perfInputs.S, ...
        max(mean(systemData_2000kW.perfOutputs.Ft,2))/systemData_2000kW.perfInputs.S];

Cp_ref_area = [systemData_100kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_100kW.perfOutputs.ratedWind^3*pi()*systemData_100kW.perfInputs.b^2), ...
        systemData_500kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_500kW.perfOutputs.ratedWind^3*pi()*systemData_500kW.perfInputs.b^2), ...
        systemData_1000kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_1000kW.perfOutputs.ratedWind^3*pi()*systemData_1000kW.perfInputs.b^2), ...
        systemData_2000kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_2000kW.perfOutputs.ratedWind^3*pi()*systemData_2000kW.perfInputs.b^2)];

SP_ref_area = [systemData_100kW.perfInputs.P_ratedElec/(pi()*systemData_100kW.perfInputs.b^2), ...
        systemData_500kW.perfInputs.P_ratedElec/(pi()*systemData_500kW.perfInputs.b^2), ...
        systemData_1000kW.perfInputs.P_ratedElec/(pi()*systemData_1000kW.perfInputs.b^2), ...
        systemData_2000kW.perfInputs.P_ratedElec/(pi()*systemData_2000kW.perfInputs.b^2)];

zeta = [systemData_100kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_100kW.perfOutputs.ratedWind^3*systemData_100kW.perfInputs.S), ...
        systemData_500kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_500kW.perfOutputs.ratedWind^3*systemData_500kW.perfInputs.S), ...
        systemData_1000kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_1000kW.perfOutputs.ratedWind^3*systemData_1000kW.perfInputs.S), ...
        systemData_2000kW.perfInputs.P_ratedElec/(0.5*1.225*systemData_2000kW.perfOutputs.ratedWind^3*systemData_2000kW.perfInputs.S)];

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
ylim([0.95*min(LCoE) 1.05*max(LCoE)]);
ylabel('LCoE (€/MWh)');
yyaxis right
plot(systemSizes, CF, '-x', 'linewidth', 1 , 'markersize', 4);
ylabel('Capacity factor (-)');
xlabel('System rated power (kW)');
xlim([0 2100]);
hold off

% SP_wing_area and wing loading
figure('units','inch','Position', [9 1 3.5 2.2])
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 500, 1000, 1500, 2000]);
yyaxis left
plot(systemSizes, SP_wingarea/1e3, '-s', 'linewidth', 1 , 'markersize', 3);
ylabel('SP_{S} (kW/m^2)');
yyaxis right
plot(systemSizes, WL_max/1e3, '-x', 'linewidth', 1 , 'markersize', 5);
ylabel('W_{l,max} (kN/m^2)');
xlabel('System rated power (kW)');
xlim([0 2100]);
legend('SP_{S} (kW/m^2)', 'W_{l,max} (kN/m^2)', 'Location', 'best');
hold off

% SP_ref_area and Cp_ref_area
figure('units','inch','Position', [13 1 3.5 2.2])
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 500, 1000, 1500, 2000]);
yyaxis left
plot(systemSizes, SP_ref_area, '-s', 'linewidth', 1 , 'markersize', 3);
ylabel('SP_{Aref} (W/m^2)');
yyaxis right
plot(systemSizes, Cp_ref_area, '-x', 'linewidth', 1 , 'markersize', 5);
ylabel('C_{p,Aref} (-)');
xlabel('System rated power (kW)');
xlim([0 2100]);
legend('SP_{Aref} (W/m^2)', 'C_{p,Aref} (-)', 'Location', 'best');
hold off

% Power harvesting factor (zeta)
figure('units','inch','Position', [17 1 3.5 2.2])
hold on
grid on
box on
% Set the x-axis ticks
xticks([100, 500, 1000, 1500, 2000]);
plot(systemSizes, zeta, '-x', 'linewidth', 1 , 'markersize', 4);
ylabel('ζ (-)');
xlabel('System rated power (kW)');
xlim([0 2100]);
hold off

% % AEP, CapEx, OpEx 
% figure('units','inch','Position', [5 1 3.5 2.2])
% hold on
% grid on
% box on
% % Set the x-axis ticks
% xticks([100, 500, 1000, 1500, 2000]);
% yyaxis left
% plot(systemSizes, AEP, '-o', 'linewidth', 1 ,'markersize', 4);
% ylabel('AEP (MWh)');
% yyaxis right
% plot(systemSizes, [CapEx+OpEx], '-x', 'linewidth', 1 , 'markersize', 4);
% % plot(systemSizes, OpEx, '-s', 'linewidth', 1 , 'markersize', 4);
% ylabel('Euros (€)');
% xlabel('System rated power (kW)');
% hold off
  

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

