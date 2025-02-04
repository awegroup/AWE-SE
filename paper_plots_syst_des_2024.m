%% Bending Fatigue:Cycles to failure

% Define parameters
sigma_t = linspace(0.2, 0.8, 100);  % Tether stress range in GPa
drum_ratios = [10, 20, 30, 100];    % Drum to tether diameter ratios
a1_values = [5.4, 5.8, 6.1, 6.5];   % Corresponding a1 values from the table
a2 = 2.6;                           % Constant a2

% Define line styles
line_styles = {':', '-.', '--', '-'};

% Initialize figure
figure;
hold on;

% Loop over drum ratios and plot N_b for each
for i = 1:length(drum_ratios)
    a1 = a1_values(i);
    % Calculate the number of cycles to failure for each sigma_t
    N_b = 10.^(a1 - a2 * sigma_t);
    % Plot the data
    plot(sigma_t, N_b, line_styles{i}, 'linewidth',1, 'DisplayName', ['d_{drum}/d_t = ', num2str(drum_ratios(i))]);
end

% Customize plot
xlabel('\sigma_t (GPa)');
ylabel('N_b (Cycles to failure)');
xlim([0.1 0.9]);
% title('Number of Cycles to Failure vs. Tether Stress for Different Drum Ratios');
legend show;
grid on;
box on
set(gca, 'YScale', 'log');  % Use logarithmic scale for y-axis
hold off;
