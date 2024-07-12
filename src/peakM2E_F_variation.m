function [designSpace] = peakM2E_F_variation(peakM2E_F_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);

  % Loop over each sigma_t_max value
  for i = 1:length(peakM2E_F_values)
    inputs.peakM2E_F = peakM2E_F_values(i);

    % Save parameter values
    designSpace(i).paramValue   = peakM2E_F_values(i);

    % Evaluate design objective
    [designSpace(i).perfInputs, designSpace(i).perfOutputs, designSpace(i).ecoInputs, designSpace(i).ecoOutputs] = evalDesignObjective(inputs);

  end

end
