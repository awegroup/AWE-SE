function [designSpace] = wingArea_P_rated_variation(WA_values, P_rated_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);

  % Initialize counter for storing results
  counter = 1;

  % Loop over each wing area value
  for i = 1:length(WA_values)
    % Loop over each Ft_max value
    for j = 1:length(P_rated_values)

      % Update inputs
      inputs.S           = WA_values(i); % m^2
      inputs.Ft_max      = inputs.S * 3000; % N
      inputs.P_ratedElec = P_rated_values(j);

      % Save parameter values
      designSpace(counter).S_value  = inputs.S;
      designSpace(counter).P_rated_value = P_rated_values(j);

      % Evaluate design objective
      [designSpace(counter).perfInputs, designSpace(counter).perfOutputs, ...
        designSpace(counter).ecoInputs, designSpace(counter).ecoOutputs] = evalDesignObjective(inputs);

      % Increment counter
      counter = counter + 1;
    end
  end

end