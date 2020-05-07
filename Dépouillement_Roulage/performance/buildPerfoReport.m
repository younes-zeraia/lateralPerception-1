import mlreportgen.ppt.*;
if ~exist(reportResultsPath,'dir')
    mkdir(reportResultsPath);
end

fileCommonName = fileName(1:strfind(fileName,'.20')+4);
reportName     = [fileCommonName '_performance' '.pptx'];
presentation = Presentation(fullfile(reportResultsPath,reportName),'templateRenault');
figureFiles = filesearch(graphResultsPath,'png');
figureNames = {figureFiles.name}';

presentationTitle = Paragraph('ZF FrCam ');
FrCamSWText = Text(cell2mat(strcat({' '},{FrCamSW},{' '})));
FrCamSWText.Style = {FontColor('red')};
append(presentationTitle,FrCamSWText);
append(presentationTitle,Text('RSA Fusion'));
FusionSWText = Text(cell2mat(strcat({' '},{FusionSW},{' '})));
FusionSWText.Style = {FontColor('red')};
append(presentationTitle,FusionSWText);
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

chapterTitles = {'Histogramms','Offset C0','Yaw C1','Curvature C2','Proj. Offset yL40m','Proj. LaneWidth','ViewRange','Quality'};
commonSubtitle = cell2mat(strcat({'ZF FrCam : '},{FrCamSW},{' / RSA Fusion : '},{FusionSW}));
chapterSubtitles = {commonSubtitle,commonSubtitle,commonSubtitle,commonSubtitle,commonSubtitle,commonSubtitle,commonSubtitle,commonSubtitle};


pptx_addCover(presentation,presentationTitle,presentationSubtitle,department,redactor,dateText);
pptx_addAgenda(presentation,chapterTitles,chapterSubtitles,department,redactor,dateText);

%% Histograms
chapterNum = 1;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Cam GT
figureHistogramsCamGTNames = figureNames(contains({figureFiles.name}','histCamGT'));
subtitle = cell2mat(strcat({'ZF FrCam '},{FrCamSW},{' VS GroundTruth'}));
for f=1
    figureName = fullfile(graphResultsPath,figureHistogramsCamGTNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

% Fus GT
figureHistogramsFusGTNames = figureNames(contains({figureFiles.name}','histFusGT'));
subtitle = cell2mat(strcat({'RSA Fusion '},{FusionSW},{' VS GroundTruth'}));
for f=1
    figureName = fullfile(graphResultsPath,figureHistogramsFusGTNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

% Fus Cam
figureHistogramsFusCamNames = figureNames(contains({figureFiles.name}','histFusCam'));
subtitle = cell2mat(strcat({'RSA Fusion '},{FusionSW},{' VS '},{'ZF FrCam '},{FrCamSW}));
for f=1
    figureName = fullfile(graphResultsPath,figureHistogramsFusCamNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

%% Offset
chapterNum = 2;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Left
figureOffsetLeftNames = figureNames(contains({figureFiles.name}','_C0_left') & ~contains({figureFiles.name}','_Proj_C0_'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureOffsetLeftNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

% Right
figureOffsetRightNames = figureNames(contains({figureFiles.name}','_C0_right') & ~contains({figureFiles.name}','_Proj_C0_'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureOffsetRightNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

%% Yaw Angle
chapterNum = 3;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Left
figureYawLeftNames = figureNames(contains({figureFiles.name}','_C1_left'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureYawLeftNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

% Right
figureYawRightNames = figureNames(contains({figureFiles.name}','_C1_right'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureYawRightNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end 

%% Curvature
chapterNum = 4;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Left
figureCurvatureLeftNames = figureNames(contains({figureFiles.name}','_C2_left'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureCurvatureLeftNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

% Right
figureCurvatureRightNames = figureNames(contains({figureFiles.name}','_C2_right'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureCurvatureRightNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

%% Projected Offset
chapterNum = 5;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Left
figureProjOffsetLeftNames = figureNames(contains({figureFiles.name}','Proj_C0_left'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureProjOffsetLeftNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

% Right
figureProjOffsetRightNames = figureNames(contains({figureFiles.name}','Proj_C0_right'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureProjOffsetRightNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

%% Projected Lanewidth
chapterNum = 6;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);

figureProjLaneWidthNames = figureNames(contains({figureFiles.name}','Proj_LaneWidth'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureProjLaneWidthNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

%% ViewRange
chapterNum = 6;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Left
figureViewRangeNames = figureNames(contains({figureFiles.name}','viewRange'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureViewRangeNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end

%% Quality
chapterNum = 7;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);
% Left
figureQualiltyNames = figureNames(contains({figureFiles.name}','quality'));
subtitle = commonSubtitle;
for f=1
    figureName = fullfile(graphResultsPath,figureQualiltyNames{f});
    pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);
end


%%

close(presentation);

if ispc
    winopen(fullfile(reportResultsPath,reportName));
end