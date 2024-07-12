function [designSpace] = peakM2E_F_P_rated_variation(peakM2E_F_values, P_rated_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);

   % Initialize a counter for storing results
  counter = 1;

  % Loop over each peakM2E_F value
  for i = 1:length(peakM2E_F_values)

    % Loop over each P_rated value
    for j = 1:length(P_rated_values)

      % Set peakM2E_F and P_rated
      inputs.peakM2E_F   = peakM2E_F_values(i); % 
      inputs.P_ratedElec = P_rated_values(j); % W

      % Save parameter values
      designSpace(counter).peakM2E_F_value = peakM2E_F_values(i);
      designSpace(counter).P_rated_value   = P_rated_values(j);

      % Evaluate design objective
      [designSpace(counter).perfInputs, designSpace(counter).perfOutputs, designSpace(counter).ecoInputs, designSpace(counter).ecoOutputs] = evalDesignObjective(inputs);

      % Increment the counter
      counter = counter + 1;
    end
  end



end