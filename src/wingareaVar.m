function [designSpace] = wingareaVar(WA_values, inputs, name)

  % Loop over each wing area value
  for i = 1:length(WA_values)

    inputs.S      = WA_values(i);
    inputs.Ft_max = 4*inputs.S*1000; %[N]

    % Save parameter values
    designSpace(i).paramValue = WA_values(i);

    % Evaluate design objective
    [designSpace(i).perfInputs, designSpace(i).perfOutputs, designSpace(i).ecoInputs, designSpace(i).ecoOutputs] = evalDesignObjective(inputs);
  end

  % Save design space results
  save(['outPutFiles/' name '.mat'],'designSpace');

end