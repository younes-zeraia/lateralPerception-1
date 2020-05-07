% This function is intended to process the KPI of an object detection
% Intput : measure / reference / objectValue / quality

function clusteringResults = getClusteringResults(measureType,referenceType,measureColor,referenceColor,param,quality,qualityMax,indCamActive)
    %% Select only parts during which the camera was available
    measureType     = measureType(indCamActive);
    referenceType   = referenceType(indCamActive);
    measureColor    = measureColor(indCamActive);
    referenceColor  = referenceColor(indCamActive);
    indReferenceLine = find(any(referenceType ~= [param.undecided],2));
    measureColor    = measureColor(indReferenceLine);
    referenceColor  = referenceColor(indReferenceLine);
    quality     = quality(indCamActive);
    
    %% Comparison line types taken individually
    clusteringResults.solid         = getResults(measureType,referenceType,[param.solidLine],quality,qualityMax);
    clusteringResults.roadEdge      = getResults(measureType,referenceType,[param.roadEdge],quality,qualityMax);
    clusteringResults.dashed        = getResults(measureType,referenceType,[param.dashedLine],quality,qualityMax);
    clusteringResults.doubleLine    = getResults(measureType,referenceType,[param.doubleLane],quality,qualityMax);
    clusteringResults.barrier       = getResults(measureType,referenceType,[param.barrier],quality,qualityMax);
    
    %% Comparison line types combinations
    % Solid + Double Lane type
    clusteringResults.solidDouble   = getResults(measureType,referenceType,[param.solidLine param.doubleLane],quality,qualityMax);
    
    % Dashed + Double Lane type
    clusteringResults.dashedDouble  = getResults(measureType,referenceType,[param.dashedLine param.doubleLane],quality,qualityMax);
    
    % Solid + Dashed + Double Lane type
    clusteringResults.line          = getResults(measureType,referenceType,[param.solidLine param.doubleLane param.dashedLine],quality,qualityMax);
    
    % RoadEdge + Barrier type
    clusteringResults.roadEdgeBarrier   = getResults(measureType,referenceType,[param.roadEdge  param.barrier],quality,qualityMax);
    
    %% Comparison line colors
    clusteringResults.white         = getResults(measureColor,referenceColor,[param.white],quality,qualityMax);
    clusteringResults.yellow        = getResults(measureColor,referenceColor,[param.yellow],quality,qualityMax);
    clusteringResults.blue          = getResults(measureColor,referenceColor,[param.blue],quality,qualityMax);
    
    % Overal quality
    clusteringResults.quality       = nanmean(quality)/qualityMax;
end

function results = getResults(measure,reference,objectValue,quality,qualityMax)
    
    objectDetectedMes   = any(measure == objectValue,2);
    objectDetectedRef   = any(reference == objectValue,2);    
    
%     results.Hit = getHITRatio(objectDetectedMes,objectDetectedRef);
%     results.FP  = getFPRatio(objectDetectedMes,objectDetectedRef);
%     results.FN  = getFNRatio(objectDetectedMes,objectDetectedRef);
    
    results.assumed      = sum(objectDetectedMes,1)/size(objectDetectedRef,1);
    results.detected     = sum(objectDetectedMes & objectDetectedRef,1)/size(objectDetectedRef,1);
    results.ghost        = sum(objectDetectedMes & ~objectDetectedRef,1)/size(objectDetectedRef,1);
    results.present      = sum(objectDetectedRef,1)/size(objectDetectedRef,1);
    results.notPresent   = sum(~objectDetectedRef,1)/size(objectDetectedRef,1);
    results.qualityRef      = mean(quality(find(objectDetectedRef==true)))/qualityMax;
    results.qualityMes      = mean(quality(find(objectDetectedMes==true)))/qualityMax;
    
end