%% MW scale system simulation for Farm level analysis

clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Run AWE-Power
% Load defined input sheet
inputSheet_for_farm_analysis;

% Enter your defined input sheet name as an argument 
[inputs, outputs, optimDetails, processedOutputs] = main_awePower(inputs);

% Plot results
% plotResults_awePower(inputs, processedOutputs);

% Run AWE-Eco
% Import inputs
inp = eco_system_inputs_Example_SE(inputs, processedOutputs);

% Run EcoModel by parsing the inputs
[inp,par,eco] = eco_main(inp);

% Display results
eco_displayResults(eco)

%% Post processing

vw = inputs.vw_ref;
x_axis_limit = [0 processedOutputs.vw_100m_operRange(end)];

Ft_avg = ((mean(processedOutputs.Ft,2).*processedOutputs.to + mean(processedOutputs.Ft_i,2).*processedOutputs.ti)/(processedOutputs.tCycle))';
Ft_avg_X = Ft_avg.*cosd(processedOutputs.beta);
Ft_avg_Z = Ft_avg.*sind(processedOutputs.beta);

groundRadius  = max(processedOutputs.l_t_max.*cosd(processedOutputs.beta))/1e3; % km
groundDensity = processedOutputs.ratedPower/1e6 / (pi()/4*groundRadius^2) * 4; % MW/km^2


%% Plots
f= figure();
subplot(3,1,1)
hold on
grid on
box on
plot(vw, processedOutputs.P_e_avg/1e6,'d:','linewidth',1,'markersize',3);
ylabel('(MW)');
legend('Power','location','northwest','Orientation','vertical');
xlabel('Wind speed at 100m height (m/s)');
xlim(x_axis_limit);
hold off

subplot(3,1,2)
hold on
grid on
box on
plot(vw, Ft_avg/1e3,'d:','linewidth',1,'markersize',3);
plot(vw, Ft_avg_X/1e3,'d:','linewidth',1,'markersize',3);
plot(vw, Ft_avg_Z/1e3,'d:','linewidth',1,'markersize',3);
ylabel('(kN)');
legend('Thrust_{avg}','Thrust_{avg_X}','Thrust_{avg_Z}','location','northwest','Orientation','vertical');
xlabel('Wind speed at 100m height (m/s)');
xlim(x_axis_limit);
hold off

subplot(3,1,3)
hold on
grid on
box on
plot(vw, processedOutputs.h_cycleAvg,'d:','linewidth',1,'markersize',3);
ylabel('(m)');
legend('Height','location','northwest','Orientation','vertical');
xlabel('Wind speed at 100m height (m/s)');
xlim(x_axis_limit);
hold off
han = axes(f,'visible','off'); 
han.Title.Visible='on';
title(han,['Wind shear coeff = ', num2str(inputs.windShearExp)])