function [designSpace] = wingArea_wingLoading_variation(WA_values, WL_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);

  % Initialize counter for storing results
  counter = 1;

  % Loop over each wing area value
  for i = 1:length(WA_values)
    % Loop over each Ft_max value
    for j = 1:length(WL_values)

      % Set wing area and Ft_max
      inputs.S = WA_values(i); % m^2
      inputs.Ft_max = WL_values(j)*inputs.S; % N

      % Save parameter values
      designSpace(counter).S_value  = inputs.S;
      designSpace(counter).WL_value = WL_values(j);

      % Evaluate design objective
      [designSpace(counter).systemInputs, designSpace(counter).perfOutputs, ...
        designSpace(counter).ecoInputs, designSpace(counter).ecoOutputs] = evalDesignObjective(inputs);

      % Increment counter
      counter = counter + 1;
    end
  end
end