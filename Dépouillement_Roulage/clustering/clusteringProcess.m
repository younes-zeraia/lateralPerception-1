% This script gather "Clustering" post-process operations applied to Lateral
% Perception logs

%% PROCESS PART
indCamAvailableLeft     = find(log.Cam_InfrastructureLines_CamLeftLineQuality<=100 & log.Line_Marking_Left~=0);
indCamAvailableRight    = find(log.Cam_InfrastructureLines_CamRightLineQuality<=100 & log.Line_Marking_Right~=0);
% Solid type process
clusteringResultsCamLeft = getClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,...
                                                log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,...
                                                param,log.Cam_InfrastructureLines_CamLeftLineQuality,100,indCamAvailableLeft);
                                            
clusteringResultsCamRight = getClusteringResults(log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,...
                                                log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,...
                                                param,log.Cam_InfrastructureLines_CamRightLineQuality,100,indCamAvailableRight);
                                            
clusteringResultsFusLeft = getClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,...
                                                log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,...
                                                param,log.QualityLineLeft,3,indCamAvailableLeft);
                                            
clusteringResultsFusRight = getClusteringResults(log.LineTypeRight,log.Line_Marking_Right,...
                                                log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,...
                                                param,log.QualityLineRight,3,indCamAvailableRight);

%% PlOT PART
figClusteringCam      = plotClusteringResults(log.Cam_InfrastructureLines_CamLeftLineType,log.Line_Marking_Left,...
                                              log.Cam_InfrastructureLines_CamRightLineType,log.Line_Marking_Right,...
                                              log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,...
                                              log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,...
                                              log.Cam_InfrastructureLines_CamLeftLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality,100,...
                                              log.t,param,clusteringResultsCamLeft,clusteringResultsCamRight);
figClusteringFus      = plotClusteringResults(log.LineTypeLeft,log.Line_Marking_Left,...
                                              log.LineTypeRight,log.Line_Marking_Right,...
                                              log.Cam_InfrastructureLines_CamLeftLineColor,log.Line_Color_Left,...
                                              log.Cam_InfrastructureLines_CamRightLineColor,log.Line_Color_Right,...
                                              log.QualityLineLeft,log.QualityLineRight,3,...
                                              log.t,param,clusteringResultsFusLeft,clusteringResultsFusRight);
                                          
%% SAVE GRAPHS
if ~exist(graphResultsPath,'dir')
    mkdir(graphResultsPath);
end
cd(graphResultsPath);


saveas(figClusteringCam,strcat(fileName(1:end-4),'_Cam_clustering','.png'));
saveas(figClusteringCam,strcat(fileName(1:end-4),'_Cam_clustering','.fig'));
saveas(figClusteringFus,strcat(fileName(1:end-4),'_Fus_clustering','.png'));
saveas(figClusteringFus,strcat(fileName(1:end-4),'_Fus_clustering','.fig'));
close(figClusteringCam);
close(figClusteringFus);

cd(currScriptPath);
