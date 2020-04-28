indGoodQualityLeft = find(log.QualityLineLeft>0);
indGoodQualityRight= find(log.QualityLineRight>0);

lateralErrorLeft = log.PositionLineLeft(indGoodQualityLeft)-log.Cam_InfrastructureLines_CamLeftLineOffset(indGoodQualityLeft);
lateralErrorRight= log.PositionLineRight(indGoodQualityRight)-log.Cam_InfrastructureLines_CamRightLineOffset(indGoodQualityRight);

relativeHeadingLeft = (log.LeftLineYawAngle(indGoodQualityLeft)-log.Cam_InfrastructureLines_CamLeftLineYawAngle(indGoodQualityLeft))*180/pi;
relativeHeadingRight= (log.RightLineYawAngle(indGoodQualityRight)-log.Cam_InfrastructureLines_CamRightLineYawAngle(indGoodQualityRight))*180/pi;

curvatureErrorLeft  = log.CurvatureLineLeft(indGoodQualityLeft)-log.Cam_InfrastructureLines_CamLeftLineCurvature(indGoodQualityLeft);
curvatureErrorRight = log.CurvatureLineRight(indGoodQualityRight)-log.Cam_InfrastructureLines_CamRightLineCurvature(indGoodQualityRight);

derCurvatureErrorLeft   = log.CurvatureDerivativeLineLeft(indGoodQualityLeft)-log.Cam_InfrastructureLines_CamLeftLineCurvatureRate(indGoodQualityLeft);
derCurvatureErrorRight  = log.CurvatureDerivativeLineRight(indGoodQualityRight)-log.Cam_InfrastructureLines_CamRightLineCurvatureRate(indGoodQualityRight);

viewRangeErrorLeft      = log.ViewRangeLineLeft(indGoodQualityLeft)-log.Cam_InfrastructureLines_CamLeftLineEndViewRange(indGoodQualityLeft);
viewRangeErrorRight     = log.ViewRangeLineRight(indGoodQualityRight)-log.Cam_InfrastructureLines_CamRightLineEndViewRange(indGoodQualityRight);

projPosErrorLeft         = projOffsetFusLeft(indGoodQualityLeft) - projOffsetCamLeft(indGoodQualityLeft);
projPosErrorRight        = projOffsetFusRight(indGoodQualityRight) - projOffsetCamRight(indGoodQualityRight);

figHist = figure('units','normalized','outerposition',[0 0 1 1]);

axHist(1) = subplot(2,3,1);
axHist(2) = subplot(2,3,2);
axHist(3) = subplot(2,3,3);
axHist(4) = subplot(2,3,4);
axHist(5) = subplot(2,3,5);
axHist(6) = subplot(2,3,6);
grid(axHist(1),'minor');
grid(axHist(2),'minor');
grid(axHist(3),'minor');
grid(axHist(4),'minor');
grid(axHist(5),'minor');
grid(axHist(6),'minor');
hold(axHist(1),'on');
hold(axHist(2),'on');
hold(axHist(3),'on');
hold(axHist(4),'on');
hold(axHist(5),'on');
hold(axHist(6),'on');

xlabel(axHist(1),'Position error [m]');
xlabel(axHist(2),'Heading error [deg]');
xlabel(axHist(3),'Curvature error [1/m^{-1}]');
xlabel(axHist(4),'Curvature Rate error [1/m^{-2}]');
xlabel(axHist(5),'viewRange Error [m]');
xlabel(axHist(6),'Projected Position Error [m]');

histogram(axHist(1),lateralErrorLeft,[-1:0.01:1]);
% histogram(axHist(1),lateralErrorRight,[-1:0.01:1]);
xlim(axHist(1),[-0.5,0.5]);

histogram(axHist(2),relativeHeadingLeft,[-5:0.05:5]);
% histogram(axHist(2),relativeHeadingRight,[-5:0.05:5]);
xlim(axHist(2),[-2.5,2.5]);

histogram(axHist(3),curvatureErrorLeft,[-0.002:0.00001:0.001]);
% histogram(axHist(3),curvatureErrorRight,[-0.002:0.00001:0.001]);
xlim(axHist(3),[-0.0004,0.0004]);

histogram(axHist(4),derCurvatureErrorLeft,[-0.00002:0.0000001:0.000035]);
% histogram(axHist(4),derCurvatureErrorLeft,[-0.00002:0.0000001:0.00002]);
xlim(axHist(4),[-5*10^-6,5*10^-6]);

histogram(axHist(5),viewRangeErrorLeft,[-80:0.5:80]);
% histogram(axHist(5),viewRangeErrorRight,[-80:0.5:80]);
xlim(axHist(5),[-30,30]);

histogram(axHist(6),projPosErrorLeft,[-4:0.04:4]);
% histogram(axHist(6),projPosErrorRight,[-4:0.04:4]);
xlim(axHist(6),[-2,2]);

title(axHist(1),'HIST plot error c0');
title(axHist(2),'HIST plot error c1');
title(axHist(3),'HIST plot error c2');
title(axHist(4),'HIST plot error c3');
title(axHist(5),'HIST plot error viewRange');
title(axHist(6),'HIST plot error yL 40m');

%% Mean process
% Lateral Error
lateralErrorLeftResults.mean    = nanmean(lateralErrorLeft);
lateralErrorLeftResults.std     = nanstd(lateralErrorLeft);
lateralErrorLeftResults.max     = nanmax(lateralErrorLeft);
lateralErrorLeftResults.min     = nanmin(lateralErrorLeft);
lateralErrorLeftResults.var     = nanvar(lateralErrorLeft);

lateralErrorRightResults.mean   = nanmean(lateralErrorRight);
lateralErrorRightResults.std    = nanstd(lateralErrorRight);
lateralErrorRightResults.max    = nanmax(lateralErrorRight);
lateralErrorRightResults.min    = nanmin(lateralErrorRight);

% Heading
relativeHeadingLeftResults.mean = nanmean(relativeHeadingLeft);
relativeHeadingLeftResults.std  = nanstd(relativeHeadingLeft);
relativeHeadingLeftResults.max  = nanmax(relativeHeadingLeft);
relativeHeadingLeftResults.min  = nanmin(relativeHeadingLeft);

relativeHeadingRightResults.mean= nanmean(relativeHeadingRight);
relativeHeadingRightResults.std = nanstd(relativeHeadingRight);
relativeHeadingRightResults.max = nanmax(relativeHeadingRight);
relativeHeadingRightResults.min = nanmin(relativeHeadingRight);

% Curvature
curvatureErrorLeftResults.mean = nanmean(curvatureErrorLeft);
curvatureErrorLeftResults.std  = nanstd(curvatureErrorLeft);
curvatureErrorLeftResults.max  = nanmax(curvatureErrorLeft);
curvatureErrorLeftResults.min  = nanmin(curvatureErrorLeft);

curvatureErrorRightResults.mean = nanmean(curvatureErrorRight);
curvatureErrorRightResults.std  = nanstd(curvatureErrorRight);
curvatureErrorRightResults.max  = nanmax(curvatureErrorRight);
curvatureErrorRightResults.min  = nanmin(curvatureErrorRight);

% Curvature Rate
derCurvatureErrorLeftResults.mean = nanmean(derCurvatureErrorLeft);
derCurvatureErrorLeftResults.std  = nanstd(derCurvatureErrorLeft);
derCurvatureErrorLeftResults.max  = nanmax(derCurvatureErrorLeft);
derCurvatureErrorLeftResults.min  = nanmin(derCurvatureErrorLeft);

derCurvatureErrorRightResults.mean = nanmean(derCurvatureErrorRight);
derCurvatureErrorRightResults.std  = nanstd(derCurvatureErrorRight);
derCurvatureErrorRightResults.max  = nanmax(derCurvatureErrorRight);
derCurvatureErrorRightResults.min  = nanmin(derCurvatureErrorRight);

% viewRange
viewRangeErrorLeftResults.mean = nanmean(viewRangeErrorLeft);
viewRangeErrorLeftResults.std  = nanstd(viewRangeErrorLeft);
viewRangeErrorLeftResults.max  = nanmax(viewRangeErrorLeft);
viewRangeErrorLeftResults.min  = nanmin(viewRangeErrorLeft);

viewRangeErrorRightResults.mean = nanmean(viewRangeErrorRight);
viewRangeErrorRightResults.std  = nanstd(viewRangeErrorRight);
viewRangeErrorRightResults.max  = nanmax(viewRangeErrorRight);
viewRangeErrorRightResults.min  = nanmin(viewRangeErrorRight);

% proj Position
projPosErrorLeftResults.mean = nanmean( projPosErrorLeft);
projPosErrorLeftResults.std  = nanstd( projPosErrorLeft);
projPosErrorLeftResults.max  = nanmax( projPosErrorLeft);
projPosErrorLeftResults.min  = nanmin( projPosErrorLeft);

projPosErrorRightResults.mean = nanmean( projPosErrorRight);
projPosErrorRightResults.std  = nanstd( projPosErrorRight);
projPosErrorRightResults.max  = nanmax( projPosErrorRight);
projPosErrorRightResults.min  = nanmin( projPosErrorRight);
