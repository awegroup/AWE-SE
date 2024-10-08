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
hold on
% set(gcf, 'Units', 'centimeters', 'Position', [4, 4, 10, 7]); 
box on;
for i = 1:length(designSpace)
    % Extract values for the current combination
    value1 = designSpace(i).(fieldNames{1});
    value2 = designSpace(i).(fieldNames{2});
    
    % Extract power curve
    P_e_avg = designSpace(i).perfOutputs.P_e_avg;
    
    % Generate a label for the legend
    label = sprintf('%s: %.1f (%s), %s: %.1f (%s)', name1, value1, unit1, name2, value2, unit2);
    
    % Plot the power curve
    plot(P_e_avg, 'DisplayName', label);
end
hold off;
xlabel('Wind speed (m/s)');
ylabel('Power (W)');
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
figure();
set(gcf, 'Units', 'centimeters', 'Position', [2, 2, 10, 7]); 
[values1_grid, values2_grid] = meshgrid(values1, values2);
contourf(values1_grid, values2_grid, LCoE'); 
% caxis([140 230]); % Set the color bar limits
% caxis([170 240]); % Set the color bar limits
colormap("turbo")
c = colorbar;
c.FontSize = 9;
c.Label.String = 'LCoE (€/MWh)';
xlabel(sprintf('%s (%s)', name1, unit1));
ylabel(sprintf('%s (%s)', name2, unit2));
% title('LCoE contours');

% Add contour labels
hold on;
[C, h] = contour(values1_grid, values2_grid, LCoE', 'LineColor', 'k');
clabel(C, h, 'FontSize', 8, 'Color', 'w');

% Find the minimum LCoE value and its corresponding indices
[min_LCoE, min_idx] = min(LCoE(:));
[optimal_idx1, optimal_idx2] = ind2sub(size(LCoE), min_idx);

% Extract the optimal values
optimal_value1 = values1(optimal_idx1);
optimal_value2 = values2(optimal_idx2);

% Mark the minimum LCoE value on the contour plot
hold on;
plot(values1(optimal_idx1), values2(optimal_idx2), 'wx', 'MarkerSize', 5, 'LineWidth', 1);
text(values1(optimal_idx1), values2(optimal_idx2), sprintf('%.0f', round(min_LCoE)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'w','FontSize', 10);
hold off

% Display the optimal combination
fprintf('Optimal %s: %.2f %s\n', name1, optimal_value1, unit1);
fprintf('Optimal %s: %.2f %s\n', name2, optimal_value2, unit2);
fprintf('Minimum LCoE: %.2f €/MWh\n', min_LCoE);

end
