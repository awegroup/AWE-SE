function [designSpace] = wingLoading_sigma_t_max_variation(WL_values, sigma_t_max_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);

  % Initialize a counter for storing results
  counter = 1;

  % Loop over each WL value
  for i = 1:length(WL_values)
    % Loop over each sigma_t_max value
    for j = 1:length(sigma_t_max_values)

      % Set WL and sigma_t_max
      inputs.Ft_max = WL_values(i)*inputs.S; % N
      inputs.Te_matStrength = sigma_t_max_values(j); % Pa

      % Save parameter values
      designSpace(counter).WL_value = WL_values(i);
      designSpace(counter).sigma_t_value = sigma_t_max_values(j);

      % Evaluate design objective
      [designSpace(counter).perfInputs, designSpace(counter).perfOutputs, designSpace(counter).ecoInputs, designSpace(counter).ecoOutputs] = evalDesignObjective(inputs);

      % Increment the counter
      counter = counter + 1;
    end
  end

end