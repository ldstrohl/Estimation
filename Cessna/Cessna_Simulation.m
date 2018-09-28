% Cessna longitudinal simulation
% Sim settings
clear
close all
g = 32.2;
W = 2650;
m = W/g;
S = 174;
c = 4.9;
J = 1346;
CL0 = 0.307;
CLa = 4.41; % rad^-1
CLel = 0.43; % rad^-1
CDM = 0.0223;
k = 0.0554;
CLDM = 0;
CM0R = 0.04;
CMaR = -0.613; % rad^-1
CMel = -1.122; % rad^-1
CMadot = -7.27; % rad^-1
CMq = -12.4; % rad^-1
CLadot = 1.7; % rad^-1
CLq = 3.9; % rad^-1

eta = 0;
eT = 0;
rho = 2.377*10^-3;
h0 = 5000;


simtime = 400;
V0 = 140;
alpha0 = 0;
theta0 = 0;
q0 = 0;

% GLIDE

x0 = [V0;alpha0;theta0;q0;0];
u0 = [0;0];
y0 = [];
ix = [];
iu= [1;2];
iy = [];
[x,u,y,dx] = trim('CessnaEoM2',x0,u0,y0,ix,iu,iy);
% [x,u,y,dx] = trim('CessnaEoM2',x0,u0,y0);
[A,B,C,D] = linmod('CessnaEoM2',x);


% lqr controller
Q = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
R = [1,0;0,1];
refState = x(1:4);
% [K,~,~] = lqr(A,B,Q,R);
K = zeros(2,4);
sim('CessnaSim')