% This script gather "Performance" synthesis values
header = 1;
roadEdgeSynthesis = {};

%% Right Road Edge Detection 
% Hit %
headerName  = 'R_RE Hit';
valCam      = NCapRoadEdgeResultsCam.rightRoadEdgeHITRatio;
valFus      = NCapRoadEdgeResultsFus.rightRoadEdgeHITRatio;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% FP %
headerName  = 'R_RE FP';
valCam      = NCapRoadEdgeResultsCam.rightRoadEdgeFPRatio;
valFus      = NCapRoadEdgeResultsFus.rightRoadEdgeFPRatio;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% FN %
headerName  = 'R_RE FN';
valCam      = NCapRoadEdgeResultsCam.rightRoadEdgeFNRatio;
valFus      = NCapRoadEdgeResultsFus.rightRoadEdgeFNRatio;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Mean Quality
headerName  = 'R_RE Quality Mean';
valCam      = NCapRoadEdgeResultsCam.secondPhaseQualityMean;
valFus      = NCapRoadEdgeResultsFus.secondPhaseQualityMean;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% Quality Ratio
headerName  = 'R_RE Quality Ratio';
valCam      = NCapRoadEdgeResultsCam.secondPhaseGoodQualityRatio;
valFus      = NCapRoadEdgeResultsFus.secondPhaseGoodQualityRatio;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

%% Next Right Road Edge Detection 
% Hit %
headerName  = 'NR_RE Hit';
valCam      = NCapRoadEdgeResultsCam.nextRightRoadEdgeHITRatio;
valFus      = NCapRoadEdgeResultsFus.nextRightRoadEdgeHITRatio;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% FN %
headerName  = 'R_RE FN';
valCam      = NCapRoadEdgeResultsCam.nextRightRoadEdgeFNRatio;
valFus      = NCapRoadEdgeResultsFus.nextRightRoadEdgeFNRatio;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

% NR-R diff offset
headerName  = 'NR_RE Diff Offset';
valCam      = NCapRoadEdgeResultsCam.diffOffsetMean;
valFus      = NCapRoadEdgeResultsFus.diffOffsetMean;
roadEdgeSynthesis(:,header)    = {headerName,valCam,valFus};
header = header+1;

