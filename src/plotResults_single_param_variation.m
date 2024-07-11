function plotResults_single_param_variation(paramName, paramUnit, designSpace)

  % Initialize legend entries cell array
  for i = 1:length(designSpace)
    % Extract param values
    paramValues(i) = designSpace(i).paramValue;

    % Extract power curve data
    power(i).param = designSpace(i).perfOutputs.P_e_avg/1e6; % MW

    % Extract ICC and OMC
    cost(i).param  = (designSpace(i).ecoOutputs.metrics.ICC + designSpace(i).ecoOutputs.metrics.OMC * (length(designSpace(i).ecoOutputs.metrics.cashflow)-1))/1e6; % M Euros

    % Extract AEP
    AEP(i).param   = designSpace(i).ecoOutputs.metrics.AEP; % MWh

    % Extract LCoE
    LCoE(i).param = designSpace(i).ecoOutputs.metrics.LCoE; % EUR/MWh

    % Construct legend entry for this wing area
    legend_entries{i} = [paramName ' = ' num2str(paramValues(i)) paramUnit];

    % Extract LCoEs
    LCoE_values(i) = designSpace(i).ecoOutputs.metrics.LCoE;
  end

  % Find the optimal wing area that minimizes the LCoE
  [minLCoE, optIdx_param] = min(LCoE_values);
  optParam = paramValues(optIdx_param);

  % Create a larger figure
  figure('Position', [100, 100, 1200, 800]);

  % Top-left subplot for power curves
  subplot(2, 2, 1);
  hold on;
  grid on;
  xlabel('Wind Speed [m/s]');
  ylabel('Power [MW]');
  title(['Power Curves for different ' paramName]);
  for i = 1:length(designSpace)
    % Plot power curve
    plot([designSpace(i).perfInputs.vw_ref(1):designSpace(i).perfOutputs.vw_100m_operRange(end)], power(i).param, '-o', 'LineWidth', 1.5, 'MarkerSize', 2);
  end
  % Add legend with all entries
  legend(legend_entries, 'Location', 'Best');
  hold off;

  % Top-right subplot for LCoE vs Wing Area
  subplot(2, 2, 2);
  hold on;
  grid on;
  xlabel([paramName ' [' paramUnit ' ]']);
  ylabel('LCoE [€/MWh]');
  % ylim([150 200]);
  title(['LCoE vs ' paramName]);
  for i = 1:length(designSpace)
    % Plot AEP curve
    plot(paramValues(i), LCoE(i).param, 'x', 'LineWidth', 2, 'MarkerSize', 7);
  end
  % Add fit line for LCoE
  p = polyfit(paramValues, LCoE_values, 2);
  yfit = polyval(p, paramValues);
  plot(paramValues, yfit, '--', LineWidth=1.5);
  % Add legend to the plot
  legend(legend_entries, 'Location', 'Best');
  hold off;

  % Bottom-left subplot for AEP vs Parameter Values
  subplot(2, 2, 3);
  hold on;
  grid on;
  xlabel([paramName ' [' paramUnit ' ]']);
  ylabel('AEP [MWh]');
  title(['AEP vs ' paramName]);
  for i = 1:length(designSpace)
    % Plot AEP curve
    plot(paramValues(i), AEP(i).param, 'x', 'LineWidth', 2, 'MarkerSize', 7);
  end
  % Add fit line for AEP
  p = polyfit(paramValues, [AEP.param], 2);
  yfit = polyval(p, paramValues);
  plot(paramValues, yfit, '--', LineWidth=1.5);
  % Add legend with all entries
  legend(legend_entries, 'Location', 'Best');
  hold off;

  % Bottom-right subplot for Cost vs Parameter Values
  subplot(2, 2, 4);
  hold on;
  grid on;
  xlabel([paramName ' [' paramUnit ' ]']);
  ylabel('Cost [M€]');
  title(['Total costs vs ' paramName]);
  for i = 1:length(designSpace)
    % Plot cost curve
    plot(paramValues(i), cost(i).param, 'x', 'LineWidth', 2, 'MarkerSize', 7);
  end
  % Add fit line for cost
  p = polyfit(paramValues, [cost.param], 2);
  yfit = polyval(p, paramValues);
  plot(paramValues, yfit, '--', LineWidth=1.5);
  % Add legend with all entries
  legend(legend_entries, 'Location', 'Best');
  hold off;

  % Display results
  disp(['Optimized ' paramName ' [' paramUnit ']']);
  disp(optParam);

  disp('Minimum LCoE [€/MWh]:');
  disp(minLCoE);

end
