clear all
clc

% Define bounds and initial guesses for Process Gain and Time Constant
Up_Bound = [10000 10000];   % Upper bounds on Process Gain and Time constant
Lo_Bound = [-1000 0];      % Lower bounds on Process Gain and Time constant
x_initial_guess = [0 5]; % Initial guess for optimization

% Set options for fmincon
options = optimset('Display','iter','TolX',10^-10,'TolFun', 10^-10);

% Perform optimization using fmincon to minimize the objective function 'optimfunc'
[optimal_x, fval, exitflag] = fmincon(@x1_opt_fun1, x_initial_guess, [], [], [], [], Lo_Bound, Up_Bound, [], options);

% Display the optimal values of Process Gain and Time Constant
disp('Optimal values after regression:');
disp('Process Gain:');
xo(1) = optimal_x(1)
disp('Time Constant:');
xo(2) = optimal_x(2)

% Save the identified model parameters
save Model_Identification_positive_step_x1(1) xo

% Optionally, you can pass these parameters to another function for further analysis
