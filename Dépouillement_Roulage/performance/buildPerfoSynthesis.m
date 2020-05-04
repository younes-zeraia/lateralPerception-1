% This script gather "Performance" synthesis values
header = 1;

[Headers valCam] = struct2CellArray(resultsCam);
[trash       valFus] = struct2CellArray(resultsFus);


if ~exist('perfoSynthesis','var')
    perfoSynthesis = [Headers;valCam;valFus];
else
    perfoSynthesis = [perfoSynthesis;valCam;valFus];
end

% %% Offset Error 
% % Overall
% Headers  = [Headers {'Offset Error'}];
% valCam      = [valCam {(offsetResultsCamLeft.overall.meanError + offsetResultsCamRight.overall.meanError)/2}];
% valFus      = [valFus {(offsetResultsFusLeft.overall.meanError + offsetResultsFusRight.overall.meanError)/2}];
% 
% % Curve
% Headers  = [Headers {'Offset Error C'}];
% valCam      = [valCam {(offsetResultsCamLeft.curve.meanError + offsetResultsCamRight.curve.meanError)/2}];
% valFus      = [valFus {(offsetResultsFusLeft.curve.meanError + offsetResultsFusRight.curve.meanError)/2}];
% 
% % Straight Line
% Headers  = [Headers {'Offset Error SL'}];
% valCam      = [valCam {(offsetResultsCamLeft.straight.meanError + offsetResultsCamRight.straight.meanError)/2}];
% valFus      = [valFus {(offsetResultsFusLeft.straight.meanError + offsetResultsFusRight.straight.meanError)/2}];
% 
% %% Yaw Angle
% % Overall
% Headers  = [Headers {'Yaw Angle Error'}];
% valCam      = [valCam {(yawAngleResultsCamLeft.overall.meanError + yawAngleResultsCamRight.overall.meanError)/2}];
% valFus      = [valFus {(yawAngleResultsFusLeft.overall.meanError + yawAngleResultsFusRight.overall.meanError)/2}];
% 
% % Curve
% Headers  = [Headers {'Yaw Angle Error C'}];
% valCam      = [valCam {(yawAngleResultsCamLeft.curve.meanError + yawAngleResultsCamRight.curve.meanError)/2}];
% valFus      = [valFus {(yawAngleResultsFusLeft.curve.meanError + yawAngleResultsFusRight.curve.meanError)/2}];
% 
% % Straight Line
% Headers  = [Headers {'Yaw Angle Error SL'}];
% valCam      = [valCam {(yawAngleResultsCamLeft.straight.meanError + yawAngleResultsCamRight.straight.meanError)/2}];
% valFus      = [valFus {(yawAngleResultsFusLeft.straight.meanError + yawAngleResultsFusRight.straight.meanError)/2}];
% 
% %% Curvature
% % Error
% Headers  = [Headers {'Curvature Error'}];
% valCam      = [valCam {(mean(leftTurns.curvatureError1) + mean(rightTurns.curvatureError1))/2}];
% valFus      = [valFus {(mean(leftTurns.curvatureError2) + mean(rightTurns.curvatureError2))/2}];
% 
% % Overshoot
% Headers  = [Headers {'Curvature Mean OS'}];
% valCam      = [valCam {(mean(leftTurns.curvatureOvershoot1) + mean(rightTurns.curvatureOvershoot1))/2}];
% valFus      = [valFus {(mean(leftTurns.curvatureOvershoot2) + mean(rightTurns.curvatureOvershoot2))/2}];
% 
% % Undershoot
% Headers  = [Headers {'Curvature Mean US'}];
% valCam      = [valCam {(mean(leftTurns.curvatureUndershoot1) + mean(rightTurns.curvatureUndershoot1))/2}];
% valFus      = [valFus {(mean(leftTurns.curvatureUndershoot2) + mean(rightTurns.curvatureUndershoot2))/2}];
% 
% %% Projected Position
% % Overall
% Headers  = [Headers {'Proj. Pos. Error'}];
% valCam      = [valCam {(projOffsetResultsCamLeft.overall.meanError + projOffsetResultsCamRight.overall.meanError)/2}];
% valFus      = [valFus {(projOffsetResultsFusLeft.overall.meanError + projOffsetResultsFusRight.overall.meanError)/2}];
% 
% % Curve
% Headers  = [Headers {'Proj. Pos. Error C'}];
% valCam      = [valCam {(projOffsetResultsCamLeft.curve.meanError + projOffsetResultsCamRight.curve.meanError)/2}];
% valFus      = [valFus {(projOffsetResultsFusLeft.curve.meanError + projOffsetResultsFusRight.curve.meanError)/2}];
% 
% % Straight Line
% Headers  = [Headers {'Proj. Pos. Error SL'}];
% valCam      = [valCam {(projOffsetResultsCamLeft.straight.meanError + projOffsetResultsCamRight.straight.meanError)/2}];
% valFus      = [valFus {(projOffsetResultsFusLeft.straight.meanError + projOffsetResultsFusRight.straight.meanError)/2}];
% 
% %% Projected LaneWidth
% % Overall
% Headers  = [Headers {'LaneWidth Error'}];
% valCam      = [valCam {projLaneWidthResultsCam.overall.meanError}];
% valFus      = [valFus {projLaneWidthResultsFus.overall.meanError}];
% 
% % Curve
% Headers  = [Headers {'LaneWidth Error C'}];
% valCam      = [valCam {projLaneWidthResultsCam.curve.meanError}];
% valFus      = [valFus {projLaneWidthResultsFus.curve.meanError}];
% 
% % Straight Line
% Headers  = [Headers {'LaneWidth Error SL'}];
% valCam      = [valCam {projLaneWidthResultsCam.straight.meanError}];
% valFus      = [valFus {projLaneWidthResultsFus.straight.meanError}];
% 
% %% ViewRange
% % Overall
% Headers  = [Headers {'ViewRange Average'}];
% valCam      = [valCam {(viewRangeResultsCamLeft.overall+viewRangeResultsCamRight.overall)/2}];
% valFus      = [valFus {(viewRangeResultsFusLeft.overall+viewRangeResultsFusRight.overall)/2}];
% 
% % Curve
% Headers  = [Headers {'ViewRange Average C'}];
% valCam      = [valCam {(viewRangeResultsCamLeft.curve+viewRangeResultsCamRight.curve)/2}];
% valFus      = [valFus {(viewRangeResultsFusLeft.curve+viewRangeResultsFusRight.curve)/2}];
% 
% % Straight Line
% Headers  = [Headers {'ViewRange Average SL'}];
% valCam      = [valCam {(viewRangeResultsCamLeft.straight+viewRangeResultsCamRight.straight)/2}];
% valFus      = [valFus {(viewRangeResultsFusLeft.straight+viewRangeResultsFusRight.straight)/2}];
% 
% %% Quality
% % Overall
% Headers  = [Headers {'Quality Ratio'}];
% valCam      = [valCam {(qualityResultsCamLeft.overall+qualityResultsCamRight.overall)/2}];
% valFus      = [valFus {(qualityResultsFusLeft.overall+qualityResultsFusRight.overall)/2}];
% 
% % Curve
% Headers  = [Headers {'Quality Ratio C'}];
% valCam      = [valCam {(qualityResultsCamLeft.curve+qualityResultsCamRight.curve)/2}];
% valFus      = [valFus {(qualityResultsFusLeft.curve+qualityResultsFusRight.curve)/2}];
% 
% % Straight Line
% Headers  = [Headers {'Quality Ratio SL'}];
% valCam      = [valCam {(qualityResultsCamLeft.straight+qualityResultsCamRight.straight)/2}];
% valFus      = [valFus {(qualityResultsFusLeft.straight+qualityResultsFusRight.straight)/2}];
% 
% 