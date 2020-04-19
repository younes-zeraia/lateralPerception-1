% This fuction is intended to synchronize vbox video with corresponding CAN logs
% The signal used is "velocity" available in both vbo.mat and canape.mat logs

% The output is the can logs has new variables :
% log.vboxVideoFile :       Name of the corresponding video
% log.vboxVideoFrameBegin : video frame corresponding to its first sample
% log.vboxVideoFrameEnd :   video frame corresponding to its last sample

% Creation : Mathieu DELANNOY - RENAULT - 2020

synchroVboxCan(vboPath,canapePath,videoPath,severalVidForOneCan,fVbo,fCan,fVid);

if severalVidForOneCan == 0 % If several CAN logs correspond to one video
    [canFiles videoFiles canBegin canEnd frameBegin frameEnd] = synchroVidforCANape(vboPath,canapePath,videoPath,fVbo,fCan,fVid);
else % If several videos correspond to one CAN log
    if ~exist(fullfile(logsRawPath,canapeRawFolderName),'dir');
        mkdir(fullfile(logsRawPath,canapeRawFolderName));
        canapeRawPath = fullfile(logsRawPath,canapeRawFolderName);
    elseif ~exist(fullfile(logsRawPath,canapeRawBisFolderName))
        mkdir(fullfile(logsRawPath,canapeRawBisFolderName));
        canapeRawPath = fullfile(logsRawPath,canapeRawBisFolderName);
    end
    cd(fullfile(logsRawPath,canapeFolderName));
    [status msg] = movefile('*.mat',canapeRawPath);
    synchroCANapeforVid(fullfile(logsConvPath,vboFolderName),canapeRawPath,fullfile(logsRawPath,canapeFolderName),[logsRawPath '\' videoFolderName],fVbo,fCan);
end