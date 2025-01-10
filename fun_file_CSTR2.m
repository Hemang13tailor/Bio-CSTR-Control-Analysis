function y = fun_file_CSTR2(t, X)
    % Global variable for dynamically changing dilution rate (D)
    global D;
    
    % Parameters for the CSTR system
    Y_XS = 0.5;            % Yield coefficient
    S_f_initial = 10;      % Feed substrate concentration

    % System equations
    % y_1: rate of change of cell concentration (x1 = dX/dt)
    % y_2: rate of change of substrate concentration (x2 = dS/dt)
    y_1 = X(1)*(0.2 * X(2)) / (1 + X(2)) - D * X(1);
    y_2 = -((0.2 * X(2)) / (1 + X(2)) * X(1) / Y_XS) + D * (S_f_initial - X(2));

    y = [y_1; y_2];  % Return both differential equations
end
