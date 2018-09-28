function [thetaEst,PRLS] = RecursiveLeastSquares(thetaEst,PRLS,psi,y)
% Recursive Least-Squares Algorithm
thetaEst = thetaEst + PRLS*psi/(1+psi'*PRLS*psi)...
    * (y-psi'*thetaEst);
PRLS = PRLS - PRLS*(psi*psi')...
    *PRLS/(1+psi'*PRLS*psi);
end

