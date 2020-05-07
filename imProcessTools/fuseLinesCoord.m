% This script is intended to "fuse" several times numerized lines.
% The fusion is just an average value of the nLines (gathered by distances)
% whose we retrieved the absurd values (error > X cm)

% Creator : Mathieu DELANNOY - RENAULT - 2020

%% Path definition
scriptPath = pwd;
functionPath = fullfile(scriptPath,'..','functions');
addpath(functionPath);
run('initParams');
testPath    = getTestPath(initPath);

imProcessLinesPath = fullfile(testPath,logsConvFolderName,imProcessFolderName,lineXYCoordFolderName);

%% Load files
imProcessLinesFiles = filesearch(imProcessLinesPath,'mat',0);
clear imProcessLines
for currL = 1:length(imProcessLinesFiles)
    imProcessLines(currL)      = load(fullfile(imProcessLinesPath,imProcessLinesFiles(currL).name));
end

%% Coord Matching (according to distance to the 1st line)
leftLine_x      = zeros(length(imProcessLines(1).xLineLeft),length(imProcessLinesFiles));
rightLine_x     = zeros(length(imProcessLines(1).xLineRight),length(imProcessLinesFiles));
leftLine_y      = zeros(length(imProcessLines(1).yLineLeft),length(imProcessLinesFiles));
rightLine_y     = zeros(length(imProcessLines(1).yLineRight),length(imProcessLinesFiles));
yawAngles       = zeros(length(imProcessLines(1).vehHeading),length(imProcessLinesFiles));

% First line saving
leftLine_x(:,1) = imProcessLines(1).xLineLeft;
rightLine_x(:,1)= imProcessLines(1).xLineRight;
leftLine_y(:,1) = imProcessLines(1).yLineLeft;
rightLine_y(:,1)= imProcessLines(1).yLineRight;
yawAngles(:,1)  = imProcessLines(1).vehHeading;

if length(imProcessLinesFiles)>1
    % Other line saving
    for currL=2:length(imProcessLinesFiles)
        indLeftMatch = coordMatching(imProcessLines(1).xLineLeft ,imProcessLines(1).yLineLeft,imProcessLines(currL).xLineLeft ,imProcessLines(currL).yLineLeft);
        indRightMatch = coordMatching(imProcessLines(1).xLineRight ,imProcessLines(1).yLineRight,imProcessLines(currL).xLineRight ,imProcessLines(currL).yLineRight);


        leftLine_x(:,currL) = imProcessLines(currL).xLineLeft(indLeftMatch);
        rightLine_x(:,currL)= imProcessLines(currL).xLineRight(indRightMatch);
        leftLine_y(:,currL) = imProcessLines(currL).yLineLeft(indLeftMatch);
        rightLine_y(:,currL)= imProcessLines(currL).yLineRight(indRightMatch);
        yawAngles(:,currL)  = imProcessLines(currL).vehHeading(indRightMatch);
    end
end

%% average compute
aveLeftLine_x   = mean(leftLine_x,2);
aveLeftLine_y   = mean(leftLine_y,2);
aveRightLine_x  = mean(rightLine_x,2);
aveRightLine_y  = mean(rightLine_y,2);
aveYawAngle     = mean(yawAngles,2);

%% from world coordinates to average Line local reference
leftLine_u      = leftLine_x.*0;
rightLine_u     = rightLine_x.*0;
leftLine_v      = leftLine_y.*0;
rightLine_v     = rightLine_y.*0;

aveYawLeft      = estimateHeading(aveLeftLine_x,aveLeftLine_y);
aveYawRight     = estimateHeading(aveRightLine_x,aveRightLine_y);
        
for currL = 1:length(imProcessLinesFiles)
    [leftLine_u(:,currL),leftLine_v(:,currL)]   = transformCoord(leftLine_x(:,currL),leftLine_y(:,currL),aveLeftLine_x,aveLeftLine_y,aveYawLeft);
    [rightLine_u(:,currL),rightLine_v(:,currL)] = transformCoord(rightLine_x(:,currL),rightLine_y(:,currL),aveRightLine_x,aveRightLine_y,aveYawRight);
end

%% Fuse line according to errors
% precision = 0.1;
% leftLineGoodPrecision = leftLine_v<precision;
% rightLineGoodPrecision = rightLine_v<precision;
% 
% fusLeftLine_x = sum(leftLine_x.*leftLineGoodPrecision,2)./sum(leftLineGoodPrecision,2);
% fusLeftLine_y = sum(leftLine_y.*leftLineGoodPrecision,2)./sum(leftLineGoodPrecision,2);
% 
% fusRightLine_x = sum(rightLine_x.*rightLineGoodPrecision,2)./sum(rightLineGoodPrecision,2);
% fusRightLine_y = sum(rightLine_y.*rightLineGoodPrecision,2)./sum(rightLineGoodPrecision,2);