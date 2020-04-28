% this script is intended to post process Lateral perception test logs



% PROCESS
% 1. Common process : Name, SW versions, etc...
% 2. Performance Process : C0-C1-C2, etc...
% 3. RoadEdge   : Specific to RoadEdge tests at CTA
% 4. Clustering Process : Line Type, color, Highway Exit, etc...

% SYNTHESIS
%% Parameters to be changed
containsFrCamSignals = true;
containsFusionSignals= true;
adasFunction            = 3; % 1-LCA  /  2-LKA  / 3-Open Loop
resim                   = 0; % 0-Vehicle Analysis  /  1-Resim analysis
vehicleID               = 'Alot HHN 20';
FrCamSW                 = 'SW5.1';
FusionSW                = 'RM5.1';
adasSW                  = '';
track                   = 'HOD'; % Ring / CTA2 / HOD / HWE
testType                = 'Clustering'; % Performance / RoadEdge / Clustering / Robustness / HWE / LS-LM
%% Path parameters
scriptPath = pwd;
functionPath = fullfile(scriptPath,'..','functions');
addpath(functionPath);
run('initParams');
testPath = getTestPath(initPath);
switch testType
    case 'Performance'
        logsPath = fullfile(testPath,logsConvFolderName,groundTruthLogPath);
    case {'RoadEdge','Clustering'}
        logsPath = fullfile(testPath,logsConvFolderName,taggingLogPath);
    otherwise
        error('Unrecognised Test Type');
end
graphResultsPath = fullfile(testPath,graphPath);
currScriptPath = pwd;
%% search files
logFiles = filesearch(logsPath,'mat');
clear clusteringSynthesis commonSynthesis
for f=1:length(logFiles)
    
    fileName = logFiles(f).name;
    fprintf('\n File %d/%d : %s \n',f,length(logFiles),fileName);
    log = load(fullfile(logsPath,fileName));
    rmpath(genpath(currScriptPath)); % Remove all folders of post Process folder from path
    run('commonProcess.m');
    run('buildCommonSynthesis.m');
    switch testType
        case 'Performance'
            addpath(fullfile(currScriptPath,'performance'));
            run('performanceProcess.m');
%             run('buildPerfoReport.m');
            run('buildPerfoSynthesis.m');
            add2Synthesis(synthesisPath,synthesisName,commonSynthesis,perfoSynthesis,'dataPerformance');
        case 'RoadEdge'
            addpath(fullfile(currScriptPath,'roadEdge'));
            if size(find(log.Cam_InfrastructureLines_CamRightLineQuality>100),1) < 0.25*size(find(log.Cam_InfrastructureLines_CamRightLineQuality<=100),1)
                run('roadEdgeProcess.m');
                run('buildRoadEdgeSynthesis.m');
                add2Synthesis(synthesisPath,synthesisName,commonSynthesis,roadEdgeSynthesis,'dataRoadEdge');
            else
                fprintf('\nRoad Edge process cancelled : \n\tThe FrCam wasn"t enough avaible during the log \n');
            end
        case 'Clustering'
            addpath(fullfile(currScriptPath,'clustering'));
            run('clusteringProcess.m');
            run('buildClusteringSynthesis.m');
        otherwise
            error('Unrecognised Test Type');
    end
    
end

switch testType
    case 'Clustering'
        add2Synthesis(synthesisPath,synthesisName,commonSynthesis,clusteringSynthesis,'dataClustering');
end