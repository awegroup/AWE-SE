function [designSpace] = wingArea_variation(WA_values, inputs)

  % Initialize structure array to store design space results
  designSpace = struct([]);
  
  % Loop over each wing area value
  for i = 1:length(WA_values)

    inputs.S      = WA_values(i);
    
%     inputs.Ft_max = inputs.S*4000; %[N]
    inputs.Ft_max = mean(WA_values)*3000;

    % Save parameter values
    designSpace(i).paramValue = WA_values(i);

    % Evaluate design objective
    [designSpace(i).perfInputs, designSpace(i).perfOutputs, designSpace(i).ecoInputs, designSpace(i).ecoOutputs] = evalDesignObjective(inputs);
  end

end