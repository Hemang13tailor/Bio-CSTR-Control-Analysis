clear all
clc

% Known parameters
xo(1) = -13.8197;  % Process Gain
xo(2) = 4.5441;   % Time Constant

% Load data
load result_stepchange.mat

% Validation (Step from 0.01 to 0.03, data from 400 to 480)
D_in2 = D_Data(400:480, 2);
X_plant2 = X_noisy1(400:480, 1);
t_data2 = t_DATA(400:480, 1);

X1_ss2 = X_plant2(1, 1);  % Initial steady-state temperature

% Model response for the second step change (0.01 -> 0.03)
for i = 1:1:length(t_data2)
    X1_model_response2(i,1) = X1_ss2 + xo(1)*(0.03 - 0.01)*(1 - exp(-(t_data2(i) - 400)./xo(2)));
end

% Plot the second validation
figure(2)
plot(1:size(X_plant2), X_plant2, 'b', 1:size(X_plant2), X1_model_response2, 'r');
xlabel("Time step","FontSize", 25)
ylabel("Cell Conc.(X1)","FontSize", 25)
grid on
legend('Plant Data (0.01 -> 0.03)', 'Model Response (0.01 -> 0.03)')
title('Model Validation for Step 0.01 to 0.03')

save validation_results_x1