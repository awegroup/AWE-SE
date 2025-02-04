function LCoE = objectiveFunction(x, inputs)

  global perfOutputs
  inputs.S                 = x(1);
  inputs.Ft_max            = x(2)*inputs.S;
  inputs.Te_matStrength    = x(3);
  inputs.AR                = x(4);
  inputs.crestFactor_power = x(5);

  [~, perfOutputs, ~, ecoOutputs] = evalDesignObjective(inputs);
  LCoE = ecoOutputs.metrics.LCoE;
end