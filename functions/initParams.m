% This script initialize all parameters used for Lateral Perception scripts

%% Paths
currPath = pwd;
if exist('functionPath','var')==0
    currPathSplit = regexp(currPath,'\','split');
    indScript     = find(contains(currPathSplit,'Depouillement_Eval_FrCam_Fusion'));
    scriptPath    = strjoin(currPathSplit(1:indScript),'\');
    functionPath  = fullfile(scriptPath,'functions');
    addpath(functionPath);
end


initPath = 'M:\1_Essais_FrCam';
% initPath = 'C:\Users\a029799\OneDrive - Alliance\Bureau\Perception_Laterale\2_Essais';
logsRawFolderName   = 'logsRaw';
logsConvFolderName  = 'logsConv';
canapeFolderName    = 'canape';
canapeSplittedFolderName = 'canape_split';
canapeRawFolderName = 'canapeRaw';
canapeRawBisFolderName = 'canapeRawBis';
videoFolderName     = 'video';
contextVideoFolderName = 'contextVideo';
lateralVideoFolderName = 'lateralVideo';
vboFolderName       = 'vbo';
rtFolderName        = 'RT';
imProcessFolderName = 'ImProcessing';
lineXYCoordFolderName = 'lineXYCoord';
groundTruthLogPath  = 'canape_w_GroundTruth';
taggingLogPath      = 'canape_w_Tagging';


% Synthesis
synthesisPath = 'C:\Users\a029799\Alliance\Métier Prestation Perception Latérale - 9_Synthèse_essais';
synthesisName = 'ZF_FrCam_RSA_Fusion_Performances_synthesis.xlsx';

graphPath           = 'graph';
reportPath          = 'report';


% Synchro video/canape log
severalVidForOneCan = 0;

%% Graphical user interface


%% Sample frequencies
fVbo = 10;
fCan = 100;
fVid = 30;
fRTPPK = 100;
%% Image processing
VehWidth = 1.897; % JFC² + Diff Offset observed on FrCam Results
wheelBase    = 2.884; % JFC²
windowWidth = 30; % Whatever you want.

cropParams.leftWindow = [4 545 951 531]; % Window for video crop Left
cropParams.rightWindow= [964 544 951 531]; % Window for video crop Right
cropParams.resizeWindow = [250 350]; % Video Downgraded resolution (for faster process)

% pointWheel_px_Left  = [175 225]; % Left Wheel Reference position in Left video
% pointWheel_px_Right = [176 225]; % Right Wheel Reference position in Right video

% pointWheel_px_Left  = [468 476]; % Left Wheel Reference position in Left video
pointWheel_px_Left  = [468 459]; % Left Wheel Reference position in Left video
% pointWheel_px_Right = [468 476]; % Right Wheel Reference position in Right video
pointWheel_px_Right = [492 489]; % Right Wheel Reference position in Right video

checkerBoardSquareSize = 100; % mm

%% Line XY Coordinates

% Front wheels positions from vbox antenna 

xWhL_VBO_m = 0.4;
xWhR_VBO_m = 0.4;

yWhL_VBO_m = 1.508;
yWhR_VBO_m = -0.389;

% Front wheels positions from RT antenna

xWhL_RT_m = 1.914;
xWhR_RT_m = 1.914;
% xWhL_RT_m = 1.783;
% xWhR_RT_m = 1.783;

% yWhL_RT_m = 0.9585;
% yWhR_RT_m = -0.9385;
yWhL_RT_m = 0.899;
yWhR_RT_m = -0.899;


%% Poly Fit

viewRange   = 40; %m
nHeading    = 10; %nb points took in account for heading estimation

filtC0      = 10;
filtC1      = 20;
filtC2      = 75;
filtC3      = 100;

%% Post Process
% Performance
beginR  = 2000; % Radius threshold of turn beginning
endR    = 3000;% Radius threshold of turn end
offsetTargetPrecision   = 0.1; % target precision of line offset in m
yawAngleTargetPrecision = 0.5*pi/180; % Target precision of line yaw Angle (0.0175 rad -> 1°)
projOffsetTargetPrecision = 0.1;% target precision of projected line offset in m
projLaneWidthTargetPrecision = 0.2; % pro precision of projected lane width in m
distProjLaneWidth       = 40; % Distance of LaneWidth Projection in m
laneWidthLowThrsh       = 2.5;% laneWidth threshold to disconnect the LCA in m

% Clustering
param.undecided         = 0;
param.solidLine         = 1;
param.roadEdge          = 2;
param.dashedLine        = 3;
param.doubleLane        = 4;
param.bottsDots         = 5;
param.barrier           = 6;
param.white             = 1;
param.yellow            = 2;
param.blue              = 3;