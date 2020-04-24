%% Parameters to be changed
cameraParamsName    = 'vbox_HD_originalResolution.mat';
% imageCalibLeftName  = 'VBOXHD_Left_0224.jpg';
% imageCalibRightName = 'VBOXHD_Right_0224.jpg';
%% paths
scriptPath = pwd;
calibCamPath = [scriptPath '\imProcess_tools\cameraCalibration'];
functionPath = fullfile(scriptPath,'..','functions');
addpath(functionPath);
run('initParams');
testPath = getTestPath(initPath);
videosPath = fullfile(testPath,logsRawFolderName,lateralVideoFolderName);
canapePath = fullfile(testPath,logsConvFolderName,canapeFolderName);

%% load files
filesInDir = dir(videosPath);
canapeFiles = filesearch(canapePath,'mat');
videosFiles = filesInDir(3:end);

% %% file match
% indVideo = [];
% indCan = [];
% for countCan=1:length(canapeFiles)
%     videoFound = false;
%     countVid = 0;
%     while videoFound == false && countVid<length(videosFiles)
%         countVid = countVid + 1;
%         videoFound = contains(videosFiles(countVid).name(1:end-4),canapeFiles(countCan).name(1:end-4));
%     end
%     if videoFound == true
%         indVideo = [indVideo;countVid];
%         indCan = [indCan;countCan];
%     end
% end
% canapeFiles = canapeFiles(indCan);
%% Calibrations right and left
calibrated = questdlg('Nouvelle calibration Caméra ?');
if isequal(calibrated,'Cancel')
    error('Processus interrompu');
end

if isequal(calibrated,'Yes')
    vboxCalibrationPath = getTestPath(initPath);
    videoCalibLeftName =  uigetfile(fullfile(vboxCalibrationPath,'*.avi;*.mp4'), 'Selection Video Calibration Gauche', 'MultiSelect', 'off', vboxCalibrationPath) ;
    videoCalibRightName =  uigetfile(fullfile(vboxCalibrationPath,'*.avi;*.mp4'), 'Selection Video Calibration Droite', 'MultiSelect', 'off', vboxCalibrationPath) ;
    if ~exist(fullfile(calibCamPath,'old'));
        mkdir(fullfile(calibCamPath,'old'));
    end
    movefile(fullfile(calibCamPath,'*.jpg'),fullfile(calibCamPath,'old'));
    imageCalibLeftName = videoCalibSave(vboxCalibrationPath,videoCalibLeftName,calibCamPath,cropParams.leftWindow,cropParams.resizeWindow,'vboxCalibLeft');
    imageCalibRightName= videoCalibSave(vboxCalibrationPath,videoCalibRightName,calibCamPath,cropParams.rightWindow,cropParams.resizeWindow,'vboxCalibRight');
else
    imageCalibLeftName =  uigetfile(fullfile(calibCamPath,'*.jpg'), 'Selection Image Calibration Gauche', 'MultiSelect', 'off', calibCamPath) ;
    imageCalibRightName=  uigetfile(fullfile(calibCamPath,'*.jpg'), 'Selection Image Calibration Droite', 'MultiSelect', 'off', calibCamPath) ;
end
%% Calibration files
load([calibCamPath '\' cameraParamsName]);
cameraParamsNameNoMat = cameraParamsName(1:end-4);
VboxHDcameraParams = eval(cameraParamsNameNoMat);
imageRefLeft    = imread([calibCamPath '\' imageCalibLeftName]);
imageRefRight   = imread([calibCamPath '\' imageCalibRightName]);


try %R2019b
    intrinsincts = VboxHDcameraParams.Intrinsics;
catch % R2016b
    intrinsincts = VboxHDcameraParams;
end



[imageRefUndistLeft newOriginsLeft] = undistortImage(imageRefLeft,VboxHDcameraParams);
[imagePointsLeft, boardSize] = detectCheckerboardPoints(imageRefUndistLeft);
worldPoints = generateCheckerboardPoints(boardSize, checkerBoardSquareSize);
imagePointsLeft = imagePointsLeft + newOriginsLeft;
imagePointsLeftXSort = sortrows(imagePointsLeft,1);
imagePointsLeftsorted = zeros(size(imagePointsLeft,1),2);
for i=1:3:size(imagePointsLeft,1)
    try %R2019
        imagePointsLeftsorted(i:i+2,:) = sortrows(imagePointsLeftXSort(i:i+2,:),2,'descend');
    catch
        imagePointsLeftsorted(i:i+2,:) = sortrows(imagePointsLeftXSort(i:i+2,:),-2);
    end
end
[RLeft tLeft]       = extrinsics(imagePointsLeftsorted,worldPoints,intrinsincts);
CalibLeft.camParams = VboxHDcameraParams;
CalibLeft.R            = RLeft;
CalibLeft.t            = tLeft;

[imageRefUndistRight newOriginsRight] = undistortImage(imageRefRight,VboxHDcameraParams);
[imagePointsRight, boardSize] = detectCheckerboardPoints(imageRefUndistRight);
imagePointsRight = imagePointsRight + newOriginsRight;
imagePointsRightXSort = sortrows(imagePointsRight,1);
imagePointsRightsorted = zeros(size(imagePointsRight,1),2);
for i=1:3:size(imagePointsRight,1)
    try % R2019b
        imagePointsRightsorted(i:i+2,:) = sortrows(imagePointsRightXSort(i:i+2,:),2,'descend');
    catch
        imagePointsRightsorted(i:i+2,:) = sortrows(imagePointsRightXSort(i:i+2,:),-2);
    end
end
[RRight tRight]       = extrinsics(imagePointsRightsorted,worldPoints,intrinsincts);
CalibRight.camParams = VboxHDcameraParams;
CalibRight.R            = RRight;
CalibRight.t            = tRight;
cd(scriptPath);
%% Detect Lines
for f = 1:length(canapeFiles)
    canapeFileName = canapeFiles(f).name;
    [yLeftInt,yLeftExt,yRightInt,yRightExt,leftLineType,rightLineType,yRefreshedLeft,yRefreshedRight] = detectLinesTopView(canapeFiles(f).path,canapeFileName(1:end-4),pointWheel_px_Left,pointWheel_px_Right,CalibLeft,CalibRight,VehWidth,cropParams);
    
    [yLeftIntFilt,yLeftExtFilt,yRightIntFilt,yRightExtFilt] = filterLines(yLeftInt,yLeftExt,yRightInt,yRightExt,yRefreshedLeft,yRefreshedRight);
    
    lines.yLeftInt = yLeftIntFilt;
    lines.yLeftExt = yLeftExtFilt;
    lines.yRightInt= yRightIntFilt;
    lines.yRightExt= yRightExtFilt;
    lines.leftLineType = leftLineType;
    lines.rightLineType= rightLineType;
    
    cd(fullfile(testPath,logsConvFolderName));
    if ~exist(imProcessFolderName,'dir');
        mkdir(imProcessFolderName);
    end
    cd(fullfile(testPath,logsConvFolderName,imProcessFolderName));
    save(canapeFileName,'-struct','lines');
    cd(scriptPath);
end