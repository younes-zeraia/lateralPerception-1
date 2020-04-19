function [projLaneWidth laneWidthQuality] = getProjLaneWidth(projOffsetLeft,projOffsetRight,qualityLeft,qualityRight)
        
    % Only treat good quality measures
    goodQualityLeftThrsh     = max(qualityLeft).*0.1;
    goodQualityRightThrsh     = max(qualityRight).*0.1;
         
    indBadQuality      = find(qualityLeft<=goodQualityLeftThrsh | qualityRight<=goodQualityRightThrsh);
    
%   
    projOffsetLeft(indBadQuality) = NaN;
    projOffsetRight(indBadQuality) = NaN;
    
    laneWidthQuality               = zeros(size(projOffsetLeft))+100;
    laneWidthQuality(indBadQuality)= 0;
         
    projLaneWidth = projOffsetLeft - projOffsetRight;
end

