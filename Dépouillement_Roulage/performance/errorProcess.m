% This function is intended to treat lines offset
% It returns some Offset performance KPI as :

% - Offset absolute mean error compared to GroundTruth
% - time ratio during which offset error is below a given precision (ex: 10 cm)
% - Offset Max error

% - Offset absolute mean error compared to GroundTruth In Turn
% - time ratio during which offset error is below a given precision (ex: 10cm) in turn
% - Offset Max error in Turn

% - Offset absolute mean error compared to GroundTruth In Straight Line
% - time ratio during which offset error is below a given precision (ex: 10cm) in Straight Line
% - Offset Max error In Straight Line

function results = errorProcess(measure,reference,measureQuality,referenceQuality,curveFlag,targetPrecision)
    % Only treat good quality measures
    goodQualityMesThrsh     = max(measureQuality).*0.3;
    goodQualityRefThrsh     = max(referenceQuality).*0.3;
    
    indBadQuality      = find(measureQuality<=goodQualityMesThrsh | referenceQuality<=goodQualityRefThrsh | isnan(measure) | isnan(reference));
    
%   
    measure(indBadQuality) = NaN;
    reference(indBadQuality) = NaN;
    
    results       = struct();
    
    % Overall KPI
    results.overall = struct();
    results.overall.error         = abs(measure-reference);
    results.overall.meanError     = nanmean(results.overall.error);
    results.overall.accuracyRatio = nanmean(results.overall.error<targetPrecision);
    results.overall.maxError      = nanmax(results.overall.error);
    
    % In Turn KPI
    results.curve = struct();
    indcurve                   = find(curveFlag==1);
    results.curve.error  = abs(measure(indcurve)-reference(indcurve));
    results.curve.meanError       = nanmean(results.curve.error);
    results.curve.accuracyRatio   = nanmean(results.curve.error<targetPrecision);
    results.curve.maxError        = nanmax(results.curve.error);
    
    % In Straight Line KPI
    results.straight = struct();
    indcurve                        = find(curveFlag==0);
    results.straight.error    = abs(measure(indcurve)-reference(indcurve));
    results.straight.meanError       = nanmean(results.straight.error);
    results.straight.accuracyRatio   = nanmean(results.straight.error<targetPrecision);
    results.straight.maxError        = nanmax(results.straight.error);
end
    