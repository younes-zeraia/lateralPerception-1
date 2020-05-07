% This script gather "RoadEdge" synthesis values
[Headers valCam] = struct2CellArray(NCapRoadEdgeResultsCam);
if fusionPresent == 1
    [trash       valFus] = struct2CellArray(NCapRoadEdgeResultsFus);
end

if ~exist('roadEdgeSynthesis','var')
    if fusionPresent == 1
        roadEdgeSynthesis = [Headers;valCam;valFus];
    else
        roadEdgeSynthesis = [Headers;valCam];
    end
else
    if fusionPresent == 1
        roadEdgeSynthesis = [roadEdgeSynthesis;valCam;valFus];
    else
        roadEdgeSynthesis = [roadEdgeSynthesis;valCam];
    end
end
% %% Right Road Edge Detection 
% % Hit %
% Headers  = [Headers {'R_RE Hit'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.rightRoadEdgeHITRatio}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.rightRoadEdgeHITRatio}];
% 
% % FP %
% Headers  = [Headers {'R_RE FP'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.rightRoadEdgeFPRatio}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.rightRoadEdgeFPRatio}];
% % FN %
% Headers  = [Headers {'R_RE FN'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.rightRoadEdgeFNRatio}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.rightRoadEdgeFNRatio}];
% 
% % Mean Quality when GroundTruth RoadEdge (right)
% Headers  = [Headers {'R_RE_GT Quality Mean'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.secondPhaseQualityMean}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.secondPhaseQualityMean}];
% 
% % Mean Quality when Measure RoadEdge (right)
% Headers  = [Headers {'R_RE_Mes Quality Mean'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.roadEdgeQualityMean}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.roadEdgeQualityMean}];
% 
% % Quality Ratio
% Headers  = [Headers {'R_RE Good Quality Ratio'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.secondPhaseGoodQualityRatio}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.secondPhaseGoodQualityRatio}];
% 
% %% Next Right Road Edge Detection 
% % Hit %
% Headers  = [Headers {'NR_RE Hit'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.nextRightRoadEdgeHITRatio}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.nextRightRoadEdgeHITRatio}];
% 
% % FN %
% Headers  = [Headers {'NR_RE FN'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.nextRightRoadEdgeFNRatio}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.nextRightRoadEdgeFNRatio}];
% 
% % NR-R diff offset
% Headers  = [Headers {'NR_RE Diff Offset'}];
% valCam      = [valCam {NCapRoadEdgeResultsCam.diffOffsetMean}];
% valFus      = [valFus {NCapRoadEdgeResultsFus.diffOffsetMean}];
% 
% %% Create or concatenate synthesis
