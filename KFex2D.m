% 2-D Kalman Filter Example
% Lloyd Strohl
% 05/02/18
clear
close all

% data read
data = csvread('roll_data_test.csv');
p = data(:,1);
pdot = data(:,2);
da = data(:,3);
Ts = .01; % sample time (100 Hz)
t = [Ts:Ts:length(p)*Ts];

%% Define problem
% model: x1 = pdot
%        x2 = p
%        u  = da
%        x1k1 = (Lp*x2 + Lda * u)*dt + x1
%        x2k1 = (x1)*dt + x2
%        Y = H*x + Z; H = eye(2);
Lp = -9;
Lda = 116;
A = [Lp 0;1 0];
B = [Lda;0];
u = da; % input
H = eye(2); % relates state to measurement z = Hx + n, n = white noise of system
R = [0.01,0;0,0.02]; % stdev of measurement noise, matrix of size(z)^2
x = zeroes(2,length(t));
z = [pdot';p'];

% initial state
x(:,1) = 0;
P = eye(2);

for k = t(2:end)
    xpred = A*;
%     P = P; % Ppred = P(k-1)
    K = P/(P+R);
    x(k) = xpred + K*(z(k) - xpred);
    P = (1-K)*P;
end

plot(t,V,t,x)
legend('Measurement','Estimate','Location','Best')
