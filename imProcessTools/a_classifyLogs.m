% This script classify all PPLat logs in a specific way

% Input : Test Folder Path :
%         .
%         +-- Canape logs       (.mat)
%         +-- Context Videos    (.avi)
%         +-- Vbox Videos       (.mp4 or .avi)
%         +-- Vbox file         (.vbo)
%         +-- RT PPK correction (.csv)
%         +-- ITS(1-2-3-4) :
%         |   +-- Canape ITS(1-2-3-4) logs (.mat)

% Outputs : Test Folder :
%           .
%           +-- logsRaw
%           |   +-- canape (contains .MF4 and raw .mat files).
%           |   +-- vbo (contains .vbo)
%           |   +-- video (contains vbox .vid that didn't match the log).
%           +-- logsConv
%           |   +-- canape (contains converted canape .mat files)
%           |   +-- contextVideo (contains contextual videos)
%           |   +-- lateralVideo (contains vbox videos that matched the canape file)
%           |   +-- vbo (contains .vbo converted in .mat).
%           +-- ITS(1-2-3-4) :
%           |   +-- Canape ITS(1-2-3-4) logs (.mat)

%% Path parameters
currScriptPath = pwd;
functionPath = fullfile(currScriptPath,'..','functions');
addpath(functionPath);
run('initParams');

testPath = getTestPath(initPath);%% User QUestion
concatenateUserAnswer = questdlg('Concatener les capsules pour cet essai ?');
if isequal(concatenateUserAnswer,'Cancel')
    error('Processus interrompu');
end

if isequal(concatenateUserAnswer,'Yes')
    concatenateCANapeLogs = 1;
else
    concatenateCANapeLogs = 0;
end
%% Logs converted folder creation
cd(testPath);
if ~exist(fullfile(testPath,logsConvFolderName),'dir');
    mkdir(logsConvFolderName);
end
cd(fullfile(testPath,logsConvFolderName));
if ~exist(canapeFolderName,'dir');
    mkdir(canapeFolderName);
end
if ~exist(fullfile(testPath,logsConvFolderName,vboFolderName),'dir');
    mkdir(vboFolderName);
end
if ~exist(fullfile(testPath,logsConvFolderName,contextVideoFolderName),'dir');
    mkdir(contextVideoFolderName);
end
if ~exist(fullfile(testPath,logsConvFolderName,lateralVideoFolderName),'dir');
    mkdir(lateralVideoFolderName);
end
cd(testPath);
[status msg] = movefile('*FC.avi',fullfile(testPath,logsConvFolderName,contextVideoFolderName));

%%  Logs raw folder creation
cd(testPath);
if ~exist(fullfile(testPath,logsRawFolderName),'dir');
    mkdir(logsRawFolderName);
end
cd(fullfile(testPath,logsRawFolderName));
if ~exist(fullfile(testPath,logsRawFolderName,canapeFolderName),'dir');
    mkdir(canapeFolderName);
end
if ~exist(fullfile(testPath,logsRawFolderName,videoFolderName),'dir');
    mkdir(videoFolderName);
end
if ~exist(fullfile(testPath,logsRawFolderName,vboFolderName),'dir');
    mkdir(vboFolderName);
end
cd(testPath);
[status msg] = movefile('*.mat',fullfile(logsRawFolderName,canapeFolderName));
[status msg] = movefile('*.MF4',fullfile(logsRawFolderName,canapeFolderName));
[status msg] = movefile('*.mdf',fullfile(logsRawFolderName,canapeFolderName));
[status msg] = movefile('*.avi',fullfile(logsRawFolderName,videoFolderName));
[status msg] = movefile('*.mp4',fullfile(logsRawFolderName,videoFolderName));
[status msg] = movefile('*.vbo',fullfile(logsRawFolderName,vboFolderName));
[status msg] = movefile('*.csv',fullfile(logsRawFolderName,rtFolderName));

%% FIND ITS records
ITSDir = dir('ITS*');
ITSRawFolders = {};
ITSConvFolders= {};
for i=1:length(ITSDir)
    listMat = filesearch(fullfile(ITSDir(i).folder,ITSDir(i).name),'mat');
    if ~isempty(listMat) % The ITS folder contains mat files
        ITSMatFolder = fullfile(testPath,logsRawFolderName,ITSDir(i).name);
        if ~exist(ITSMatFolder,'dir')
            mkdir(ITSMatFolder);
        end
        ITSRawFolders = [ITSRawFolders;fullfile(ITSDir(i).folder,ITSDir(i).name)];
        ITSConvFolders= [ITSConvFolders;ITSMatFolder];
    end
end

%% VBO conversion from .vbo to .mat
vbo2mat_mde(fullfile(testPath,logsRawFolderName,vboFolderName),fullfile(testPath,logsConvFolderName),vboFolderName);

%% CANape conversion (common time array + Concatenation if specified by user)
%% Calibrations right and left


canapeConversion(fullfile(testPath,logsRawFolderName,canapeFolderName),fullfile(testPath,logsConvFolderName,canapeFolderName),fullfile(testPath,logsConvFolderName,canapeConcatenatedFolderName),...
                 ITSRawFolders,ITSConvFolders,concatenateCANapeLogs,fCan,maxDuration);

%% Synchro vbox video with canape log
if concatenateCANapeLogs == 0
    synchroVboxforCanape(fullfile(testPath,logsConvFolderName,vboFolderName),fullfile(testPath,logsConvFolderName,canapeFolderName),fullfile(testPath,logsRawFolderName,videoFolderName),...
                          fullfile(testPath,logsConvFolderName,lateralVideoFolderName),fVbo,fCan,fVid);
else
    synchroVboxforCanape(fullfile(testPath,logsConvFolderName,vboFolderName),fullfile(testPath,logsConvFolderName,canapeConcatenatedFolderName),fullfile(testPath,logsRawFolderName,videoFolderName),...
                          fullfile(testPath,logsConvFolderName,lateralVideoFolderName),fVbo,fCan,fVid);
end

%% Add ppk measure
if concatenateCANapeLogs == 0
    addPPKMeasure(fullfile(testPath,logsConvFolderName,canapeFolderName),fullfile(testPath,logsRawFolderName,rtFolderName),fRTPPK);
else
    addPPKMeasure(fullfile(testPath,logsConvFolderName,canapeConcatenatedFolderName),fullfile(testPath,logsRawFolderName,rtFolderName),fRTPPK);
end

msgbox('Conversion des acquis des terminée !', 'Fini');
cd(currScriptPath)