function [perfInputs, perfOutputs, ecoInputs, ecoOutputs] = evalDesignObjective(perfInputs)

  % AWE-Power
  [perfInputs, ~, ~, perfOutputs] = main_awePower(perfInputs);

  % AWE-Eco
  ecoInputs = eco_system_inputs_awePower(perfInputs, perfOutputs);
  [~, ~, ecoOutputs] = eco_main(ecoInputs);

end