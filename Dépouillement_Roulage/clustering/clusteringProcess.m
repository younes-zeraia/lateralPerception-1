% This script gather "Clustering" post-process operations applied to Lateral
% Perception logs

%% PROCESS PART
% Find out on which part of the track the capsule was recorded


indCamAvailableLeft     = find(log.Cam_InfrastructureLines_CamLeftLineQuality<=100);
indCamAvailableRight    = find(log.Cam_InfrastructureLines_CamRightLineQuality<=100);
% Solid type process
solidResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,param.solidLine,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
solidResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,param.solidLine,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
solidResultsFusLeft     = getClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,param.solidLine,log.QualityLineLeft,3,indCamAvailableLeft);
solidResultsFusRight    = getClusteringResults(log.LineTypeRight,log.Line_Marking_Right,param.solidLine,log.QualityLineRight,3,indCamAvailableRight);

% RoadEdge type process
roadEdgeResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,param.roadEdge,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
roadEdgeResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,param.roadEdge,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
roadEdgeResultsFusLeft     = getClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,param.roadEdge,log.QualityLineLeft,3,indCamAvailableLeft);
roadEdgeResultsFusRight    = getClusteringResults(log.LineTypeRight,log.Line_Marking_Right,param.roadEdge,log.QualityLineRight,3,indCamAvailableRight);

% Dashed type process
dashedResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,param.dashedLine,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
dashedResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,param.dashedLine,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
dashedResultsFusLeft     = getClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,param.dashedLine,log.QualityLineLeft,3,indCamAvailableLeft);
dashedResultsFusRight    = getClusteringResults(log.LineTypeRight,log.Line_Marking_Right,param.dashedLine,log.QualityLineRight,3,indCamAvailableRight);

% Double line type process
doubleLineResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,param.doubleLane,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
doubleLineResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,param.doubleLane,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
doubleLineResultsFusLeft     = getClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,param.doubleLane,log.QualityLineLeft,3,indCamAvailableLeft);
doubleLineResultsFusRight    = getClusteringResults(log.LineTypeRight,log.Line_Marking_Right,param.doubleLane,log.QualityLineRight,3,indCamAvailableRight);

% Barrier type process
barrierResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,param.barrier,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
barrierResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,param.barrier,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
barrierResultsFusLeft     = getClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,param.barrier,log.QualityLineLeft,3,indCamAvailableLeft);
barrierResultsFusRight    = getClusteringResults(log.LineTypeRight,log.Line_Marking_Right,param.barrier,log.QualityLineRight,3,indCamAvailableRight);

% White Color process
whiteResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,param.white,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
whiteResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,param.white,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);

% Yellow Color process
yellowResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,param.yellow,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
yellowResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,param.yellow,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);

% Blue Color process
blueResultsCamLeft     = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,param.blue,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
blueResultsCamRight    = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,param.blue,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);

% Quality process
qualityResultsCamLeft   =  getQualityResults(log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
qualityResultsCamRight  =  getQualityResults(log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
qualityResultsFusLeft   =  getQualityResults(log.QualityLineLeft,3,indCamAvailableLeft);
qualityResultsFusRight  =  getQualityResults(log.QualityLineRight,3,indCamAvailableRight);

%% PlOT PART
