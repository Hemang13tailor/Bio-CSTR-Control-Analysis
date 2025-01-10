function y = fun_file_CSTR3(t, X, D, S_f)
    
    global D S_f;
    % Parameters for the CSTR system
    Y_XS = 0.5;            % Yield coefficient

    % System equations
    % y_1: rate of change of cell concentration (x1 = dX/dt)
    % y_2: rate of change of substrate concentration (x2 = dS/dt)
    y_1 = X(1)*(0.2 * X(2)) / (1 + X(2)) - D * X(1);
    y_2 = -((0.2 * X(2)) / (1 + X(2)) * X(1) / Y_XS) + D * (S_f - X(2));

    y = [y_1; y_2];  % Return both differential equations
end
