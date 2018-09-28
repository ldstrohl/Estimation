% 1-D Kalman Filter Example
% Lloyd Strohl
% 05/02/18
clear
close all

%% Define problem
A = 1;
u = 0; % input
H = 1; % relates state to measurement z = Hx + n, n = white noise of system
R = 0.2; % stdev of measurement noise, matrix of size(z)^2
t = [1:10];
V = [0.39 0.5 0.48 0.29 0.25 0.32 0.34 0.48 0.41 0.45];

% initial state
x = 0*t;
z = V;

x(1) = 0;
P = 1;

for k = t(2:end)
    xpred = x(k-1);
%     P = P; % Ppred = P(k-1)
    K = P/(P+R);
    x(k) = xpred + K*(z(k) - xpred);
    P = (1-K)*P;
end

plot(t,V,t,x)
legend('Measurement','Estimate','Location','Best')
