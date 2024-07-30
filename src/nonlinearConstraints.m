function [c, ceq] = nonlinearConstraints(inputs)

    global perfOutputs

    % Define inequality constraints (c <= 0) if any
    c = [];

    % Define equality constraints (ceq = 0)
    ceq = perfOutputs.ratedPower - inputs.P_ratedElec;
end