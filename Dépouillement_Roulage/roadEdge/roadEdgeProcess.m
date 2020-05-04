%% Parameters


%% PROCESS PART

NCapRoadEdgeResultsCam = NCapRoadEdgeProcess(log.Cam_InfrastructureLines_CamRightLineType,log.Cam_InfrastructureLines_CamRightRightLineType,log.Line_Marking_Right,...
                                           log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightRightLineOffset,...
                                           log.Cam_InfrastructureLines_CamRightLineQuality,log.Cam_InfrastructureLines_CamRightRightLineQuality,log.t,param,100);
NCapRoadEdgeResultsFus = NCapRoadEdgeProcess(log.LineTypeRight,log.NextRightBoundaryType,log.Line_Marking_Right,...
                                           log.PositionLineRight,log.NextRightLineOffset,...
                                           log.QualityLineRight,log.Cam_InfrastructureLines_CamRightRightLineQuality.*0+NaN,log.t,param,3);

%% PLOT PART
figNCapRoadEdgeCam      = plotNCapRoadEdgeResults(log.Cam_InfrastructureLines_CamRightLineType,log.Cam_InfrastructureLines_CamRightRightLineType,log.Line_Marking_Right,...
                                                  log.Cam_InfrastructureLines_CamRightLineQuality,log.t,param,NCapRoadEdgeResultsCam,100);
figNCapRoadEdgeFus      = plotNCapRoadEdgeResults(log.LineTypeRight,log.NextRightBoundaryType,log.Line_Marking_Right,...
                                                  log.QualityLineRight,log.t,param,NCapRoadEdgeResultsFus,3);
                                              
%% Save graphs
if ~exist(graphResultsPath,'dir')
    mkdir(graphResultsPath);
end
cd(graphResultsPath);


saveas(figNCapRoadEdgeCam,strcat(fileName(1:end-4),'_Cam_RoadEdgeTest','.png'));
saveas(figNCapRoadEdgeCam,strcat(fileName(1:end-4),'_Cam_RoadEdgeTest','.fig'));
saveas(figNCapRoadEdgeFus,strcat(fileName(1:end-4),'_Fus_RoadEdgeTest','.png'));
saveas(figNCapRoadEdgeFus,strcat(fileName(1:end-4),'_Fus_RoadEdgeTest','.fig'));
close(figNCapRoadEdgeCam);
close(figNCapRoadEdgeFus);

cd(currScriptPath);