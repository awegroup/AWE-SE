%% 100 kW system
clc; clearvars;

% Add the source code folders of AWE-Power and AWE-Eco to path
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/src'));
addpath(genpath('C:/PhD/GitHubRepo/AWE-Power/lib'));
addpath(genpath([pwd '/AWE-Eco']));

% Add inputFiles to path
addpath(genpath([pwd '/inputFiles']));

% Add functions to path
addpath(genpath([pwd '/src']));

%% WA var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for wing area
WA_values = [10, 15, 20, 25]; % m

% % Loop over each wing area value
% for i = 1:length(WA_values)
% 
%   inputs.S      = WA_values(i);
%   inputs.Ft_max = 4*inputs.S*1000; %[N]
% 
%   % Save parameter values
%   designSpace_100kW_WA_var(i).paramValue = WA_values(i);
% 
%   % Evaluate design objective
%   [designSpace_100kW_WA_var(i).perfInputs, designSpace_100kW_WA_var(i).perfOutputs, designSpace_100kW_WA_var(i).ecoInputs, designSpace_100kW_WA_var(i).ecoOutputs] = evalDesignObjective(inputs);
% end

[designSpace_100kW_WA_var] = wingareaVar(WA_values, inputs, 'designSpace_100kW_WA_var');

% % Save design space results
% save('outPutFiles/designSpace_100kW_WA_var.mat','designSpace_100kW_WA_var');

% Load saved results
load("outputFiles/designSpace_100kW_WA_var.mat");

% Plot
plotResults_single_param_variation('Wing area', 'm^2', designSpace_100kW_WA_var);

%% AR var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for wing area
AR_values = [12,13,14,15,16]; % Wing area values

% Loop over each wing area value
for i = 1:length(AR_values)
  inputs.AR = AR_values(i);

  % Save parameter values
  designSpace_100kW_AR_var(i).paramValue   = AR_values(i);

  % Evaluate design objective
  [designSpace_100kW_AR_var(i).perfInputs, designSpace_100kW_AR_var(i).perfOutputs, designSpace_100kW_AR_var(i).ecoInputs, designSpace_100kW_AR_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_100kW_AR_var.mat','designSpace_100kW_AR_var');

% Load saved results
load("outputFiles/designSpace_100kW_AR_var.mat");

% Plot
plotResults_single_param_variation('AR', '', designSpace_100kW_AR_var);


%% Wingspan var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for wingspan
span_values = [12, 14, 16, 18]; % m

% Loop over each wing area value
for i = 1:length(span_values)

  inputs.b = span_values(i);

  % Dependent changes in inputs
  inputs.S      = inputs.b^2/inputs.AR; %[m^2]
  inputs.Ft_max = 4*inputs.S*1000; %[N]

  % Save parameter values
  designSpace_100kW_span_var(i).paramValue = span_values(i);

  % Evaluate design objective
  [designSpace_100kW_span_var(i).perfInputs, designSpace_100kW_span_var(i).perfOutputs, designSpace_100kW_span_var(i).ecoInputs, designSpace_100kW_span_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_100kW_span_var.mat','designSpace_100kW_span_var');

% Load saved results
load("outputFiles/designSpace_100kW_WA_var.mat");

% Plot
plotResults_single_param_variation('Wingspan', 'm', designSpace_100kW_span_var);


%% Ft_max var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for Ft_max
Ft_guess           = 4*mean(inputs.S)*1000; % N
Ft_max_values      = [Ft_guess*0.5, Ft_guess*0.75, Ft_guess, Ft_guess*1.25, Ft_guess*1.5]; % N

% Loop over each Ft_max value
for i = 1:length(Ft_max_values)
  inputs.Ft_max = Ft_max_values(i);

  % Save parameter values
  designSpace_100kW_Ft_max_var(i).paramValue   = Ft_max_values(i);

  % Evaluate design objective
  [designSpace_100kW_Ft_max_var(i).perfInputs, designSpace_100kW_Ft_max_var(i).perfOutputs, designSpace_100kW_Ft_max_var(i).ecoInputs, designSpace_100kW_Ft_max_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_100kW_Ft_max_var.mat','designSpace_100kW_Ft_max_var');

% Load saved results
load("outputFiles/designSpace_100kW_Ft_max_var.mat");

% Plot
plotResults_single_param_variation('F_{t,max}', 'N', designSpace_100kW_Ft_max_var);

figure()
hold on
for i = 1:length(designSpace_100kW_Ft_max_var)
  opex(i)  = designSpace_100kW_Ft_max_var(i).ecoOutputs.tether.OPEX;
  capex(i) = designSpace_100kW_Ft_max_var(i).ecoOutputs.tether.CAPEX;
  f_repl(i) = designSpace_100kW_Ft_max_var(i).ecoOutputs.tether.f_repl;
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
for i = 1:length(designSpace_100kW_Ft_max_var)
  len_t(i)  = designSpace_100kW_Ft_max_var(i).ecoInputs.tether.L;
  dia_t(i)  = designSpace_100kW_Ft_max_var(i).ecoInputs.tether.d;
end
yyaxis left
plot(len_t);
ylabel('Tether length (m)');
yyaxis right
plot(dia_t)
ylabel('Tether diameter (m)');
hold off


%% sigma_t_max var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for sigma_t_max
sigma_t_max_values = [4e8, 5e8, 6e8, 7e8]; % Pa

% Loop over each sigma_t_max value
for i = 1:length(sigma_t_max_values)
  inputs.Te_matStrength = sigma_t_max_values(i);

  % Save parameter values
  designSpace_100kW_sigma_t_max_var(i).paramValue   = sigma_t_max_values(i);

  % Evaluate design objective
  [designSpace_100kW_sigma_t_max_var(i).perfInputs, designSpace_100kW_sigma_t_max_var(i).perfOutputs, designSpace_100kW_sigma_t_max_var(i).ecoInputs, designSpace_100kW_sigma_t_max_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_100kW_sigma_t_max_var.mat','designSpace_100kW_sigma_t_max_var');

% Load saved results
load("outputFiles/designSpace_100kW_sigma_t_max_var.mat");

% Plot
plotResults_single_param_variation('σ_{t,max}', 'Pa', designSpace_100kW_sigma_t_max_var);


%% P_gen var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for P_gen
P_gen_values = [100, 150, 250, 300]; % kW

% Loop over each sigma_t_max value
for i = 1:length(P_gen_values)
  inputs.peakM2E_F = P_gen_values(i)/inputs.P_ratedElec*1000;

  % Save parameter values
  designSpace_100kW_P_gen_var(i).paramValue   = P_gen_values(i);

  % Evaluate design objective
  [designSpace_100kW_P_gen_var(i).perfInputs, designSpace_100kW_P_gen_var(i).perfOutputs, designSpace_100kW_P_gen_var(i).ecoInputs, designSpace_100kW_P_gen_var(i).ecoOutputs] = evalDesignObjective(inputs);

end

% Save design space results
save('outPutFiles/designSpace_100kW_P_gen_var.mat','designSpace_100kW_P_gen_var');

% Load saved results
load("outputFiles/designSpace_100kW_P_gen_var.mat");

% Plot
plotResults_single_param_variation('P_{gen}', 'kW', designSpace_100kW_P_gen_var);


%% WA and AR var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for wing area and aspect ratio
WA_values = [10,15,20,25]; % Wing area values
AR_values = [10,12,14,16,18]; % Aspect ratio values

% Initialize a counter for storing results
counter = 1;

% Loop over each wing area value
for i = 1:length(WA_values)
  % Loop over each aspect ratio value
  for j = 1:length(AR_values)

    % Set wing area and aspect ratio
    inputs.S = WA_values(i);
    inputs.AR = AR_values(j);

    % Dependent changes in inputs
    inputs.Ft_max = 4 * inputs.S * 1000; %[N]

    % Save parameter values
    designSpace_100kW_WA_AR_var(counter).WA_value = WA_values(i);
    designSpace_100kW_WA_AR_var(counter).AR_value = AR_values(j);

    % Evaluate design objective
    [designSpace_100kW_WA_AR_var(counter).perfInputs, designSpace_100kW_WA_AR_var(counter).perfOutputs, designSpace_100kW_WA_AR_var(counter).ecoInputs, designSpace_100kW_WA_AR_var(counter).ecoOutputs] = evalDesignObjective(inputs);

    % Increment the counter
    counter = counter + 1;
  end
end

% Save design space results
save('outPutFiles/designSpace_100kW_WA_AR_var.mat','designSpace_100kW_WA_AR_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_AR_var.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'AR','', designSpace_100kW_WA_AR_var)


%% WA and b var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

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

    % Save parameter values
    designSpace_100kW_WA_b_var(counter).WA_value = WA_values(i);
    designSpace_100kW_WA_b_var(counter).b_value = b_values(j);

    % Evaluate design objective
    [designSpace_100kW_WA_b_var(counter).perfInputs, designSpace_100kW_WA_b_var(counter).perfOutputs, designSpace_100kW_WA_b_var(counter).ecoInputs, designSpace_100kW_WA_b_var(counter).ecoOutputs] = evalDesignObjective(inputs);

    % Increment the counter
    counter = counter + 1;
  end
end

% Save design space results
save('outPutFiles/designSpace_100kW_WA_b_var.mat','designSpace_100kW_WA_b_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_WA_b_var.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'b','m', designSpace_100kW_WA_b_var)


%% Ft_max and sigma_t_max var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define the range for Ft_max and sigma_t_max
Ft_guess           = 4*mean(inputs.S)*1000; % N
Ft_max_values      = [Ft_guess*0.5, Ft_guess*0.75, Ft_guess, Ft_guess*1.5]; % N
sigma_t_max_values = [3e8,4e8,5e8,6e8,7e8]; % Pa

% Initialize a counter for storing results
counter = 1;

% Loop over each Ft_max value
for i = 1:length(Ft_max_values)
  % Loop over each sigma_t_max value
  for j = 1:length(sigma_t_max_values)

    % Set Ft_max and sigma_t_max
    inputs.Ft_max = Ft_max_values(i);
    inputs.Te_matStrength = sigma_t_max_values(j);

    % Save parameter values
    designSpace_100kW_Ft_max_sigma_t_var(counter).Ft_max_value = Ft_max_values(i);
    designSpace_100kW_Ft_max_sigma_t_var(counter).sigma_t_value = sigma_t_max_values(j);

    % Evaluate design objective
    [designSpace_100kW_Ft_max_sigma_t_var(counter).perfInputs, designSpace_100kW_Ft_max_sigma_t_var(counter).perfOutputs, designSpace_100kW_Ft_max_sigma_t_var(counter).ecoInputs, designSpace_100kW_Ft_max_sigma_t_var(counter).ecoOutputs] = evalDesignObjective(inputs);

    % Increment the counter
    counter = counter + 1;
  end
end

% Save design space results
save('outPutFiles/designSpace_100kW_Ft_max_sigma_t_var.mat','designSpace_100kW_Ft_max_sigma_t_var');

% Load the saved design space results
load('outPutFiles/designSpace_100kW_Ft_max_sigma_t_var.mat');

% Plot
plotResults_two_param_variation('F_{t,max}', 'N', 'σ_{t,max}','Pa', designSpace_100kW_Ft_max_sigma_t_var)


%% WA and Ft_max var

% Load input file
clearvars
inputs = loadInputs('inputFile_100kW_awePower.yml');

% Define range for wing area and Ft_max
WA_values = [15, 20]; % Wing area values (m^2)

% Calculate Ft_max_values based on WA_values
Ft_guess = 4*mean(WA_values)*1000; % N
Ft_max_values = [Ft_guess*0.8, Ft_guess,Ft_guess*1.2]; % Range for Ft_max

% Initialize structure array to store design space results
designSpace_100kW_WA_Ft_var = struct([]);

% Initialize counter for storing results
counter = 1;

% Loop over each wing area value
for i = 1:length(WA_values)
  % Loop over each Ft_max value
  for j = 1:length(Ft_max_values)

    % Set wing area and Ft_max
    inputs.S = WA_values(i); % Wing area (m^2)
    inputs.Ft_max = Ft_max_values(j); % Maximum thrust (N)


    % Save parameter values
    designSpace_100kW_WA_Ft_var(counter).S_value = inputs.S;
    designSpace_100kW_WA_Ft_var(counter).Ft_max_value = inputs.Ft_max;

    % Evaluate design objective
    [designSpace_100kW_WA_Ft_var(counter).systemInputs, designSpace_100kW_WA_Ft_var(counter).perfOutputs, ...
      designSpace_100kW_WA_Ft_var(counter).ecoInputs, designSpace_100kW_WA_Ft_var(counter).ecoOutputs] = evalDesignObjective(inputs);

    % Increment counter
    counter = counter + 1;
  end
end

% Save design space results
save('outPutFiles/designSpace_100kW_WA_Ft_var.mat', 'designSpace_100kW_WA_Ft_var');

% Load saved design space results
load('outPutFiles/designSpace_100kW_WA_Ft_var.mat');

% Plot
plotResults_two_param_variation('WA', 'm^2', 'F_{t,max}', 'N', designSpace_100kW_WA_Ft_var);


