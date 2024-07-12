function [designSpace] = wingArea_aspectRatio_variation(WA_values, AR_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);

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
      inputs.Ft_max = inputs.S * 3000; %[N]

      % Save parameter values
      designSpace(counter).WA_value = WA_values(i);
      designSpace(counter).AR_value = AR_values(j);

      % Evaluate design objective
      [designSpace(counter).perfInputs, designSpace(counter).perfOutputs, designSpace(counter).ecoInputs, designSpace(counter).ecoOutputs] = evalDesignObjective(inputs);

      % Increment the counter
      counter = counter + 1;
    end
  end
end