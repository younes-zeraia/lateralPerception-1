% This script gather "Performance" post-process operations applied to Lateral
% Perception logs

%% Path parameters
if length(FrCamSW)>0 % FrCam SW version found in log title
    ZFFrCam  = ['ZF FrCam_' FrCamSW];
else
    ZFFrCam  = 'ZF FrCam';
end
if length(FusionSW)>0 % Fusion RM version found in log title
    RSAFusion = ['RSA Fusion_' FusionSW];
else
    RSAFusion= 'RSA Fusion';
end

%% PROCESS PART
% Lines projected offset
projOffsetCamLeft       = getProjLateralPos(log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineCurvature,log.Cam_InfrastructureLines_CamLeftLineCurvatureRate,distProjLaneWidth);
projOffsetCamRight      = getProjLateralPos(log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineCurvature,log.Cam_InfrastructureLines_CamRightLineCurvatureRate,distProjLaneWidth);

projOffsetFusLeft       = getProjLateralPos(log.PositionLineLeft,log.LeftLineYawAngle,log.CurvatureLineLeft,log.CurvatureDerivativeLineLeft,distProjLaneWidth);
projOffsetFusRight      = getProjLateralPos(log.PositionLineRight,log.RightLineYawAngle,log.CurvatureLineRight,log.CurvatureDerivativeLineRight,distProjLaneWidth);

projOffsetGTLeft        = getProjLateralPos(log.GT_leftC0Raw,log.GT_leftC1Raw,log.GT_leftC2Raw,log.GT_leftC3Raw,distProjLaneWidth);
projOffsetGTRight       = getProjLateralPos(log.GT_rightC0Raw,log.GT_rightC1Raw,log.GT_rightC2Raw,log.GT_rightC3Raw,distProjLaneWidth);

projOffsetGTLeft        = neighboorFilt(projOffsetGTLeft,5);
projOffsetGTRight       = neighboorFilt(projOffsetGTRight,5);

% Modify GroundTruth Quality
[log.GT_leftLineOffset log.GT_leftLineYawAngle log.GT_leftLineCurvature log.GT_leftLineQuality projOffsetGTLeft] = getGTQuality(log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineCurvature,...
                                                                                                            log.GT_leftLineOffset,log.GT_leftLineYawAngle,log.GT_leftLineCurvature,log.t,projOffsetGTLeft);
[log.GT_rightLineOffset log.GT_rightLineYawAngle log.GT_rightLineCurvature log.GT_rightLineQuality projOffsetGTRight] = getGTQuality(log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineCurvature,...
                                                                                                            log.GT_rightLineOffset,log.GT_rightLineYawAngle,log.GT_rightLineCurvature,log.t,projOffsetGTRight);

% lines Curvature
leftTurns  = curvatureProcess(log.Cam_InfrastructureLines_CamLeftLineCurvature,log.CurvatureLineLeft,log.GT_leftLineCurvature,beginR,endR);
rightTurns = curvatureProcess(log.Cam_InfrastructureLines_CamRightLineCurvature,log.CurvatureLineRight,log.GT_rightLineCurvature,beginR,endR);

% lines Offset
offsetResultsCamLeft    = errorProcess(log.Cam_InfrastructureLines_CamLeftLineOffset,log.GT_leftLineOffset,log.Cam_InfrastructureLines_CamLeftLineQuality,log.GT_leftLineQuality,leftTurns.InTurnFlag,offsetTargetPrecision);
offsetResultsFusLeft    = errorProcess(log.PositionLineLeft,log.GT_leftLineOffset,log.QualityLineLeft,log.GT_leftLineQuality,leftTurns.InTurnFlag,offsetTargetPrecision);
offsetResultsCamRight   = errorProcess(log.Cam_InfrastructureLines_CamRightLineOffset,log.GT_rightLineOffset,log.Cam_InfrastructureLines_CamRightLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality*0+100,rightTurns.InTurnFlag,offsetTargetPrecision);
offsetResultsFusRight   = errorProcess(log.PositionLineRight,log.GT_rightLineOffset,log.QualityLineRight,log.QualityLineRight*0+100,rightTurns.InTurnFlag,offsetTargetPrecision);

% lines yawAngle
yawAngleResultsCamLeft    = errorProcess(log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.GT_leftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineQuality,log.GT_leftLineQuality,leftTurns.InTurnFlag,yawAngleTargetPrecision);
yawAngleResultsFusLeft    = errorProcess(log.LeftLineYawAngle,log.GT_leftLineYawAngle,log.QualityLineLeft,log.GT_leftLineQuality,leftTurns.InTurnFlag,yawAngleTargetPrecision);
yawAngleResultsCamRight   = errorProcess(log.Cam_InfrastructureLines_CamRightLineYawAngle,log.GT_rightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineQuality,log.GT_rightLineQuality,rightTurns.InTurnFlag,yawAngleTargetPrecision);
yawAngleResultsFusRight   = errorProcess(log.RightLineYawAngle,log.GT_rightLineYawAngle,log.QualityLineRight,log.GT_rightLineQuality,rightTurns.InTurnFlag,yawAngleTargetPrecision);

projOffsetResultsCamLeft    = errorProcess(projOffsetCamLeft,projOffsetGTLeft,log.Cam_InfrastructureLines_CamLeftLineQuality,log.GT_leftLineQuality,leftTurns.InTurnFlag,projOffsetTargetPrecision);
projOffsetResultsCamRight   = errorProcess(projOffsetCamRight,projOffsetGTRight,log.Cam_InfrastructureLines_CamRightLineQuality,log.GT_rightLineQuality,rightTurns.InTurnFlag,projOffsetTargetPrecision);

projOffsetResultsFusLeft    = errorProcess(projOffsetFusLeft,projOffsetGTLeft,log.QualityLineLeft,log.GT_leftLineQuality,leftTurns.InTurnFlag,projOffsetTargetPrecision);
projOffsetResultsFusRight   = errorProcess(projOffsetFusRight,projOffsetGTRight,log.QualityLineRight,log.GT_rightLineQuality,rightTurns.InTurnFlag,projOffsetTargetPrecision);

% Lines projected laneWidth
[projLaneWidthCam projLaneWidthCamQuality] = getProjLaneWidth(projOffsetCamLeft,projOffsetCamRight,log.Cam_InfrastructureLines_CamLeftLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality);
[projLaneWidthFus projLaneWidthFusQuality] = getProjLaneWidth(projOffsetFusLeft,projOffsetFusRight,log.QualityLineLeft,log.QualityLineRight);
[projLaneWidthGT  projLaneWidthGTQuality ] = getProjLaneWidth(projOffsetGTLeft,projOffsetGTRight,log.Cam_InfrastructureLines_CamLeftLineQuality.*100,log.Cam_InfrastructureLines_CamLeftLineQuality.*100);

projLaneWidthResultsCam = errorProcess(projLaneWidthCam,projLaneWidthGT,projLaneWidthCamQuality,projLaneWidthGTQuality,leftTurns.InTurnFlag,projLaneWidthTargetPrecision);
projLaneWidthResultsFus = errorProcess(projLaneWidthFus,projLaneWidthGT,projLaneWidthFusQuality,projLaneWidthGTQuality,leftTurns.InTurnFlag,projLaneWidthTargetPrecision);

% ViewRange
viewRangeResultsCamLeft  = viewRangeProcess(log.Cam_InfrastructureLines_CamLeftLineEndViewRange,log.Cam_InfrastructureLines_CamLeftLineQuality,leftTurns.InTurnFlag);
viewRangeResultsCamRight = viewRangeProcess(log.Cam_InfrastructureLines_CamRightLineEndViewRange,log.Cam_InfrastructureLines_CamRightLineQuality,rightTurns.InTurnFlag);
viewRangeResultsFusLeft  = viewRangeProcess(log.ViewRangeLineLeft,log.QualityLineLeft,leftTurns.InTurnFlag);
viewRangeResultsFusRight = viewRangeProcess(log.ViewRangeLineLeft,log.QualityLineRight,rightTurns.InTurnFlag);

% Quality
qualityResultsCamLeft   = qualityProcess(log.Cam_InfrastructureLines_CamLeftLineQuality,leftTurns.InTurnFlag);
qualityResultsCamRight  = qualityProcess(log.Cam_InfrastructureLines_CamRightLineQuality,rightTurns.InTurnFlag);
qualityResultsFusLeft   = qualityProcess(log.QualityLineLeft,leftTurns.InTurnFlag);
qualityResultsFusRight  = qualityProcess(log.QualityLineRight,rightTurns.InTurnFlag);

[risingDelayQuality0Left  fallingDelayQuality0Left] = getDelayQuality0(log.Cam_InfrastructureLines_CamLeftLineQuality,log.QualityLineLeft,log.t);
[risingDelayQuality0Right fallingDelayQuality0Right] = getDelayQuality0(log.Cam_InfrastructureLines_CamRightLineQuality,log.QualityLineRight,log.t);

%% PLOT PART
% Curvature
figCurveLeft = plotCurvResults(log.Cam_InfrastructureLines_CamLeftLineCurvature,log.CurvatureLineLeft,log.t,leftTurns,ZFFrCam,RSAFusion);
figCurveRight = plotCurvResults(log.Cam_InfrastructureLines_CamRightLineCurvature,log.CurvatureLineRight,log.t,rightTurns,ZFFrCam,RSAFusion);

% figCurveFluctuationLeft = p
lotCurvFluct(log.Cam_InfrastructureLines_CamLeftLineCurvature,log.CurvatureLineLeft,leftTurns,ZFFrCam,RSAFusion);

% Position
figPositionLeft     = plotOffsetResults(log.Cam_InfrastructureLines_CamLeftLineOffset,log.PositionLineLeft,log.GT_leftLineOffset,log.t,offsetResultsCamLeft,offsetResultsFusLeft,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,offsetTargetPrecision,'Left',0);
figPositionRight    = plotOffsetResults(log.Cam_InfrastructureLines_CamRightLineOffset,log.PositionLineRight,log.GT_rightLineOffset,log.t,offsetResultsCamRight,offsetResultsFusRight,rightTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,offsetTargetPrecision,'Right',0);
figPositionDiff     = plotOffsetDiffResults(log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamRightLineOffset,log.PositionLineLeft,log.PositionLineRight,log.t,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR);

% yaw Angle
figYawAngleLeft     = plotYawAngleResults(log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.LeftLineYawAngle,log.GT_leftLineYawAngle,log.t,yawAngleResultsCamLeft,yawAngleResultsFusLeft,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,yawAngleTargetPrecision,'Left');
figYawAngleRight    = plotYawAngleResults(log.Cam_InfrastructureLines_CamRightLineYawAngle,log.RightLineYawAngle,log.GT_rightLineYawAngle,log.t,yawAngleResultsCamRight,yawAngleResultsFusRight,rightTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,yawAngleTargetPrecision,'Right');

% projected Position
figProjPositionLeft     = plotOffsetResults(projOffsetCamLeft,projOffsetFusLeft,projOffsetGTLeft,log.t,projOffsetResultsCamLeft,projOffsetResultsFusLeft,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,projOffsetTargetPrecision,'Left',distProjLaneWidth);
figProjPositionRight    = plotOffsetResults(projOffsetCamRight,projOffsetFusRight,projOffsetGTRight,log.t,projOffsetResultsCamRight,projOffsetResultsFusRight,rightTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,projOffsetTargetPrecision,'Right',distProjLaneWidth);

% Projected Lane Width
figProjLaneWidth        = plotLaneWidthResults(projLaneWidthCam,projLaneWidthFus,projLaneWidthGT,log.t,projLaneWidthResultsCam,projLaneWidthResultsFus,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,projOffsetTargetPrecision,distProjLaneWidth);

% ViewRange
figViewRange            = plotViewRangeResults(log.Cam_InfrastructureLines_CamLeftLineEndViewRange,log.Cam_InfrastructureLines_CamRightLineEndViewRange,log.ViewRangeLineLeft,log.ViewRangeLineRight,...
                                               viewRangeResultsCamLeft,viewRangeResultsCamRight,viewRangeResultsFusLeft,viewRangeResultsFusRight,log.t,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR);
% Quality
figQuality              = plotQualityResults(log.Cam_InfrastructureLines_CamLeftLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality,log.QualityLineLeft,log.QualityLineRight,...
                                               qualityResultsCamLeft,qualityResultsCamRight,qualityResultsFusLeft,qualityResultsFusRight,log.t,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR);

%% Save graphs
if ~exist(graphResultsPath,'dir')
    mkdir(graphResultsPath);
end
cd(graphResultsPath);

% Curvature
saveas(figCurveLeft,strcat(fileName(1:end-4),'_C2_left','.svg'));
saveas(figCurveRight,strcat(fileName(1:end-4),'_C2_right','.svg'));
close(figCurveLeft);
close(figCurveRight);

% Position
saveas(figPositionLeft,strcat(fileName(1:end-4),'_C0_left','.svg'));
saveas(figPositionRight,strcat(fileName(1:end-4),'_C0_right','.svg'));
saveas(figPositionDiff,strcat(fileName(1:end-4),'_C0_diff','.svg'));
close(figPositionLeft);
close(figPositionRight);
close(figPositionDiff);

% Yaw Angle
saveas(figYawAngleLeft,strcat(fileName(1:end-4),'_C1_left','.png'));
saveas(figYawAngleRight,strcat(fileName(1:end-4),'_C1_right','.png'));
close(figYawAngleLeft);
close(figYawAngleRight);

% Projected Position
saveas(figProjPositionLeft,strcat(fileName(1:end-4),'_Proj_C0_left','.png'));
saveas(figProjPositionRight,strcat(fileName(1:end-4),'_Proj_C0_right','.png'));
close(figProjPositionLeft);
close(figProjPositionRight);

% Projected Lane Width
saveas(figProjLaneWidth,strcat(fileName(1:end-4),'_Proj_LaneWidth','.png'));
close(figProjLaneWidth);

% ViewRange
saveas(figViewRange,strcat(fileName(1:end-4),'_viewRange','.svg'));
close(figViewRange);

% Quality
saveas(figQuality,strcat(fileName(1:end-4),'_quality','.png'));
close(figQuality);

cd(currScriptPath);