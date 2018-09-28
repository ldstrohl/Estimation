% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter Estimation
% EKF
% Lloyd Strohl
% 09/05/18
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

% data read
data = csvread('roll_data_test.csv');
phi = data(:,1);
p = data(:,2);
da = data(:,3);
Ts = .01; % sample time (100 Hz)
t = [Ts:Ts:length(p)*Ts];

figure('Name','Data')
plot(t,phi,t,p,t,da)
legend('Angle','Rate','Aileron Deflection')

%% Kalman Filter

% model
Lp = -10;
Lda = 20;

f = @RollMotionSE; % state transition function
h = @RollMotionMeas; % measurement function
J = @jaccsd;
P = eye(4); % prediction error estimate
Q = [0 0 0    0   ;...
     0 0 0    0   ;...
     0 0 0.0 0   ;...
     0 0 0    0.0];% process noise covariance
R = [.02,0;0,.01]; % measurement noise covariance
z = [phi';p']; % observations
x = zeros(4,size(phi,1))*0; % state estimate
x(:,1) = [0;0;Lp;Lda];


for k = 2:length(p)
    [x(:,k),P] = EKF_Generic(f,h,J,R,Q,z(:,k-1),x(:,k-1),da(k-1),P,Ts);
end





RMSE = mean((p-x(2,:)').^2);

estLp = x(3,end);
estLda = x(4,end);

fprintf('RMSE: %.4f (rad/s)\n',RMSE)
fprintf('Lp: %.2f    Lda: %.2f\n',estLp,estLda)
figure('Name','Roll Rate')
title('Roll Rate')
plot(t,x(2,:),t,p)
legend('Estimate','Measured')

figure('Name','Role Angle')
title('Roll Angle')
plot(t,x(1,:),t,phi)
legend('Estimate','Measured')

figure('Name','Parameters')
title('Parameters')
plot(t,x(3,:),t,x(4,:))
legend('Lp','Lda')

