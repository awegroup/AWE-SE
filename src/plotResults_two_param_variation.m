function plotResults_two_param_variation(name1, unit1, name2, unit2, designSpace)
% PLOTRESULTS_TWO_PARAM_VARIATION Plots results for two-parameter variation.
%   plotResults_two_param_variation(name1, unit1, name2, unit2, designSpace)
%   plots power curves and LCoE contours for two varying parameters from
%   the provided design space structure.

% Extract unique values for each parameter
fieldNames = fieldnames(designSpace);
values1 = unique([designSpace.(fieldNames{1})]);
values2 = unique([designSpace.(fieldNames{2})]);

% Number of values for each parameter
num_values1 = length(values1);
num_values2 = length(values2);

% Create a figure for power curves
figure;
hold on;
for i = 1:length(designSpace)
    % Extract values for the current combination
    value1 = designSpace(i).(fieldNames{1});
    value2 = designSpace(i).(fieldNames{2});
    
    % Extract power curve
    P_e_avg = designSpace(i).perfOutputs.P_e_avg;
    
    % Generate a label for the legend
    label = sprintf('%s: %.2f %s, %s: %.2f %s', name1, value1, unit1, name2, value2, unit2);
    
    % Plot the power curve
    plot(P_e_avg, 'DisplayName', label);
end
hold off;
xlabel('Wind speed (m/s)');
ylabel('Power (W)');
% title(sprintf('Power Curves for Different %s and %s Combinations', name1, name2));
legend('show');
grid on;

% Prepare data for LCoE contour plot
LCoE = zeros(num_values1, num_values2);
for i = 1:length(designSpace)
    % Find indices for the current combination
    idx1 = find(values1 == designSpace(i).(fieldNames{1}));
    idx2 = find(values2 == designSpace(i).(fieldNames{2}));
    
    % Extract LCoE value
    LCoE(idx1, idx2) = designSpace(i).ecoOutputs.metrics.LCoE;
end

% Create a figure for LCoE contours
figure;
[values1_grid, values2_grid] = meshgrid(values1, values2);
contourf(values1_grid, values2_grid, LCoE');
c = colorbar;
c.Label.String = 'LCoE (€/MWh)';
xlabel(sprintf('%s (%s)', name1, unit1));
ylabel(sprintf('%s (%s)', name2, unit2));
title('LCoE Contours');
grid on;

% Find the minimum LCoE value and its corresponding indices
[min_LCoE, min_idx] = min(LCoE(:));
[optimal_idx1, optimal_idx2] = ind2sub(size(LCoE), min_idx);

% Extract the optimal values
optimal_value1 = values1(optimal_idx1);
optimal_value2 = values2(optimal_idx2);

% Display the optimal combination
fprintf('Optimal %s: %.2f %s\n', name1, optimal_value1, unit1);
fprintf('Optimal %s: %.2f %s\n', name2, optimal_value2, unit2);
fprintf('Minimum LCoE: %.2f\n', min_LCoE);

end
