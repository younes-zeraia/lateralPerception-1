function viewRangeResults = viewRangeProcess(measure,measureQuality,inTurn)
    goodQualityMesThrsh     = max(measureQuality).*0.3;
    
    indBadQuality           = find(measureQuality<=goodQualityMesThrsh);
%   
    measure(indBadQuality)  = NaN;
    viewRangeResults        = getErrorResults(measure);
    
    %In Turn
    indInTurn               = find(inTurn>0);
    viewRangeResults.curve  = getErrorResults(measure(indInTurn));
    
    %In Straight line
    indInStraightLine           = find(inTurn<1);
    viewRangeResults.straight   = getErrorResults(measure(indInStraightLine));
end
function Results = getErrorResults(measure)
    Results.array = (measure);
    Results.mean  = nanmean(Results.array);
    Results.max   = nanmax(Results.array);
    Results.min   = nanmin(Results.array);
    Results.std   = nanstd(Results.array);
end
    