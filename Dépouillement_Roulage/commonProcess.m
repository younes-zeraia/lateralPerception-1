% This script gather "Common" post-process operations applied to Lateral
% Perception logs

% ADAS function
switch adasFunction
    case 1
        adasFunctionName = 'LCA';
    case 2
        adasFunctionName = 'LKA';
    case 3
        adasFunctionName = 'Open Loop';
end

% Analysis type
if resim == 0
        analysisType = 'Vehicle';
else
        analysisType = 'Resim';
end

% FrCam SW / Fusion SW
indFrCamSW      = strfind(fileName(1:end-4),'_FRC');
indFusionSW     = strfind(fileName(1:end-4),'_RM');
indEvalFrCam    = strfind(fileName(1:end-4),'_EvalFRCam_');
if length(indFrCamSW)==1 && length(indFusionSW)==1 && length(indEvalFrCam)==1
    FrCamSW = strcat('SW',fileName(indFrCamSW+4:indFusionSW-1));
    FusionSW= strcat('RM',fileName(indFusionSW+3:indEvalFrCam-1));
end

% CANape FIle
canFile = fileName;

% File link


% Context Video
try
    contextVideoFiles = filesearch(fullfile(testPath,logsRawFolderName,contextVideoFolderName),'avi');
    timeIndicator     = fileName(find(fileName == '_',1,'last')+1:end-4);
    indContextVideo   = find(contains({contextVideoFiles.name},timeIndicator));
    if length(indContextVideo) == 1
        contextVideoFile  = contextVideoFiles(indContextVideo).name;
    else
        contextVideoFile  = '';
    end
catch ME
    ME.message
    contextVideoFile  = '';
end
    

% Date dd/mm/yyyy
if isfield(log,'Date')
    date = strcat(num2str(log.Date(1,3)),'/',num2str(log.Date(1,2)),'/',num2str(log.Date(1,1)));
elseif isfield(log,'day') && isfield(log,'month') && isfield(log,'year')
    date = [num2str(log.day(1,:)) '/' num2str(log.month(1,:)) '/' num2str(log.year(1,:))];
elseif length(indEvalFrCam)>0
    dateYMD = fileName(indEvalFrCam+11:indEvalFrCam+18);
    date = strcat(dateYMD(7:8),'/',dateYMD(5:6),'/',dateYMD(1:4));
else
    date = '';
end

% Traffic conditions
if isfield(log,'Traffic_Type')
    trafficType = mode(log.Traffic_Type);
    switch trafficType
        case 1
            trafficConditions = 'fluent';
        case 2
            trafficConditions = 'charged';
        case 3
            trafficConditions = 'jam';
    end
else
    trafficConditions   = '?';
end

% Velocity
velocitySignal = findVelocity(log);
velocityMean   = round(nanmean(velocitySignal));

% Distance
deltaT   = mean(diff(log.t));
distance = (nansum(velocitySignal)./3.6)*deltaT/1000;

% Duration
duration = (log.t(end) - log.t(1))/60;

% Challenging situation
challengingSituation = 'none'; % for the moment