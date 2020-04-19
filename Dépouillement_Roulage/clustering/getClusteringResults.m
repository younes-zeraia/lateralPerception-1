% This function is intended to process the KPI of an object detection
% Intput : measure / reference / objectValue / quality

function clusteringResults = getClusteringResults(measure,reference,objectValue,quality,qualityMax,indCamActive)
    % Select only parts during which the camera was available
    measure     = measure(indCamActive);
    reference   = reference(indCamActive);
    quality     = quality(indCamActive);
    
    
    clusteringResults.Hit = getHITRatio(measure==objectValue,reference==objectValue);
    clusteringResults.FP  = getFPRatio(measure==objectValue,reference==objectValue);
    clusteringResults.FN  = getFNRatio(measure==objectValue,reference==objectValue);
    
    indObjectDetected = find(reference==objectValue);
    clusteringResults.qualityMean = mean(quality(indObjectDetected));
    clusteringResults.qualityGoodRatio = nanmean(quality(indObjectDetected)>=(qualityMax.*0.25));
end