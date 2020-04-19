% This script classify all logs in a specified folder

%% Path parameters
scriptPath = pwd;
functionPath = fullfile(scriptPath,'..','functions');
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


canapeConversion(fullfile(testPath,logsRawFolderName,canapeFolderName),fullfile(testPath,logsConvFolderName,canapeFolderName),...
                 ITSRawFolders,ITSConvFolders,concatenateCANapeLogs,fCan);

%% Synchro vbox video with canape log
synchroVboxforCanape(fullfile(testPath,logsConvFolderName,vboFolderName),fullfile(testPath,logsConvFolderName,canapeFolderName),fullfile(testPath,logsRawFolderName,videoFolderName),...
                      fullfile(testPath,logsConvFolderName,lateralVideoFolderName),fVbo,fCan,fVid);
msgbox('Conversion des acquis des terminée !', 'Fini');
cd(scriptPath)