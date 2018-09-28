% Generic Kalman Filter Test (Rolling motion)
% Lloyd Strohl
% 05/03/18
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

A = [Lp*Ts+1,0;Ts,1];
B = [Ts*Lda;0];
H = eye(2);
P = eye(2);
Q = eye(2)*0;
R = [.02,0;0,.01];
z = [p';phi'];
x = z*0;
Lpk = x(1,:);
Ldak = Lpk;

for k = 2:length(p)
    [x(:,k),P] = KF_Generic(A,B,H,Q,R,da(k),z(:,k),x(:,k-1),P);
end
RMSE = mean((p-x(1,:)').^2);

tol = 0.002;
while RMSE > tol
    % Sys ID
    pest = x(1,:);
    pdot = [0,(pest(2:end) - pest(1:end-1)) / Ts]';
    
    L = lsqcurvefit(@objFun,[-1,1],[p,da],pdot);
    Lp = L(1);
    Lda = L(2);
    Lpk(k) = Lp;
    Ldak(k) = Lda;
    
    A = [Lp*Ts+1,0;Ts,1];
    B = [Ts*Lda;0];
    R = [.02,0;0,.01];
    z = [p';phi'];
    x = z*0;
    
    for k = 2:length(p)
        [x(:,k),P] = KF_Generic(A,B,H,Q,R,da(k),z(:,k),x(:,k-1),P);
    end
    RMSE = mean((p-x(1,:)').^2);
end

fprintf('RMSE: %.4f (rad/s)\n',RMSE)
fprintf('Lp: %.2f    Lda: %.2f\n',Lp,Lda)
figure('Name','Roll Rate')
plot(t,x(1,:),t,p)
title('Roll Rate')
figure('Name','Role Angle')
title('Roll Angle')
plot(t,x(2,:),t,phi)

