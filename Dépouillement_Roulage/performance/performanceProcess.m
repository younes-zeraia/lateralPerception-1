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

% Lines projected laneWidth
[projLaneWidthCam projLaneWidthCamQuality] = getProjLaneWidth(projOffsetCamLeft,projOffsetCamRight,log.Cam_InfrastructureLines_CamLeftLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality);
[projLaneWidthFus projLaneWidthFusQuality] = getProjLaneWidth(projOffsetFusLeft,projOffsetFusRight,log.QualityLineLeft,log.QualityLineRight);
[projLaneWidthGT  projLaneWidthGTQuality ] = getProjLaneWidth(projOffsetGTLeft,projOffsetGTRight,log.Cam_InfrastructureLines_CamLeftLineQuality.*100,log.Cam_InfrastructureLines_CamLeftLineQuality.*100);

% Modify GroundTruth Quality
[log.GT_leftLineOffset log.GT_leftLineYawAngle log.GT_leftLineCurvature log.GT_leftLineQuality projOffsetGTLeft] = getGTQuality(log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineCurvature,...
                                                                                                            log.GT_leftLineOffset,log.GT_leftLineYawAngle,log.GT_leftLineCurvature,log.t,projOffsetGTLeft);
[log.GT_rightLineOffset log.GT_rightLineYawAngle log.GT_rightLineCurvature log.GT_rightLineQuality projOffsetGTRight] = getGTQuality(log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineCurvature,...
                                                                                                            log.GT_rightLineOffset,log.GT_rightLineYawAngle,log.GT_rightLineCurvature,log.t,projOffsetGTRight);
%% Error process
% lines Curvature
leftTurns  = curvatureProcess(log.Cam_InfrastructureLines_CamLeftLineCurvature,log.CurvatureLineLeft,log.GT_leftLineCurvature,beginR,endR);
rightTurns = curvatureProcess(log.Cam_InfrastructureLines_CamRightLineCurvature,log.CurvatureLineRight,log.GT_rightLineCurvature,beginR,endR);

% Cam vs GT
resultsCamLeft  = perfoResultsProcess(log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineCurvature,projOffsetCamLeft,projLaneWidthCam,log.Cam_InfrastructureLines_CamLeftLineEndViewRange,log.Cam_InfrastructureLines_CamLeftLineQuality,...
                                      log.GT_leftLineOffset,log.GT_leftLineYawAngle,log.GT_leftLineCurvature,projOffsetGTLeft,projLaneWidthGT,log.GT_leftLineQuality,leftTurns);
resultsCamRight  = perfoResultsProcess(log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineCurvature,projOffsetCamRight,projLaneWidthCam,log.Cam_InfrastructureLines_CamRightLineEndViewRange,log.Cam_InfrastructureLines_CamRightLineQuality,...
                                      log.GT_rightLineOffset,log.GT_rightLineYawAngle,log.GT_rightLineCurvature,projOffsetGTRight,projLaneWidthGT,log.GT_rightLineQuality,rightTurns);

resultsCamLeft.curvature.errorRatio = mean(leftTurns.curvatureError1);
resultsCamRight.curvature.errorRatio = mean(rightTurns.curvatureError1);

% Fus vs GT
resultsFusLeft  = perfoResultsProcess(log.PositionLineLeft,log.LeftLineYawAngle,log.CurvatureLineLeft,projOffsetFusLeft,projLaneWidthFus,log.ViewRangeLineLeft,log.QualityLineLeft,...
                                      log.GT_leftLineOffset,log.GT_leftLineYawAngle,log.GT_leftLineCurvature,projOffsetGTLeft,projLaneWidthGT,log.GT_leftLineQuality,leftTurns);
resultsFusRight  = perfoResultsProcess(log.PositionLineRight,log.RightLineYawAngle,log.CurvatureLineRight,projOffsetFusRight,projLaneWidthFus,log.ViewRangeLineRight,log.QualityLineRight,...
                                      log.GT_rightLineOffset,log.GT_rightLineYawAngle,log.GT_rightLineCurvature,projOffsetGTRight,projLaneWidthGT,log.GT_rightLineQuality,rightTurns);

resultsFusLeft.curvature.errorRatio = nanmean(leftTurns.curvatureError2);
resultsFusRight.curvature.errorRatio = nanmean(rightTurns.curvatureError2);

% Fus vs Cam
resultsFusCamLeft  = perfoResultsProcess(log.PositionLineLeft,log.LeftLineYawAngle,log.CurvatureLineLeft,projOffsetFusLeft,projLaneWidthFus,log.ViewRangeLineLeft,log.QualityLineLeft,...
                                      log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineCurvature,projOffsetCamLeft,projLaneWidthCam,log.Cam_InfrastructureLines_CamLeftLineQuality,leftTurns,log.Cam_InfrastructureLines_CamLeftLineEndViewRange);
resultsFusCamRight  = perfoResultsProcess(log.PositionLineRight,log.RightLineYawAngle,log.CurvatureLineRight,projOffsetFusRight,projLaneWidthFus,log.ViewRangeLineRight,log.QualityLineRight,...
                                      log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineCurvature,projOffsetCamRight,projLaneWidthCam,log.Cam_InfrastructureLines_CamRightLineQuality,rightTurns,log.Cam_InfrastructureLines_CamRightLineEndViewRange);

                                  
[risingDelayQuality0Left  fallingDelayQuality0Left] = getDelayQuality0(log.Cam_InfrastructureLines_CamLeftLineQuality,log.QualityLineLeft,log.t);
[risingDelayQuality0Right fallingDelayQuality0Right] = getDelayQuality0(log.Cam_InfrastructureLines_CamRightLineQuality,log.QualityLineRight,log.t);

% Merge results
resultsCam = mergeStructs(resultsCamLeft,resultsCamRight);
resultsFus = mergeStructs(resultsFusLeft,resultsFusRight);
resultsFusCam = mergeStructs(resultsFusCamLeft,resultsFusCamRight);
%% PLOT PART
% Curvature
figCurveLeft = plotCurvResults(log.Cam_InfrastructureLines_CamLeftLineCurvature,log.CurvatureLineLeft,log.t,leftTurns,ZFFrCam,RSAFusion);
figCurveRight = plotCurvResults(log.Cam_InfrastructureLines_CamRightLineCurvature,log.CurvatureLineRight,log.t,rightTurns,ZFFrCam,RSAFusion);


% figCurveFluctuationLeft = p
% lotCurvFluct(log.Cam_InfrastructureLines_CamLeftLineCurvature,log.CurvatureLineLeft,leftTurns,ZFFrCam,RSAFusion);

% Position
figPositionLeft     = plotOffsetResults(log.Cam_InfrastructureLines_CamLeftLineOffset,log.PositionLineLeft,log.GT_leftLineOffset,log.t,resultsCamLeft.offset,resultsFusLeft.offset,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,offsetTargetPrecision,'Left',0);
figPositionRight    = plotOffsetResults(log.Cam_InfrastructureLines_CamRightLineOffset,log.PositionLineRight,log.GT_rightLineOffset,log.t,resultsCamRight.offset,resultsFusRight.offset,rightTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,offsetTargetPrecision,'Right',0);
figPositionDiff     = plotOffsetDiffResults(log.Cam_InfrastructureLines_CamLeftLineOffset,log.Cam_InfrastructureLines_CamRightLineOffset,log.PositionLineLeft,log.PositionLineRight,log.t,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR);

% yaw Angle
figYawAngleLeft     = plotYawAngleResults(log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.LeftLineYawAngle,log.GT_leftLineYawAngle,log.t,resultsCamLeft.yaw,resultsFusLeft.yaw,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,yawAngleTargetPrecision,'Left');
figYawAngleRight    = plotYawAngleResults(log.Cam_InfrastructureLines_CamRightLineYawAngle,log.RightLineYawAngle,log.GT_rightLineYawAngle,log.t,resultsCamRight.yaw,resultsFusRight.yaw,rightTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,yawAngleTargetPrecision,'Right');

% projected Position
figProjPositionLeft     = plotOffsetResults(projOffsetCamLeft,projOffsetFusLeft,projOffsetGTLeft,log.t,resultsCamLeft.projOffset,resultsFusLeft.projOffset,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,projOffsetTargetPrecision,'Left',distProjLaneWidth);
figProjPositionRight    = plotOffsetResults(projOffsetCamRight,projOffsetFusRight,projOffsetGTRight,log.t,resultsCamRight.projOffset,resultsFusRight.projOffset,rightTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,projOffsetTargetPrecision,'Right',distProjLaneWidth);

% Projected Lane Width
figProjLaneWidth        = plotLaneWidthResults(projLaneWidthCam,projLaneWidthFus,projLaneWidthGT,log.t,resultsCamLeft.laneWidth,resultsFusLeft.laneWidth,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR,projOffsetTargetPrecision,distProjLaneWidth);

% ViewRange
figViewRange            = plotViewRangeResults(log.Cam_InfrastructureLines_CamLeftLineEndViewRange,log.Cam_InfrastructureLines_CamRightLineEndViewRange,log.ViewRangeLineLeft,log.ViewRangeLineRight,...
                                               resultsCamLeft.viewRange,resultsCamRight.viewRange,resultsFusLeft.viewRange,resultsFusRight.viewRange,log.t,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR);
% Quality
figQuality              = plotQualityResults(log.Cam_InfrastructureLines_CamLeftLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality,log.QualityLineLeft,log.QualityLineRight,...
                                               resultsCamLeft.quality,resultsCamRight.quality,resultsFusLeft.quality,resultsFusRight.quality,log.t,leftTurns.InTurnFlag,ZFFrCam,RSAFusion,beginR);

figHistCam= plotHistResults(resultsCam,ZFFrCam,'GroundTruth','overall');
figHistCamCurve= plotHistResults(resultsCam,ZFFrCam,'GroundTruth','curve');
figHistCamStraight= plotHistResults(resultsCam,ZFFrCam,'GroundTruth','straight');
figHistFus= plotHistResults(resultsFus,RSAFusion,'GroundTruth','overall');
figHistFusCurve= plotHistResults(resultsFus,RSAFusion,'GroundTruth','curve');
figHistFusStraight= plotHistResults(resultsFus,RSAFusion,'GroundTruth','straight');

figHistFusCam           = plotHistResults(resultsFusCam,RSAFusion,ZFFrCam,'overall');
figHistFusCamCurve      = plotHistResults(resultsFusCam,RSAFusion,ZFFrCam,'curve');
figHistFusCamStraight   = plotHistResults(resultsFusCam,RSAFusion,ZFFrCam,'straight');
%% Save graphs
if ~exist(graphResultsPath,'dir')
    mkdir(graphResultsPath);
end
cd(graphResultsPath);

% Curvature
saveas(figCurveLeft,strcat(fileName(1:end-4),'_C2_left','.png'));
saveas(figCurveRight,strcat(fileName(1:end-4),'_C2_right','.png'));
close(figCurveLeft);
close(figCurveRight);

% Position
saveas(figPositionLeft,strcat(fileName(1:end-4),'_C0_left','.png'));
saveas(figPositionRight,strcat(fileName(1:end-4),'_C0_right','.png'));
saveas(figPositionDiff,strcat(fileName(1:end-4),'_C0_diff','.png'));
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
saveas(figViewRange,strcat(fileName(1:end-4),'_viewRange','.png'));
close(figViewRange);

% Quality
saveas(figQuality,strcat(fileName(1:end-4),'_quality','.png'));
close(figQuality);

% histogram
saveas(figHistCam,strcat(fileName(1:end-4),'_histCamGT','.png'));
saveas(figHistCamCurve,strcat(fileName(1:end-4),'_histCamGT_curve','.png'));
saveas(figHistCamStraight,strcat(fileName(1:end-4),'_histCamGT_straight','.png'));
close(figHistCam);
close(figHistCamCurve);
close(figHistCamStraight);

saveas(figHistFus,strcat(fileName(1:end-4),'_histFusGT','.png'));
saveas(figHistFusCurve,strcat(fileName(1:end-4),'_histFusGT_curve','.png'));
saveas(figHistFusStraight,strcat(fileName(1:end-4),'_histFusGT_straight','.png'));
close(figHistFus);
close(figHistFusCurve);
close(figHistFusStraight);

saveas(figHistFusCam,strcat(fileName(1:end-4),'_histFusCam','.png'));
saveas(figHistFusCamCurve,strcat(fileName(1:end-4),'_histFusCam_curve','.png'));
saveas(figHistFusCamStraight,strcat(fileName(1:end-4),'_histFusCam_straight','.png'));
close(figHistFusCam);
close(figHistFusCamCurve);
close(figHistFusCamStraight);


cd(currScriptPath);