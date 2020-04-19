% This function is intended to evaluate clustering performance on road edge track
% Use Case : Ego go through CTA Road Edge Track on its right lane
% prerequisite : The GroundTruth of Right Line type should be in the log

% First phase beginning : Right Line Type GroundTruth goes to DASHED
% Second phase beginning: Right Line Type GroundTruth goes to ROAD-EDGE

% During First phase :
% RightLineType should be at DASHED
% NextRightLineType should be at ROAD EDGE

% During Second phase :
% RightLineType shoud be at ROAD EDGE

function clusteringResults = NCapRoadEdgeProcess(lineTypeMes,nextLineTypeMes,lineTypeGT,lineOffsetMes,nextLineOffsetMes,measureQuality,timeArray,param)
    
    %% Find out First phase and Second phase begin and end
    indSecondPhaseBegin = find(lineTypeGT(1:end-1)==param.dashedLine & lineTypeGT(2:end)==param.roadEdge,1,'last');
    indFirstPhaseBegin  = find(lineTypeGT(1:indSecondPhaseBegin)~=param.dashedLine,1,'last')+1;
    if isempty(indFirstPhaseBegin) % GT Line Type == Dashed from the beginning
        indFirstPhaseBegin = 1;
    end
    indSecondPhaseEnd = find(lineTypeGT(indSecondPhaseBegin+1:end)~=param.roadEdge,1,'first') + indSecondPhaseBegin+1;
    if isempty(indSecondPhaseEnd)
        indSecondPhaseEnd = length(lineTypeGT);
    end
    
    clusteringResults.indFirstPhase = [indFirstPhaseBegin:indSecondPhaseBegin];
    clusteringResults.indSecondPhase  = [indSecondPhaseBegin:indSecondPhaseEnd];
    %% CLUSTERING
    clusteringResults.rightRoadEdgeFNRatio          = getFNRatio(lineTypeMes(indFirstPhaseBegin:indSecondPhaseEnd)==param.roadEdge,lineTypeGT(indFirstPhaseBegin:indSecondPhaseEnd)==param.roadEdge);
    clusteringResults.rightRoadEdgeFPRatio          = getFPRatio(lineTypeMes(indFirstPhaseBegin:indSecondPhaseEnd)==param.roadEdge,lineTypeGT(indFirstPhaseBegin:indSecondPhaseEnd)==param.roadEdge);
    clusteringResults.rightRoadEdgeHITRatio         = getHITRatio(lineTypeMes(indFirstPhaseBegin:indSecondPhaseEnd)==param.roadEdge,lineTypeGT(indFirstPhaseBegin:indSecondPhaseEnd)==param.roadEdge);
    clusteringResults.nextRightRoadEdgeFNRatio      = getFNRatio(nextLineTypeMes(indFirstPhaseBegin:indSecondPhaseBegin)==param.roadEdge,lineTypeGT(indFirstPhaseBegin:indSecondPhaseBegin)==param.dashedLine);
    clusteringResults.nextRightRoadEdgeHITRatio     = getHITRatio(nextLineTypeMes(indFirstPhaseBegin:indSecondPhaseBegin)==param.roadEdge,lineTypeGT(indFirstPhaseBegin:indSecondPhaseBegin)==param.dashedLine);
    
    %% Transition speed from dashed to roadedge
    clusteringResults.secondPhaseFirstRoadEdgeState = find(lineTypeMes(clusteringResults.indSecondPhase) == param.roadEdge,1,'first')+clusteringResults.indSecondPhase(1)-1;
    if clusteringResults.secondPhaseFirstRoadEdgeState==clusteringResults.indSecondPhase(1) % The measure went to roadEdge before the GroundTruth
        clusteringResults.secondPhaseFirstRoadEdgeState = find(lineTypeMes(clusteringResults.indFirstPhase)~= param.roadEdge,1,'last') + clusteringResults.indFirstPhase(1) - 1;
    end
    clusteringResults.transitionDelay = timeArray(clusteringResults.secondPhaseFirstRoadEdgeState) - timeArray(clusteringResults.indSecondPhase(1));
    %% OFFSET 
    clusteringResults.diffOffset = abs(nextLineOffsetMes-lineOffsetMes);
    clusteringResults.diffOffsetMean = nanmean(clusteringResults.diffOffset(find(clusteringResults.diffOffset(clusteringResults.indFirstPhase)<0.40)+clusteringResults.indFirstPhase(1)));
    
    %% Second Phase Quality evaluation
    goodQualityMesThrsh     = max(measureQuality).*0.25;
    clusteringResults.secondPhaseGoodQuality      = measureQuality(clusteringResults.indSecondPhase)>=goodQualityMesThrsh;
    clusteringResults.secondPhaseGoodQualityRatio = nanmean(clusteringResults.secondPhaseGoodQuality);
    clusteringResults.secondPhaseQualityMean      = nanmean(measureQuality(clusteringResults.indSecondPhase));
    clusteringResults.roadEdgeQualityMean         = nanmean(measureQuality(find(lineTypeMes==param.roadEdge)));
end