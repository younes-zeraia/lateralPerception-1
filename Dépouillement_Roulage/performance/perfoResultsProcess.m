function perfoResults = perfoResultsProcess(measureOffset,measureYaw,measureCurvature,measureProjPos,measureProjLaneWidth,measureViewRange,measureQuality,...
                                            referenceOffset,referenceYaw,referenceCurvature,referenceProjPos,referenceLaneWidth,referenceQuality,turns,referenceViewRange)
    if nargin < 15
        referenceViewRange = [];
    end
    perfoResults.offset     = errorProcess(measureOffset,referenceOffset,measureQuality,referenceQuality,turns.InTurnFlag);
    perfoResults.yaw        = errorProcess(measureYaw,referenceYaw,measureQuality,referenceQuality,turns.InTurnFlag);
    perfoResults.curvature  = errorProcess(measureCurvature,referenceCurvature,measureQuality,referenceQuality,turns.InTurnFlag);
    perfoResults.projOffset = errorProcess(measureProjPos,referenceProjPos,measureQuality,referenceQuality,turns.InTurnFlag);
    perfoResults.laneWidth  = errorProcess(measureProjLaneWidth,referenceLaneWidth,measureQuality,referenceQuality,turns.InTurnFlag);
    if nargin < 15
        perfoResults.viewRange  = viewRangeProcess(measureViewRange,measureQuality,turns.InTurnFlag);
    else
        perfoResults.viewRange  = errorProcess(measureViewRange,referenceViewRange,measureQuality,referenceQuality,turns.InTurnFlag);
    end
    perfoResults.quality    = qualityProcess(measureQuality,turns.InTurnFlag);
end