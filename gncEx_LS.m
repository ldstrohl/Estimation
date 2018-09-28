% R2AIR GNC Exercise
% Lloyd Strohl
% 04/28/18
% Performs system ID of roll dynamics data
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

%% linear least-squares fitting
delay = 10*Ts;

L = lsqcurvefit(@objFun,[-1,1],[p(1+delay/Ts:end),da(1:end-delay/Ts)],pdot(1+delay/Ts:end));
Lp = L(1);
Lda = L(2);

% filter experimental data for comparison
pFil = lpf(p,.25);
pdotFit = (Lp*pFil + Lda*da);

%% simulation
% downsample
samplerate = 1;
dt = Ts/samplerate;
% initial condition
pSim = zeros(length(p)*samplerate,1);
pdotSim = zeros(length(pdot)*samplerate,1);

for k = (1+delay/Ts):length(pSim)-1
    pSim(k+1) = RK4(@EOM,pSim(k),[Lp,Lda,da(k-delay/Ts)],dt); 
    pdotSim(k+1) = Lp*pSim(k) + Lda*da(k);
    pdotSim(k+1) = (pSim(k+1)-pSim(k))/dt;

end    


%% Results
figure
plot(t,pdot,t(1:1/samplerate:end),pdotSim)
xlabel('Time (s)')
ylabel('Angle Rate (rad/s)')
% title('System Response to Aileron Deflection')
legend('Experimental Angle Rate','Modeled Angle Rate')
set(gcf, 'Position',[200,300,800,300])
% thesis_fig(gcf,'angleRate_lag') % my own figure formatting utility

figure
plot(t,p,t(1:1/samplerate:end),pSim)
ylabel('Angle (rad)')
xlabel('Time (s)')

% title('System Response to Aileron Deflection')
legend('Experimental Angle','Modeled Angle','Location','Best')
set(gcf, 'Position',[200,300,800,300])
% thesis_fig(gcf,'angle_lag') % my own figure formatting utility

% MSE = immse(pdot,pdotSim);
MSE = mean((pdot-pdotSim).^2); % or use immse

fprintf('Mean Square Error: %.4f (rad/s)\n',MSE)
fprintf('Lp: %.4f    Lda: %.4f\n',Lp,Lda)
