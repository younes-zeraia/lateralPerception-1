import mlreportgen.ppt.*;
if ~exist(reportResultsPath,'dir')
    mkdir(reportResultsPath);
end

fileCommonName = fileName(1:strfind(fileName,'.20')+4);
if isempty(fileCommonName)
    fileCommonName = fileName(1:strfind(fileName,'_20')+8);
end
reportName     = [fileCommonName '_roadEdgeNCAP' '.pptx'];
presentation = Presentation(fullfile(reportResultsPath,reportName),fullfile(currScriptPath,'reports','templateRenault.pptx'));
figureFiles = filesearch(graphResultsPath,'png');
figureNames = {figureFiles.name}';
figureRoadEdge = figureNames(contains(figureNames,'RoadEdge'));
presentationTitle = Paragraph('ZF FrCam ');
FrCamSWText = Text(cell2mat(strcat({' '},{FrCamSW},{' '})));
FrCamSWText.Style = {FontColor('red')};
append(presentationTitle,FrCamSWText);
if fusionPresent == 1
    append(presentationTitle,Text('RSA Fusion'));
    FusionSWText = Text(cell2mat(strcat({' '},{FusionSW},{' '})));
    FusionSWText.Style = {FontColor('red')};
    append(presentationTitle,FusionSWText);
end
TestText    = Text(cell2mat(strcat({': '},{testType},{' Test'})));
TestText.Style = {FontColor('white')};
append(presentationTitle,TestText);

presentationSubtitle = Paragraph('Track : ');
trackText = Text(track);
trackText.Style = {FontColor('white')};
append(presentationSubtitle,trackText);

dateText = date;
redactor = 'Perception Lat Team';
department = 'DEA-TVC3';
    

chapterTitles = {'Road Edge NCAP Results'};
% commonSubtitle =  cell2mat(strcat({'ZF FrCam : '},{FrCamSW},{' / RSA Fusion : '},{FusionSW}));
if fusionPresent == 1
    chapterSubtitles = {cell2mat(strcat({'ZF FrCam : '},{FrCamSW},{' / RSA Fusion : '},{FusionSW}))};
else
    chapterSubtitles = {cell2mat(strcat({'ZF FrCam : '},{FrCamSW}))};
end
pptx_addCover(presentation,presentationTitle,presentationSubtitle,department,redactor,dateText);
pptx_addAgenda(presentation,chapterTitles,chapterSubtitles,department,redactor,dateText);

%% FrCam
chapterNum = 1;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);

for f = 1:length(figureRoadEdge)
    figName = figureRoadEdge{f};
    yearInd = strfind(figName,'.20');
    if all(size(yearInd) == [0,0])
        yearInd = strfind(figName,'_20');
        figHour = figName(yearInd+10:yearInd+13);
    else
        
        figHour = figName(yearInd+6:yearInd+9);
    end
    
    
    if contains(figureRoadEdge(f),'_Cam_')
        title = cell2mat(strcat({'ZF FrCam : '},{FrCamSW}));
    elseif contains(figureRoadEdge(f),'_Fus_')
        title = cell2mat(strcat({'RSA Fusion : '},{FusionSW}));
    end
    subtitle = cell2mat(strcat({'Trial '},{num2str(f)},{' - '},{figHour(1:2)},{':'},{figHour(3:4)}));

    figureName = fullfile(graphResultsPath,figName);
    pptx_addContent(presentation,title,subtitle,figureName,department,redactor,dateText);

end


% %% FrCam
% chapterNum = 1;
% pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% 
% figureCamName = figureNames(contains({figureFiles.name}','Cam'));
% subtitle = chapterSubtitles{chapterNum};
% figureName = fullfile(graphResultsPath,figureCamName{1});
% pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
% 
% %% Fusion
% chapterNum = 2;
% pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% 
% figureFusName = figureNames(contains({figureFiles.name}','Fus'));
% subtitle = chapterSubtitles{chapterNum};
% figureName = fullfile(graphResultsPath,figureFusName{1});
% pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);


%%

close(presentation);

if ispc
    winopen(fullfile(reportResultsPath,reportName));
end