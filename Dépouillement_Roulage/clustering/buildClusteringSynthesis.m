% This script gather "Clustering" synthesis values
%% Clustering Detection
Headers = {};
valCam  = {};
valFus  = {};

detectionObj = fieldnames(clusteringResultsCamLeft);
for obj = 1:length(detectionObj)
    objName  = detectionObj{obj};
    objValue = getfield(clusteringResultsCamLeft,objName);
    if isstruct(objValue) % All objects except quality
        detectionKPI = fieldnames(objValue);
        for kpi = 1:length(detectionKPI) % For all KPIs (FP / Hit / FN ...)
            kpiName     = detectionKPI{kpi};
            valCamLeft  = getfield(getfield(clusteringResultsCamLeft,objName),kpiName);
            valCamRight = getfield(getfield(clusteringResultsCamRight,objName),kpiName);
            valFusLeft  = getfield(getfield(clusteringResultsFusLeft,objName),kpiName);
            valFusRight = getfield(getfield(clusteringResultsFusRight,objName),kpiName);
            Headers     = [Headers {strcat(objName,'_',kpiName)}];
            valCam      = [valCam {nanmean([valCamLeft,valCamRight])}];
            valFus      = [valFus {nanmean([valFusLeft,valFusRight])}];
        end
    else
        valCamLeft  = getfield(clusteringResultsCamLeft,objName);
        valCamRight = getfield(clusteringResultsCamRight,objName);
        valFusLeft  = getfield(clusteringResultsFusLeft,objName);
        valFusRight = getfield(clusteringResultsFusRight,objName);
        
        Headers     = [Headers {objName}];
        valCam      = [valCam {nanmean([valCamLeft,valCamRight])}];
        valFus      = [valFus {nanmean([valFusLeft,valFusRight])}];
    end
end

clusteringSynthesis = [Headers;valCam;valFus];
