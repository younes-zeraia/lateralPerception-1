% This function is intended to process the KPI of an object detection
% Intput : measure / reference / objectValue / quality

function clusteringResults = getClusteringResults(measureType,referenceType,measureColor,referenceColor,param,quality,indCamActive)
    % Select only parts during which the camera was available
    measureType     = measureType(indCamActive);
    referenceType   = referenceType(indCamActive);
    measureColor    = measureColor(indCamActive);
    referenceColor  = referenceColor(indCamActive);
    quality     = quality(indCamActive);
    
    clusteringResults.solid         = getResults(measureType,referenceType,[param.solidLine param.doubleLane],quality);
    clusteringResults.roadEdge      = getResults(measureType,referenceType,[param.roadEdge  param.barrier],quality);
    clusteringResults.dashed        = getResults(measureType,referenceType,[param.dashedLine],quality);
    clusteringResults.doubleLine    = getResults(measureType,referenceType,[param.doubleLane],quality);
    clusteringResults.barrier       = getResults(measureType,referenceType,[param.barrier],quality);
    clusteringResults.white         = getResults(measureColor,referenceColor,[param.white],quality);
    clusteringResults.yellow        = getResults(measureColor,referenceColor,[param.yellow],quality);
    clusteringResults.blue          = getResults(measureColor,referenceColor,[param.blue],quality);
    clusteringResults.quality       = nanmean(quality);
end

function results = getResults(measure,reference,objectValue,quality)
    
    objectDetectedMes   = any(measure == objectValue,2);
    objectDetectedRef   = any(reference == objectValue,2);    
    
    results.Hit = getHITRatio(objectDetectedMes,objectDetectedRef);
    results.FP  = getFPRatio(objectDetectedMes,objectDetectedRef);
    results.FN  = getFNRatio(objectDetectedMes,objectDetectedRef);
    
    indObjectDetectedRef = find(objectDetectedRef);
    results.qualityMeanGT = mean(quality(indObjectDetectedRef));
    indObjectDetectedMes = find(objectDetectedMes);
    results.qualityMeanMes = mean(quality(indObjectDetectedMes));
end