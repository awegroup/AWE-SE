function [x_opt, fval, exitflag, optTime, all_x_0, all_x, all_fval] = findOptimalSystemDesign(inputs, lb,x0,ub,numStartPoints)

  options                           = optimoptions('fmincon', PlotFcn={'optimplotx', 'optimplotfirstorderopt', 'optimplotfval', 'optimplotstepsize'});
  options.Display                   = 'final-detailed';
  options.Algorithm                 = 'sqp';
  % options.Algorithm                 = 'interior-point';
  options.FiniteDifferenceType      = 'central';
  options.ScaleProblem              = true;
  % options.FiniteDifferenceStepSize  = 1e-3;
  options.OptimalityTolerance       = 1e-4;
  options.StepTolerance             = 1e-3;
  options.ConstraintTolerance       = 1e-1;

  % Create a problem structure
  problem = createOptimProblem('fmincon', ...
    'objective', @(x) objectiveFunction(x, inputs), ...
    'x0', x0, ...
    'lb', lb, ...
    'ub', ub, ...
    'nonlcon', @(x) nonlinearConstraints(inputs), ...
    'options', options);

  % Use MultiStart to run the optimization from multiple starting points
  ms = MultiStart('Display', 'iter', 'UseParallel', true, 'StartPointsToRun', 'bounds-ineqs');

  tic
  % Run the optimization with multiple starting points
  [x_opt, fval, exitflag, output, solutions] = run(ms, problem, numStartPoints); % Number of start points
  optTime = toc/60;

  % Store all starting points
  for i = 1:length(solutions)
    all_x_0(i,:) = cell2mat(solutions(1,i).X0);
    all_x(i,:) = solutions(1,i).X;
    all_fval(i) = solutions(1,i).Fval;
  end

end