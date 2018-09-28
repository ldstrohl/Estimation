% Data read in for EKF_BMR from calories and bodyweight spreadsheets
function [weightTime,bodyweight,calDate,kcals] = DataRead(weightDir,weightFile,calDir,calFile,options)
% Inputs
%   weightDir: directory containing bodyweight file
%   weightFile: filename of bodyweight data
%   calDir:    directory containing calorie file
%   calFile:   filename of calorie data
%   options:   adds flexibility, currently unused

%% read bodyweight csv
[bodyweight,txt,~] = xlsread([weightDir weightFile]);
% parse awkward timestamp
datetimeStr = string(strtrim(txt(:,1)));

% timechar = datetimeStr(:,end-7:end);
% datechar = datetimeStr(:,1:end-11);
formatIn = 'mmm dd, yyyy HH:MMAM';
weightTimeRaw = zeros(size(datetimeStr));
for k = 1:size(datetimeStr,1)
    atPos = strfind(datetimeStr{k},'at');
    weightTimeRaw(k) = ...
        floor(datenum([datetimeStr{k}(1:atPos-1) datetimeStr{k}(end-6:end)],formatIn));
end

% reduce to "first of the day" weigh-ins
j = 2;
weightTime = weightTimeRaw;
for k = 2:length(weightTimeRaw)
    if weightTimeRaw(k) ~= weightTime(j-1)
        weightTime(j) = weightTimeRaw(k);
        j = j + 1;
    end
end



% weightTime = datenum([datechar timechar],formatIn); % MATLAB serial

%% read calorie csv
% data has multiple entries per day. Relevant entry is last each day.
[kcalsAll,txt,~] = xlsread([calDir calFile]);
% parse awkward timestamp
formatIn = 'ddd mmm dd yyyy';
calDate = datenum(txt(:,1),formatIn);

% reduce data to final entry per day
lastIndex = zeros(floor(max(calDate)-min(calDate))+1,1);
j = 1;
for k = 1:length(kcalsAll)-1
    if floor(calDate(k+1)) > floor(calDate(k))
        lastIndex(j) = k;
        j = j + 1;
    end
end
lastIndex(end) = length(kcalsAll);
lastIndex = lastIndex(lastIndex~=0);
kcals = kcalsAll(lastIndex);
calDate = calDate(lastIndex);






end

