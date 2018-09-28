% Extended Kalman Filter
% Lloyd Strohl
% 09/06/18
% Filters data and returns state signal using extended Kalman filter
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,P] = EKF_Generic(f,h,J,R,Q,z,xprev,uprev,Pprev,dt,updateFlag)
if nargin < 11
    updateFlag = 1;
end

% Inputs
%   f: handle of nonlinear state equation function
%       takes state and input vectors, outputs derivative of state
%       xdot = f(x,u), nonlinear form of xdot = Ax+Bu
%   h: handle of nonlinear sensor model function
%       z = h(x,u)
%   J: handle of generalized Jacobian function (ex. finite diff)
%       should take state equation handle and operating point x
%   R: measurement noise covariance
%       dim(z) by dim(z)
%   Q: process noise covariance
%       dim(x) by dim(x)
%   z: measurement
%   xprev: previous estimate of state
%   uprev: previous control input
%   Pprev: previous estimate of state error
%   updateFlag: boolean, allows skipping of update step in the case where
%       no new measurements are available

% Outputs
%   x: current estimate of state
%   P: current estimate of state error

% Define state transition function in terms of state equation to allow
%   finite differencing of Jacobian. Similarly, define nonlinear 
%   output equation
fstar = @(x) f(x,uprev)*dt + x;
hstar = @(x) h(x,uprev);

% Predict 
[xpred,F] = J(fstar,xprev);  
[zpred,H] = J(hstar,xpred);
Ppred = F*Pprev*F' + Q; 

if updateFlag
    % Update
    S = H*Ppred*H' + R;
    K = Ppred*H'/S;
    x = xpred + K*(z-zpred);
    P = (eye(size(Ppred))-K*H)*Ppred;
else
    x = xpred;
    P = Ppred;
end



% Explanation
% Predict
    % predict next state using state transition function
    % predict measurement using state prediction
    % compute corresponding linearizations (Jacobians)
    % predict error
% Update
    % Compute Kalman gain
    % Apply gain to observed measurement error and add to predicted state
    % after transition
    % Update error as well


end

