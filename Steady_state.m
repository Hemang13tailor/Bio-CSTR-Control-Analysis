
clear all
clc

% Initialize the initial conditions for cell concentration and substrate concentration
S_initial = 1.0;          % Substrate concentration
X_initial = 2.25;         % Cell concentration

X_INI = [X_initial, S_initial]; % Initial values for ODE solver
X_DATA = zeros(200, 2);   % Pre-allocate data array for storing results

% Solve ODE for 200 time steps
for i = 1:200
    % Solve ODE using ode45 for the CSTR system
    [t, X] = ode45(@fun_file_CSTR1, [0 1], X_INI);
    X_INI = X(end, :);       % Update initial condition for next iteration
    X_DATA(i, :) = X(end, :); % Store results
end

% Display X_DATA values
disp(X_DATA);

% Plotting the results using tiledlayout for better view
tiledlayout(2,1)

% Plot the cell concentration (x(1))
nexttile
plot(1:200, X_DATA(:, 1), 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Cell Conc (x(1))', 'FontSize', 12)
title('Cell Conc (x(1)) vs. Time', 'FontSize', 14)
grid on

% Plot the substrate concentration (x(2))
nexttile
plot(1:200, X_DATA(:, 2), 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Substrate Conc (x(2))', 'FontSize', 12)
title('Substrate Conc (x(2)) vs. Time', 'FontSize', 14)
grid on
