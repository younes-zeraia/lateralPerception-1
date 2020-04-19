%% paths
currScriptPath = pwd;
functionPath = fullfile(scriptPath,'..','functions');
guiPath      = fullfile(scriptPath,'..','graphical_user_interface');
addpath(functionPath);
addpath(guiPath);
run('initParams');
testPath = getTestPath(initPath);
lineDataPath = fullfile(testPath,logsConvFolderName,imProcessFolderName,lineXYCoordFolderName);
canapePath = fullfile(testPath,logsConvFolderName,canapeFolderName);
convertedLogsPath = fullfile(testPath,logsConvFolderName,groundTruthLogPath);

%% load files
lineDataFiles = filesearch(lineDataPath,'mat');
canapeFiles  = filesearch(canapePath,'mat');

%% Params
filterPolyCoefs = [filtC3 filtC2 filtC1 filtC0]; 
for f = 1:length(lineDataFiles)
    fileName = lineDataFiles(f).name;
    lineData = load(fullfile(lineDataPath,fileName));
    canape   = load(fullfile(canapePath,fileName));
    [leftLine rightLine] = numLineFit(lineData,nHeading,viewRange,lineDataPath,fileName);
% [C3 C2 C1 C0]

    %% Filter signals
    for i=1:4
        eval(['leftLineFilt.C' num2str(4-i) '= neighboorFilt(leftLine(:,i),filterPolyCoefs(i));']);
        eval(['rightLineFilt.C' num2str(4-i) '= neighboorFilt(rightLine(:,i),filterPolyCoefs(i));']);
    end
    tVid = [0:1:length(lineData.xLineLeft)-1]/fVid;
    tCan = canape.t;
    
    laneWidth = neighboorFilt(lineData.offsetLineLeft-lineData.offsetLineRight,20);
    tlaneWidth = tVid(1:length(laneWidth));
    
    
    canape.GT_leftLineOffset    = interp1(tVid,lineData.offsetLineLeft,tCan);
    canape.GT_leftLineYawAngle  = interp1(tVid,(leftLineFilt.C1),tCan);
    canape.GT_leftLineCurvature = interp1(tVid,(leftLineFilt.C2),tCan);
    canape.GT_leftLineDerivativeCurvature = interp1(tVid,(leftLineFilt.C3),tCan);
    canape.GT_leftLineType      = interp1(tVid,lineData.leftLineType,tCan);
    canape.GT_leftLineWidth     = interp1(tVid,lineData.lineWidthLeft,tCan);
    
    canape.GT_leftC0Raw         = interp1(tVid(100:end-100),leftLine(100:end-100,4),tCan);
    canape.GT_leftC1Raw         = interp1(tVid(100:end-100),leftLine(100:end-100,3),tCan);
    canape.GT_leftC2Raw         = interp1(tVid(100:end-100),leftLine(100:end-100,2),tCan);
    canape.GT_leftC3Raw         = interp1(tVid(100:end-100),leftLine(100:end-100,1),tCan);
    
    canape.GT_rightC0Raw         = interp1(tVid(100:end-100),rightLine(100:end-100,4),tCan);
    canape.GT_rightC1Raw         = interp1(tVid(100:end-100),rightLine(100:end-100,3),tCan);
    canape.GT_rightC2Raw         = interp1(tVid(100:end-100),rightLine(100:end-100,2),tCan);
    canape.GT_rightC3Raw         = interp1(tVid(100:end-100),rightLine(100:end-100,1),tCan);
    
    canape.GT_rightLineOffset = interp1(tVid,lineData.offsetLineRight,tCan);
    canape.GT_rightLineYawAngle = interp1(tVid(1:length(rightLineFilt.C1)),(rightLineFilt.C1),tCan);
    canape.GT_rightLineCurvature= interp1(tVid(1:length(rightLineFilt.C2)),(rightLineFilt.C2),tCan);
    canape.GT_rightLineDerivativeCurvature = interp1(tVid(1:length(rightLineFilt.C3)),(rightLineFilt.C3),tCan);
    canape.GT_rightLineType     = interp1(tVid,lineData.rightLineType,tCan);
    canape.GT_rightLineWidth    = interp1(tVid,lineData.lineWidthRight,tCan);
    
    canape.GT_laneWidth         = interp1(tlaneWidth,laneWidth,tCan);
%     

    % Left GT line quality
    leftQuality                 = (abs(leftLine(:,4))<5 &...
                                  abs(leftLine(:,3))<0.15 &...
                                  abs(leftLine(:,2))<0.01 &...
                                  abs(leftLine(:,1))<0.0001)*100;
    rightQuality                = (abs(rightLine(:,4))<5 &...
                                  abs(rightLine(:,3))<0.15 &...
                                  abs(rightLine(:,2))<0.01 &...
                                  abs(rightLine(:,1))<0.0001)*100;
    
    canape.GT_leftLineQuality   = interp1(tVid,leftQuality,tCan);
    canape.GT_rightLineQuality  = interp1(tVid,rightQuality,tCan); 
    
%     delays = [0 0 0 0];
%     leftLineFilt = zeros(size(leftLine,1),4);
%     rightLineFilt= zeros(size(rightLine,1),4);
%     delays = zeros(1,4);
%     for i=1:size(filterPolyCoefs,2)
%         kernel = ones(filterPolyCoefs(i),1) / filterPolyCoefs(i);
%         leftLineFilt(:,i) = filter(kernel, 1, leftLine(:,i));
%         rightLineFilt(:,i) = filter(kernel, 1, rightLine(:,i));
%         delays(i) = ceil(mean(grpdelay(kernel)));
% 
%         leftLineRescaled{i} = leftLine(1:end-delays(i),i);
%         rightLineRescaled{i}= rightLine(1:end-delays(i),i);
% 
%         leftLineFiltRescaled{i} = leftLineFilt(delays(i):end,i);
%         rightLineFiltRescaled{i}= rightLineFilt(delays(i):end,i);
%     end
%     delay = ceil(max(delays));
%     leftLineFilt = zeros(size(leftLine,1)-delay,4);
%     rightLineFilt = zeros(size(rightLine,1)-delay,4);
%     for i=1:4
%         leftLineFilt(:,i) = leftLineFiltRescaled{i}(1:size(leftLine,1)-delay);
%         rightLineFilt(:,i)= rightLineFiltRescaled{i}(1:size(rightLine,1)-delay);
%     end

    cd(fullfile(testPath,logsConvFolderName));
    if ~exist(convertedLogsPath,'dir');
        mkdir(convertedLogsPath);
    end
    cd(convertedLogsPath);
    
    save(fileName,'-struct','canape');
    cd(testPath);
end
cd(currScriptPath)
