clear all
clc

% Initialize the initial conditions for cell concentration and substrate concentration
S_initial = 1.0;          % Substrate concentration
X_initial = 2.25;         % Cell concentration
noise_variance = 0.01 * X_initial; % Noise variance

global D;                 % Declare D (Dilution rate) as a global variable
X_INI = [X_initial, S_initial]; % Initial values for ODE solver
X_DATA = zeros(600, 2);   % Pre-allocate data array for storing results
D_Data = zeros(600, 2);   % Pre-allocate storage for iteration and corresponding D values
t_DATA = zeros(600, 1);   % Pre-allocate storage for time intervals

% Loop over 500 time steps and change D dynamically based on conditions
for i = 1:600
    if i >= 1 && i < 100
        M = 0 * 0.1;
        D = 0.1 + M;
    elseif i >= 100 && i < 200
        M = 0.2 * 0.1;
        D = 0.1 + M;
    elseif i >= 200 && i < 300
        M = 0.4 * 0.1;
        D = 0.1 + M;
    elseif i >= 300 && i < 400
        M = 0.1 * 0.1;
        D = 0.1 + M;
    elseif i >= 400 && i < 500
        M = 0.3 * 0.1;
        D = 0.1 + M;
    elseif i >= 500 && i < 600
        M = 0 * 0.1;
        D = 0.1;  % Final stage with base dilution rate
    end

    % Store the current value of D and the corresponding iteration number i
    D_Data(i, :) = [i, D];  % First column is iteration number i, second column is D
    t_DATA(i,1) = i;
    % Solve ODE using ode45 for the CSTR system
    [t, X] = ode45(@fun_file_CSTR2, [0 1], X_INI);
    X_INI = X(end, :);       % Update initial condition for next iteration
    X_DATA(i, :) = X(end, :); % Store results
end

% Add noise to the cell concentration (X) and substrate concentration (S)
rng('default');  % For reproducibility of random noise
X_noisy1 = X_DATA(:,1) + noise_variance * randn(size(X_DATA(:,1))); % Noisy cell concentration
X_noisy2 = X_DATA(:,2) + noise_variance * randn(size(X_DATA(:,2))); % Noisy substrate concentration

X_noisy=[X_noisy1,X_noisy2];
% Display the noisy data matrix
disp(X_noisy);

% Plotting the results using tiledlayout for better view
tiledlayout(3,1)

% Plot the cell concentration (x(1))
nexttile
plot(1:600, X_noisy1, 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Cell Concentration (x(1))', 'FontSize', 12)
title('Noisy Cell Concentration (x(1)) vs. Time', 'FontSize', 14)
grid on

% Plot the substrate concentration (x(2))
nexttile
plot(1:600, X_noisy2, 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Substrate Concentration (x(2))', 'FontSize', 12)
title('Noisy Substrate Concentration (x(2)) vs. Time', 'FontSize', 14)
grid on

% Plot the dilution rate (D)
nexttile
plot(D_Data(:, 1), D_Data(:, 2), 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Dilution Rate (D)', 'FontSize', 12)
title('Dilution Rate (D) vs. Time', 'FontSize', 14)
grid on

% Save the result stepchange data to a .mat file
save('result_stepchange.mat', 'X_noisy', 'X_DATA', 'X_noisy1', 'X_noisy2', 't_DATA', "D_Data")

disp('Data saved to result_stepchange.mat')