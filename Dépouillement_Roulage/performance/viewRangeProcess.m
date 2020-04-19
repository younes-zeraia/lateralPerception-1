function viewRangeResults = viewRangeProcess(measure,measureQuality,inTurn)
    goodQualityMesThrsh     = max(measureQuality).*0.3;
    
    indBadQuality      = find(measureQuality<=goodQualityMesThrsh);
%   
    measure(indBadQuality) = NaN;
    viewRangeResults.overall = nanmean(measure);
    
    %In Turn
    indInTurn               = find(inTurn>0);
    viewRangeResults.curve     = nanmean(measure(indInTurn));
    
    %In Straight line
    
    indInStraightLine       = find(inTurn<1);
    viewRangeResults.straight = nanmean(measure(indInStraightLine));
end
    