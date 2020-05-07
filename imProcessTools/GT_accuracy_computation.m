% This script intends to estimate the Ground truth accuracy

%% Path
scriptPath = pwd;
functionPath = fullfile(scriptPath,'..','functions');
addpath(functionPath);
run('initParams');
testPath    = getTestPath(initPath);

imProcessLinesPath = fullfile(testPath,logsConvFolderName,imProcessFolderName,lineXYCoordFolderName);
referenceLinesPath = 'C:\Users\a029799\OneDrive - Alliance\Bureau\Perception_Laterale\3_RT\02_Fichiers_Lignes\Lignes Numérisées CTA\Anneau_20190628';
%% Load Files
imProcessLinesFiles = filesearch(imProcessLinesPath,'mat',0);
imProcessLines      = load(fullfile(imProcessLinesPath,imProcessLinesFiles(1).name));
referenceLineRight   = load(fullfile(referenceLinesPath,'VRD_xy.mat'));
referenceLineLeft  = load(fullfile(referenceLinesPath,'VRG_xy.mat'));

leftLineMes_xy      = [imProcessLines.xLineLeft imProcessLines.yLineLeft];
rightLineMes_xy     = [imProcessLines.xLineRight imProcessLines.yLineRight];

leftLineRef_XY      = referenceLineLeft.VRG_xy;
rightLineRef_XY     = referenceLineRight.VRD_xy;
%% Map Matching
indMatchLeft    = coordMatching(leftLineMes_xy(:,1),leftLineMes_xy(:,2),leftLineRef_XY(:,1),leftLineRef_XY(:,2));
indMatchRight   = coordMatching(rightLineMes_xy(:,1),rightLineMes_xy(:,2),rightLineRef_XY(:,1),rightLineRef_XY(:,2));

leftLineRef_XY  = leftLineRef_XY(indMatchLeft,:);
rightLineRef_XY = rightLineRef_XY(indMatchRight,:);
%% From World Coordinates to Vehicle Coordinates
% estimation of measure yaw angle
% yawLeft = estimateHeading(leftLineMes_xy(:,1),leftLineMes_xy(:,2));
% yawRight= estimateHeading(rightLineMes_xy(:,1),rightLineMes_xy(:,2));
yawVeh  = imProcessLines.vehHeading;

% Translation to measure origin
leftLineRef_XY0 = leftLineRef_XY - leftLineMes_xy;
rightLineRef_XY0= rightLineRef_XY - rightLineMes_xy;

% Rotation to Vehicle reference
cos_yaw = cos(yawVeh);
sin_yaw = sin(yawVeh);

leftLineRef_x   = leftLineRef_XY0(:,1).*cos_yaw + leftLineRef_XY0(:,2).*sin_yaw;
leftLineRef_y   = -leftLineRef_XY0(:,1).*sin_yaw + leftLineRef_XY0(:,2).*cos_yaw;

rightLineRef_x  = rightLineRef_XY0(:,1).*cos_yaw + rightLineRef_XY0(:,2).*sin_yaw;
rightLineRef_y  = -rightLineRef_XY0(:,1).*sin_yaw + rightLineRef_XY0(:,2).*cos_yaw;
%% Y error process
meanErrLeft = mean(abs(leftLineRef_y(find(~isnan(leftLineRef_y)))));
meanErrRight= mean(abs(rightLineRef_y(find(~isnan(rightLineRef_y)))));

leftLineRef_y_filt  = neighboorFilt(leftLineRef_y,10);
rightLineRef_y_filt = neighboorFilt(rightLineRef_y,10);
%% Results Plot
figError = figure;
hold on
grid minor
axErr(1) = gca;

plot(axErr(1),leftLineRef_y_filt);
plot(axErr(1),rightLineRef_y_filt);
legend(axErr(1),'Left Lateral Error','Right Lateral Error');
ylabel(axErr(1),'Lateral Position error (m)');
xlabel(axErr(1),'n Samples');
title(axErr(1),strcat('Lateral Error of Home made numerized Lines : Left average error = \color{red}',...
                      num2str(meanErrLeft),'\color{black} m - Right average error = \color{red}',...
                      num2str(meanErrRight),'\color{black} m'));