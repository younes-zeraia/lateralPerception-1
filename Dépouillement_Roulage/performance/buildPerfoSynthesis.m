% This script gather "Performance" synthesis values
header = 1;
perfoSynthesis = {};

%% Offset Error 
% Overall
headerName  = 'Offset Error';
valCam      = (offsetResultsCamLeft.overall.meanError + offsetResultsCamRight.overall.meanError)/2;
valFus      = (offsetResultsFusLeft.overall.meanError + offsetResultsFusRight.overall.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Curve
headerName  = 'Offset Error C';
valCam      = (offsetResultsCamLeft.curve.meanError + offsetResultsCamRight.curve.meanError)/2;
valFus      = (offsetResultsFusLeft.curve.meanError + offsetResultsFusRight.curve.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Straight Line
headerName  = 'Offset Error SL';
valCam      = (offsetResultsCamLeft.straight.meanError + offsetResultsCamRight.straight.meanError)/2;
valFus      = (offsetResultsFusLeft.straight.meanError + offsetResultsFusRight.straight.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Yaw Angle
% Overall
headerName  = 'Yaw Angle Error';
valCam      = (yawAngleResultsCamLeft.overall.meanError + yawAngleResultsCamRight.overall.meanError)/2;
valFus      = (yawAngleResultsFusLeft.overall.meanError + yawAngleResultsFusRight.overall.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Curve
headerName  = 'Yaw Angle Error C';
valCam      = (yawAngleResultsCamLeft.curve.meanError + yawAngleResultsCamRight.curve.meanError)/2;
valFus      = (yawAngleResultsFusLeft.curve.meanError + yawAngleResultsFusRight.curve.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Straight Line
headerName  = 'Yaw Angle Error SL';
valCam      = (yawAngleResultsCamLeft.straight.meanError + yawAngleResultsCamRight.straight.meanError)/2;
valFus      = (yawAngleResultsFusLeft.straight.meanError + yawAngleResultsFusRight.straight.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Curvature
% Error
headerName  = 'Curvature Error';
valCam      = (mean(leftTurns.curvatureError1) + mean(rightTurns.curvatureError1))/2;
valFus      = (mean(leftTurns.curvatureError2) + mean(rightTurns.curvatureError2))/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Overshoot
headerName  = 'Curvature Mean OS';
valCam      = (mean(leftTurns.curvatureOvershoot1) + mean(rightTurns.curvatureOvershoot1))/2;
valFus      = (mean(leftTurns.curvatureOvershoot2) + mean(rightTurns.curvatureOvershoot2))/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Undershoot
headerName  = 'Curvature Mean US';
valCam      = (mean(leftTurns.curvatureUndershoot1) + mean(rightTurns.curvatureUndershoot1))/2;
valFus      = (mean(leftTurns.curvatureUndershoot2) + mean(rightTurns.curvatureUndershoot2))/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Projected Position
% Overall
headerName  = 'Proj. Pos. Error';
valCam      = (projOffsetResultsCamLeft.overall.meanError + projOffsetResultsCamRight.overall.meanError)/2;
valFus      = (projOffsetResultsFusLeft.overall.meanError + projOffsetResultsFusRight.overall.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Curve
headerName  = 'Proj. Pos. Error C';
valCam      = (projOffsetResultsCamLeft.curve.meanError + projOffsetResultsCamRight.curve.meanError)/2;
valFus      = (projOffsetResultsFusLeft.curve.meanError + projOffsetResultsFusRight.curve.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Straight Line
headerName  = 'Proj. Pos. Error SL';
valCam      = (projOffsetResultsCamLeft.straight.meanError + projOffsetResultsCamRight.straight.meanError)/2;
valFus      = (projOffsetResultsFusLeft.straight.meanError + projOffsetResultsFusRight.straight.meanError)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Projected LaneWidth
% Overall
headerName  = 'LaneWidth Error';
valCam      = projLaneWidthResultsCam.overall.meanError;
valFus      = projLaneWidthResultsFus.overall.meanError;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Curve
headerName  = 'LaneWidth Error C';
valCam      = projLaneWidthResultsCam.curve.meanError;
valFus      = projLaneWidthResultsFus.curve.meanError;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Straight Line
headerName  = 'LaneWidth Error SL';
valCam      = projLaneWidthResultsCam.straight.meanError;
valFus      = projLaneWidthResultsFus.straight.meanError;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% ViewRange
% Overall
headerName  = 'ViewRange Average';
valCam      = (viewRangeResultsCamLeft.overall+viewRangeResultsCamRight.overall)/2;
valFus      = (viewRangeResultsFusLeft.overall+viewRangeResultsFusRight.overall)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Curve
headerName  = 'ViewRange Average C';
valCam      = (viewRangeResultsCamLeft.curve+viewRangeResultsCamRight.curve)/2;;
valFus      = (viewRangeResultsFusLeft.curve+viewRangeResultsFusRight.curve)/2;;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Straight Line
headerName  = 'ViewRange Average SL';
valCam      = (viewRangeResultsCamLeft.straight+viewRangeResultsCamRight.straight)/2;;
valFus      = (viewRangeResultsFusLeft.straight+viewRangeResultsFusRight.straight)/2;;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Quality
% Overall
headerName  = 'Quality Ratio';
valCam      = (qualityResultsCamLeft.overall+qualityResultsCamRight.overall)/2;
valFus      = (qualityResultsFusLeft.overall+qualityResultsFusRight.overall)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Curve
headerName  = 'Quality Ratio C';
valCam      = (qualityResultsCamLeft.curve+qualityResultsCamRight.curve)/2;
valFus      = (qualityResultsFusLeft.curve+qualityResultsFusRight.curve)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Straight Line
headerName  = 'Quality Ratio SL';
valCam      = (qualityResultsCamLeft.straight+qualityResultsCamRight.straight)/2;
valFus      = (qualityResultsFusLeft.straight+qualityResultsFusRight.straight)/2;
perfoSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;