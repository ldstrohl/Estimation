
% Parameter Estimation: Basal Metabolic Rate model estimation with
% Extended Kalman Filtering of asyncronous calorie and weight data
% Lloyd Strohl III
% 09/24/18
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
clc

%% tool input
saveFigs = 0;

%% Configuration
if saveFigs
    fprintf('Saving Figures...\n')
end
options = [saveFigs];

%% Data Read
weightDir = '';
weightFile = 'WeightExport.csv';
calDir = '';
calFile = 'CalorieExport.csv';
[weightTime,bodyweight,calDate,kcals] = DataRead(weightDir,weightFile,calDir,calFile,options);

%% EKF with asynchronous measurements
% method:
%   1. define state model
%   2. define sensor models, including no measurements
%   3. update state estimate per day, defining sensor model per available
%       data, until no more measurements are available
%       a. define 4 sensor models:
%           i. Calories and weight
%           ii. Calories
%           iii. weight
%           iv. no measurement
%       b. determine which model to use by seeing if each sensor contains a
%           measurement for this date. 
%       c. step through dates, starting with first measurement and calling
%           EKF_Generic with appropriate sensor model

% state model
f = @BmrSE;
% sensor models
h.both = @(x,u) [x(1);x(2)];
h.weight = @(x,u) x(1);
h.cal = @(x,u) x(2);
h.none = @(x,u) 0;
h.current = h.both;
sensors = [0;0]; % [weight;calories]
weightVar = 0.01;
calVar = .1;

% sim setup
J = @jaccsd;
startDay = min(calDate(1),weightTime(1));
endDay = max(calDate(end),weightTime(end));
dt = 1; % new estimate each day
x0 = [bodyweight(1);kcals(1);2060;500];
x = x0*ones(1,endDay-startDay+1);
P = eye(size(x0,1));
Q = diag([0,0,0.1,0]); % process noise

weightIndex = 1;
calIndex = 1;
% EKF loop
for k = 1:(endDay-startDay+1)
    day = startDay+k-1;
    
    % select sensor model
    sensors = [0;0];
    if weightIndex <= length(weightTime)
        sensors(1) = (weightTime(weightIndex) == day);
    end
    if calIndex <= length(calDate)
        sensors(2) = (calDate(calIndex) == day);
    end
    
    if sensors(1) && sensors(2)
        h.current = h.both;
        z = [bodyweight(weightIndex);kcals(calIndex)];
        R = diag([weightVar;calVar]); 
        weightIndex = weightIndex + 1;
        calIndex = calIndex + 1;
        updateFlag = 1;
    elseif sensors(2)
        h.current = h.cal;
        z = kcals(calIndex);
        R = calVar;
        calIndex = calIndex + 1;
        updateFlag = 1;
    elseif sensors(1)
        h.current = h.weight;
        z = bodyweight(weightIndex);
        R = weightVar;
        weightIndex = weightIndex + 1;
        updateFlag = 1;
    else
        h.current = h.none;
        z = 0;
        R = 1;
        updateFlag = 0;
    end
    
    % update state estimate
    [x(:,k+1),P] = ...
        EKF_Generic(f,h.current,J,R,Q,z,x(:,k),0,P,dt,updateFlag);
    
    
end

% Visualize
figure('Name','Weight')
title('Weight')
plot(x(1,:))
xlabel('Days')
ylabel('Pounds')

figure('Name','Eaten')
title('Daily Consumption')
plot(x(2,:))
xlabel('Days')
ylabel('kcals')

figure('Name','BMR')
title('Basal Metabolic Rate')
plot(x(3,:))
xlabel('Days')
ylabel('kcals')

figure('Name','kcals/lbs')
title('kcal/pound constant estimate')
plot(x(4,:))
xlabel('Day')
ylabel('kcals')