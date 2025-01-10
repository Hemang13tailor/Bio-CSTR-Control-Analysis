function [fun_val] = x1_opt_fun2(xo)
    % Load the step response data
    load result_stepchange.mat

    % Simulated concentration data and time data (for range 200 to 280)
    X_plant = X_noisy1(200:280, 1);   % Plant data for the range
    t_data = t_DATA(200:280, 1);      % Time data for the range
    
    % Initial steady-state concentration
    X1_ss = X_plant(1, 1);

    % Model response for step change from 0.02 to 0.04
    X1_model_response = X1_ss + xo(1) * (0.04 - 0.02) * (1 - exp(-(t_data - 200)./xo(2)));

    % Calculate the error between plant data and model response
    err = X_plant - X1_model_response;
    
    % Sum of squared errors (objective function value)
    fun_val = sum(err.^2);
end