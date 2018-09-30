% testKF
% test case for Kalman Filter

A = [1,3;4,2];
B = [4;5];
H = [1,0;0,2];
R = diag([0.01,0.2]);
Q = zeros(size(A));

u = 3.2;
z = [2.4;9];
x0 = [0;6];
P0 = eye(size(A));

[x,P] = KF_Generic(A,B,H,Q,R,u,z,x0,P0);

fprintf('x1: %f\n',x(1))
fprintf('x2: %f\n',x(2))
