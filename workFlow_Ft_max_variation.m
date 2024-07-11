%% Ft_max variation

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

% Define the range for Ft_max
Ft_guess           = 4*mean(inputs.S)*1000; % N
Ft_max_values      = [Ft_guess*0.5, Ft_guess*0.75, Ft_guess, Ft_guess*1.25, Ft_guess*1.5]; % N

% Loop over each Ft_max value
for i = 1:length(Ft_max_values)
  inputs.Ft_max = Ft_max_values(i);

  % Save parameter values
  designSpace_Ft_max_var(i).paramValue   = Ft_max_values(i);

  % Evaluate design objective
  [designSpace_Ft_max_var(i).perfInputs, designSpace_Ft_max_var(i).perfOutputs, designSpace_Ft_max_var(i).ecoInputs, designSpace_Ft_max_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_Ft_max_var.mat','designSpace_Ft_max_var');

%% Plots

% Load saved results
load("outputFiles/designSpace_Ft_max_var.mat");

plotResults_single_param_variation('F_{t,max}', 'N', designSpace_Ft_max_var);
 
figure()
hold on
for i = 1:length(designSpace_Ft_max_var)
    opex(i)  = designSpace_Ft_max_var(i).ecoOutputs.tether.OPEX;
    capex(i) = designSpace_Ft_max_var(i).ecoOutputs.tether.CAPEX;
    f_repl(i) = designSpace_Ft_max_var(i).ecoOutputs.tether.f_repl;
end
yyaxis left
plot(opex);
plot(capex);
ylabel('Euros');
yyaxis right
plot(f_repl)
ylabel('f_{repl}');
legend('OPEX','CAPEX','f_{repl}');
hold off

figure()
hold on
for i = 1:length(designSpace_Ft_max_var)
    len_t(i)  = designSpace_Ft_max_var(i).ecoInputs.tether.L;
    dia_t(i)  = designSpace_Ft_max_var(i).ecoInputs.tether.d;
end
yyaxis left
plot(len_t);
ylabel('Tether length (m)');
yyaxis right
plot(dia_t)
ylabel('Tether diameter (m)');
hold off

