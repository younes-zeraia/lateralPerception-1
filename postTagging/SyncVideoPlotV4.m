% function [] = SyncVideoPlotV4(testpath,workdir)
% Script permettant de lancer une interface graphique de "post tagging".
% Les fichiers utilisés par cette interface sont :
% - une liste de fichiers .mat contenant chacun une liste de signaux (size = [n,1]) et vecteur temps commun (size = [n,1]).
% - une liste de vidéo de context au format .avi
% - une liste de vidéos Vbox dont le chemin d'accès, le nom , le début et
% la fin correspondant à chaque fichier .mat est renseigné dans le fichier .mat.
% Auteur : Younes ZERAIA - UTAC CERAM
% Modification : Mathieu DELANNOY - RENAULT
% Inspiré de l'outil "SynVideoPlot-v3" de Jeremy GONDRY - RENAULT
% 01/04/2020
%% paths
currPath = pwd;
if ~exist('functionPath','var')
    functionPath  = fullfile(currPath,'..','functions');
    addpath(functionPath);
end
run('initParams');
testPath = getTestPath(initPath);
VContextPath        = fullfile(testPath,logsConvFolderName,contextVideoFolderName);
VvboxPath           = fullfile(testPath,logsConvFolderName,lateralVideoFolderName);
canapePath          = fullfile(testPath,logsConvFolderName,canapeFolderName);
canapeTaggingPath   = fullfile(testPath,logsConvFolderName,taggingLogPath);
currPath = pwd;
addpath(fullfile(currPath,'gui'));
addpath(fullfile(currPath,'gui','imgs'));

%% CANape file List builder
logCAN          = filesearch(canapePath,'mat');
listVContext    = filesearch(VContextPath,'avi');
% listVvbox       = filesearch(VvboxPath,'mp4');

%% Sélection des fichiers .mat et vidéos contextuelles qui correspondent
nFileMatched = 0;
listCanFile  = struct();
listVContextFile = struct();
for n=1:length(logCAN)
  currentCANfilename = logCAN(n).name;
  timeCaracters=currentCANfilename(end-9:end-6);
  VcontextName={listVContext.name};
  indVContext=find(contains(VcontextName,['_' timeCaracters],'IgnoreCase',true));
  if length(indVContext)==1 % There is a contextual video corresponding to the current .mat
       nFileMatched = nFileMatched+1;
       listCanFile(nFileMatched).name = currentCANfilename;
       listCanFile(nFileMatched).path = canapePath;
       listCanFile(nFileMatched).time = timeCaracters;
       
       listVContextFile(nFileMatched).name = listVContext(indVContext).name;
       listVContextFile(nFileMatched).path = VContextPath;
       listVContextFile(nFileMatched).time = timeCaracters;
  end
end 
% global signals


%% Input Format Check
for n=1:nFileMatched
    % contextual video
    videoContextextName=listVContextFile(n).name;
    [x1 videofileContext x3]=fileparts(videoContextextName);
    if ~ischar(videofileContext)
        error('The video file must be a string');
    end

    if length(videofileContext) < 5
        error('The video file must be at least 5 characters long');
    end

    if ~strcmp(videoContextextName(end-3:end), '.avi') && ~strcmp(videoContextextName(end-3:end), '.mp4')
        error('Video format must be .avi or .mp4');
    end

    % .mat file
    matfileext = listCanFile(n).name;
    [x1 matfile x3]=fileparts(matfileext);
    if ~ischar(matfile)
        error('The .mat file must be a string');
    end

    if length(matfile) < 5
        error('The .mat file must be at least 5 characters long');
    end

    if ~strcmp(matfileext(end-3:end), '.mat')
        error('.mat file must be of .mat format');
    end

end

%% create a structure with .path .name and .date to each file
mainV4(listCanFile,listVContextFile,canapeTaggingPath);