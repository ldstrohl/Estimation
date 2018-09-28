%% Rolling motion runscript
clear
close all

%% sim settings
runtime = 20;
Lda = 12;
Lp = -12;

%% Input
uamp = 1;
ufreq = 1; % rad/s

%% PID
Kp = 10;
% Kd = 10;
% Ki = 10;
Ti = 1000000;
Td = 0;

sim('rolling_motion')