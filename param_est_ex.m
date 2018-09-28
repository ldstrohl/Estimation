% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter Estimation
% Recursive Least Squares
% Lloyd Strohl
% 08/27/18
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
Lp = -50;
Lda = 70;

A = [Lp*Ts+1,0;Ts,1]; % state transition
B = [Ts*Lda;0]; % state transition contribution of control
C = eye(2); % y = C*x, relates state to observation
P = eye(2); % prediction error estimate
Q = eye(2)*0; % process noise covariance
R = [.02,0;0,.01]; % measurement noise covariance
z = [p';phi']; % observations
x = zeros(size(A,1),size(phi,1))*0; % state estimate

% RLS
pdot = 0*da;
PRLS = eye(size(x,1));
thetaEst = [Lp;Lda];
psi = [p';da'];

for k = 2:length(p)
    [x(:,k),P] = KF_Generic(A,B,C,Q,R,da(k),z(:,k),x(:,k-1),P);
    pdot(k) = (x(1,k)-x(1,k-1))/2;
    
%     [thetaEst,P] = KF_Generic(
    
%     % Recursive Least-Squares Parameter Estimation
    [thetaEst,PRLS] = RecursiveLeastSquares(thetaEst,PRLS,psi(:,k),pdot(k));
    A = [thetaEst(1)*Ts+1,0;Ts,1];
    B = [Ts*thetaEst(2);0];
end

RMSE = mean((p-x(1,:)').^2);




fprintf('RMSE: %.4f (rad/s)\n',RMSE)
fprintf('Lp: %.2f    Lda: %.2f\n',thetaEst(1),thetaEst(2))
figure('Name','Roll Rate')
title('Roll Rate')
plot(t,x(1,:),t,p)
legend('Estimate','Measured')

title('Roll Angle')
figure('Name','Role Angle')
title('Roll Angle')
plot(t,x(2,:),t,phi)
legend('Estimate','Measured')


