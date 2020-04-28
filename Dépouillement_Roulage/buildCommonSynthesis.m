% This script gather "Common" synthesis values
header = 1;
currCommonSynthesis = {};
%% Detection syst : FrCam and/or Fusion
headerName  = 'Detection Syst.';
valCam      = 'ZF FrCam';
valFus      = 'RSA Fusion';
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% ADAS Function : 1-LCA / 2-LKA / 3-Open Loop
headerName  = 'ADAS Function';
valCam      = adasFunctionName;
valFus      = adasFunctionName;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Analysis Type : 0-Vehicle / 1-Resimulation
headerName  = 'Analysis Type';
valCam      = analysisType;
valFus      = analysisType;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Vehicle ID
headerName  = 'Vehicle ID';
valCam      = vehicleID;
valFus      = vehicleID;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Detection SW
headerName  = 'Detection SW';
valCam      = FrCamSW;
valFus      = FusionSW;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% ADAS SW
headerName  = 'ADAS SW';
valCam      = adasSW;
valFus      = adasSW;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% CANape file name
headerName  = 'CANape File Name';
valCam      = canFile;
valFus      = canFile;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Context video file name
headerName  = 'Context Video File Name';
valCam      = contextVideoFile;
valFus      = contextVideoFile;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Date
headerName  = 'Date';
valCam      = date;
valFus      = date;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Track
headerName  = 'Track';
valCam      = trackPortion;
valFus      = trackPortion;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Traffic conditions
headerName  = 'Traffic conditions';
valCam      = trafficConditions;
valFus      = trafficConditions;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Test Type
headerName  = 'Test Type';
valCam      = testType;
valFus      = testType;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Velocity
headerName  = 'Velocity (km/h)';
valCam      = velocityMean;
valFus      = velocityMean;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Distance
headerName  = 'Distance (km)';
valCam      = distance;
valFus      = distance;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Duration
headerName  = 'Duration (min)';
valCam      = duration;
valFus      = duration;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Challenging Situation
headerName  = 'Challenging Situation';
valCam      = challengingSituation;
valFus      = challengingSituation;
currCommonSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Add all common Synthesis
if ~exist('commonSynthesis','var')
    commonSynthesis = currCommonSynthesis;
else
    commonSynthesis = [commonSynthesis;currCommonSynthesis(2:end,:)];
end