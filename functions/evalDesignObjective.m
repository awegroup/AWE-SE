function [systemInputs, perfOutputs, ecoOutputs] = evalDesignObjective(inputs)

  % AWE-Power
  [~, ~, perfOutputs] = main_awePower(inputs);

  % AWE-Eco
  eco_inputs = eco_system_inputs_awePower(inputs, perfOutputs);
  [~, ~, ecoOutputs] = eco_main(eco_inputs);

  % Save inputs
  systemInputs = inputs;

end