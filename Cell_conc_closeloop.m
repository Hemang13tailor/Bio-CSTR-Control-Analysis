clear all
clc

% Initialize the initial conditions for cell concentration and substrate concentration
S_initial = 1.0;          % Substrate concentration
X_initial = 2.25;         % Cell concentration
noise_variance = 0.02 * X_initial; % Noise variance

global D S_f;                 % Declare D (Dilution rate) as a global variable
X_INI = [X_initial, S_initial]; % Initial values for ODE solver
X_DATA = zeros(3000, 2);   % Pre-allocate data array for storing results
S_f_DATA = zeros(3000, 2);
D_DATA = zeros(3000, 2);   % Pre-allocate storage for iteration and corresponding D values
t_DATA = zeros(3000, 1);   % Pre-allocate storage for time intervals

% Loop over 500 time steps and change D dynamically based on conditions
for i = 1:3000
    D = 0.1;
    S_f = 10;
    % Store the current value of D and the corresponding iteration number i
    S_f_DATA(i, :) = [i, S_f];
    D_DATA(i, :) = [i, D];  % First column is iteration number i, second column is D
    t_DATA(i,1) = i;
    % Solve ODE using ode45 for the CSTR system
    [t, X] = ode45(@fun_file_CSTR3, [0 1], X_INI);
    X_INI = X(end, :);        % Update initial condition for next iteration
    X_DATA(i, :) = X(end, :); % Store results
end

% Add noise to the cell concentration (X) and substrate concentration (S)
rng('default');  % For reproducibility of random noise
X_ini1 = X_DATA(:,1) + 0*noise_variance * randn(size(X_DATA(:,1))); % Noisy cell concentration
X_ini2 = X_DATA(:,2) + 0*noise_variance * randn(size(X_DATA(:,2))); % Noisy substrate concentration

X_ini=[X_ini1,X_ini2];
% Display the noisy data matrix
%disp(X_noisy);

% Plotting the results using tiledlayout for better view
tiledlayout(4,1)

% Plot the cell concentration (x(1))
nexttile
plot(1:3000, X_ini1, 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Cell Concentration (x(1))', 'FontSize', 12)
title('Noisy Cell Concentration (x(1)) vs. Time', 'FontSize', 14)
grid on

% Plot the substrate concentration (x(2))
nexttile
plot(1:3000, X_ini2, 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Substrate Concentration (x(2))', 'FontSize', 12)
title('Noisy Substrate Concentration (x(2)) vs. Time', 'FontSize', 14)
grid on

% Plot the dilution rate (D)
nexttile
plot(D_DATA(:, 1), D_DATA(:, 2), 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Dilution Rate (D)', 'FontSize', 12)
title('Dilution Rate (D) vs. Time', 'FontSize', 14)
grid on

nexttile
plot(S_f_DATA(:, 1), S_f_DATA(:, 2), 'b', 'LineWidth', 1.5)
xlabel('Time Step', 'FontSize', 12)
ylabel('Feed Substrate Concentration (S_f)', 'FontSize', 12)
title('Feed Substrate Concentration (S_f) vs. Time', 'FontSize', 14)
grid on

% Define  identified model transfer function parameters 

Kp1 = -13.8197;
Kp2 = 26.4035;                     % Process gain 
Tau_P1 = 4.5441;
Tau_P2 = 4.3716;                  % Time constant 
Tau_D  = 0;                             % Time delay (if no time delay, keep it to zero)

Tau_cl1 = Tau_P1/2;                  % Tau_cl, time constant of closed loop, which is roughly taken as half of open loop time constant (thumb rule)
Tau_cl2 = Tau_P2/2;

X_ss1 = X_ini1(end,1);
X_ss2 = X_ini2(end,1);
X_ss = [X_ss1, X_ss2];


% Input for selection of servo (setpoint change) or regulatory problem (disturbance rejection)
Choice1 = input(' if choice is regulatory (enter 1), choice is servo problem (enter 2)');

D = 0.1;
S_f = 10;
D_ss = D;
y_sp = X_ss1;     % For initial time instant
D1 = 0.1;
D2 = 0.1;

for i = 1:1:500

% Storing of input values in a vector

D_vector(i,1) = D;
S_f_di(i,1) = S_f;

% Plant Simulation     
[t,X] = ode45(@fun_file_CSTR3,[0 1],X_ss ,[] ,D ,S_f );
X_DATA(i, 1) = X(end, 1);                % Saving the end value (i.e. sample time 1) of the integration. 
X_ss = X(end, :);
t_DATA(i,1) = i;
X_abc = X_DATA(i, 1);

y_m = X_abc;                                                                                     % Measurement of temperature at every 1 second


% Controller settings calculations obtained through direct synthesis method

K_c1 = (1/Kp1)*(Tau_P1/(Tau_cl1+Tau_D));            % Proportional gain

% Introducing disturbance / setpoint changes

if Choice1 == 1  % Regulatory Problem
                                                                                     % User specified disturbances introduced into the system
    if i<= 100

    S_f  = 10;                      % Inlet flowrate at initial time instant  (Disturbance variable constant)
    S_f_di(i, 1) = S_f;

    y_sp(i, 1) = y_sp(1, 1);     % system  is at initial setpoint (i.e. at steady state)

    elseif i > 100 && i<= 200 

    S_f  = 10.5;                      % Inlet flowrate at initial time instant  (Disturbance variable constant)   
    S_f_di(i, 1) = S_f;

    y_sp(i,1) = y_sp(1,1);     % system  is at initial setpoint (i.e. at steady state)
    
    elseif i > 200 && i<= 300 

    S_f  = 11.5;                      % Inlet flowrate at initial time instant  (Disturbance variable constant)   
    S_f_di(i, 1) = S_f;

    y_sp(i,1) = y_sp(1,1);     % system  is at initial setpoint (i.e. at steady state)
    
    elseif i > 300 && i<= 400 

    S_f  = 11;                      % Inlet flowrate at initial time instant  (Disturbance variable constant)   
    S_f_di(i, 1) = S_f;

    y_sp(i,1) = y_sp(1,1);     % system  is at initial setpoint (i.e. at steady state)

    elseif i > 400 && i<= 500 

    S_f  = 10;                      % Inlet flowrate at initial time instant  (Disturbance variable constant)   
    S_f_di(i, 1) = S_f;

    y_sp(i,1) = y_sp(1,1);     % system  is at initial setpoint (i.e. at steady state)

    end 

else % Choise1 = 2 (Servo Problem)

S_f_di(i,1) = S_f;
                                                                                                     % User specified setpoint changes
    if i <= 100

    y_sp(i, 1) = y_sp(1,1);                                     % system  is at initial steady state

    elseif i> 100 && i <= 200

    y_sp(i, 1) = y_sp(1,1) + 0.01*y_sp(1,1);                          % positive setpoint change of % from steady state value

    elseif i> 200 && i <= 300

    y_sp(i,1) = y_sp(200,1) + 0.005* y_sp(200, 1);  % positive setpoint change of % from steady state value
    
    elseif i> 300 && i <= 400

    y_sp(i,1) = y_sp(300,1) - 0.01* y_sp(300, 1);  % positive setpoint change of % from steady state value

    elseif i> 400 && i <= 500

    y_sp(i,1) = y_sp(400,1) + 0.005* y_sp(400, 1);  % positive setpoint change of % from steady state value

    end

end

% Choice of selection of controllers (P, PI, PID)

% Input signal calculation through proportional controller
 
error(i,1) = y_sp(i,1) - y_m;

D = D_ss + K_c1*error(i,1);


figure(2)

subplot(3,1,1), plot(t_DATA(1:i,1),X_DATA(1:i,1),'b',t_DATA(1:i,1),y_sp(1:i,1),'r'), xlabel('Time'), ylabel('Cell Concentration (X)') % legend('Controlled variable', 'Setpoint variable')

subplot(3,1,2), plot(t_DATA(1:i,1),D_vector(1:i,1),'b'), xlabel('Time'), ylabel('Manipulated variable (D)')

subplot(3,1,3), plot(t_DATA(1:i,1),S_f_di(1:i,1),'b'), xlabel('Time'), ylabel('Disturbance variable (S_f)')

end
