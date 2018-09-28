% Parameter Estimation Method Comparison
param_est_RLS;
param_est_EKF;
param_est_UKF;
param_est_Part;

close all

t = [0:size(params.RLS,2)-1];
figure('Name','Performance')
title('Estimator Performance Comparison')
plot(t,params.RLS,t,params.EKF)
legend('RLS_{Lp}','RLS_{Lda}','EKF_{Lp}','EKF_{Lda}')


