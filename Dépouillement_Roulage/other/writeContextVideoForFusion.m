% This script is intended to copy contextual videos of selected tests
% and add Fusion time stamp in it.
% It then save the new video in a specific folder
currScriptPath = pwd;
run('initParams');

testPath = getTestPath(initPath);%% Select test folder
VContextPath = fullfile(testPath,logsConvFolderName,contextVideoFolderName);
canapePath  = fullfile(testPath,logsRawFolderName,canapeFolderName);
newContextPath = fullfile(testPath,'contextForFusion');
%% Re-convert the canape logs (in case they were concatenated)
canapeConversion(canapePath,newContextPath,{},{},0,fCan);

%% Find logs
listVContext = filesearch(VContextPath,'avi');
logCAN  = filesearch(newContextPath,'mat');

%% Find matching logs
nFileMatched = 0;
listCanFile  = struct();
listVContextFile = struct();
for n=1:length(logCAN)
  currentCANfilename = logCAN(n).name;
  timeCaracters=currentCANfilename(end-9:end-6);
  VcontextName={listVContext.name};
  indVContext=find(contains(VcontextName,timeCaracters,'IgnoreCase',true));
  if length(indVContext)==1 % There is a contextual video corresponding to the current .mat
       nFileMatched = nFileMatched+1;
       listCanFile(nFileMatched).name = currentCANfilename;
       listCanFile(nFileMatched).path = newContextPath;
       listCanFile(nFileMatched).time = timeCaracters;
       
       listVContextFile(nFileMatched).name = listVContext(indVContext).name;
       listVContextFile(nFileMatched).path = VContextPath;
       listVContextFile(nFileMatched).time = timeCaracters;
  end
end

%% add fusion time stamp fusion to contextual videos
addTimeStamp(listVContextFile,newContextPath,listCanFile,'externalClockTimestamp');