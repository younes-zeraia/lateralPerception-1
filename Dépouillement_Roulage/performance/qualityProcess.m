function qualityResults = qualityProcess(quality,inTurn)
    goodQualityMesThrsh     = max(quality).*0.1;
    
    goodQuality             = quality>goodQualityMesThrsh;
    
    qualityResults.overall  = nanmean(goodQuality);
    
    %In Turn
    indInTurn               = find(inTurn>0);
    qualityResults.curve     = nanmean(goodQuality(indInTurn));
    
    %In Straight line
    
    indInStraightLine       = find(inTurn<1);
    qualityResults.straight = nanmean(goodQuality(indInStraightLine));
end