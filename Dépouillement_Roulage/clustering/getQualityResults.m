function qualityResults = getQualityResults(quality,qualityMax,indCamActive)
    qualityResults.qualityMean      = mean(quality(indCamActive));
    qualityResults.qualityGoodRatio = nanmean(quality(indCamActive)>=(qualityMax.*0.25));
end