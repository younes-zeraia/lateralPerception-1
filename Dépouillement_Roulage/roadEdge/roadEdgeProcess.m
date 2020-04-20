%% Parameters


%% PROCESS PART

NCapRoadEdgeResultsCam = NCapRoadEdgeProcess(log.Cam_InfrastructureLines_CamRightLineType,log.Cam_InfrastructureLines_CamRightRightLineType,log.Line_Marking_Right,...
                                           log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightRightLineOffset,...
                                           log.Cam_InfrastructureLines_CamRightLineQuality,log.t,param);
NCapRoadEdgeResultsFus = NCapRoadEdgeProcess(log.LineTypeRight,log.NextRightBoundaryType,log.Line_Marking_Right,...
                                           log.PositionLineRight,log.NextRightLineOffset,...
                                           log.QualityLineRight,log.t,param);

%% PLOT PART
figNCapRoadEdgeCam      = plotNCapRoadEdgeResults(log.Cam_InfrastructureLines_CamRightLineType,log.Cam_InfrastructureLines_CamRightRightLineType,log.Line_Marking_Right,...
                                                  log.Cam_InfrastructureLines_CamRightLineQuality,log.t,param,NCapRoadEdgeResultsCam);
figNCapRoadEdgeFus      = plotNCapRoadEdgeResults(log.LineTypeRight,log.NextRightBoundaryType,log.Line_Marking_Right,...
                                                  log.QualityLineRight,log.t,param,NCapRoadEdgeResultsFus);
                                              
%% Save graphs
if ~exist(graphResultsPath,'dir')
    mkdir(graphResultsPath);
end
cd(graphResultsPath);


saveas(figNCapRoadEdgeCam,strcat(fileName(1:end-4),'_Cam_RoadEdgeTest','.svg'));
saveas(figNCapRoadEdgeCam,strcat(fileName(1:end-4),'_Cam_RoadEdgeTest','.fig'));
saveas(figNCapRoadEdgeFus,strcat(fileName(1:end-4),'_Fus_RoadEdgeTest','.svg'));
saveas(figNCapRoadEdgeFus,strcat(fileName(1:end-4),'_Fus_RoadEdgeTest','.fig'));
close(figNCapRoadEdgeCam);
close(figNCapRoadEdgeFus);

cd(currScriptPath);