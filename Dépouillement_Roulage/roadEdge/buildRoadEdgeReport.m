import mlreportgen.ppt.*;
if ~exist(reportResultsPath,'dir')
    mkdir(reportResultsPath);
end

fileCommonName = fileName(1:strfind(fileName,'.20')+4);
reportName     = [fileCommonName '_roadEdgeNCAP' '.pptx'];
presentation = Presentation(fullfile(reportResultsPath,reportName),fullfile(currScriptPath,'reports','templateRenault.pptx'));
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
redactor = 'Mathieu Delannoy';
department = 'DEA-TVC3';

chapterTitles = {'FrCam Results','Fusion Results'};
commonSubtitle = cell2mat(strcat({'ZF FrCam : '},{FrCamSW},{' / RSA Fusion : '},{FusionSW}));
chapterSubtitles = {cell2mat(strcat({'ZF FrCam : '},{FrCamSW})),cell2mat(strcat({'RSA Fusion : '},{FusionSW}))};

pptx_addCover(presentation,presentationTitle,presentationSubtitle,department,redactor,dateText);
pptx_addAgenda(presentation,chapterTitles,chapterSubtitles,department,redactor,dateText);

%% FrCam
chapterNum = 1;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);

figureCamName = figureNames(contains({figureFiles.name}','Cam'));
subtitle = chapterSubtitles{chapterNum};
figureName = fullfile(graphResultsPath,figureCamName{1});
pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);

%% Fusion
chapterNum = 2;
pptx_addChapter(presentation,chapterTitles{chapterNum},chapterSubtitles{chapterNum},chapterNum,department,redactor,dateText);

figureFusName = figureNames(contains({figureFiles.name}','Fus'));
subtitle = chapterSubtitles{chapterNum};
figureName = fullfile(graphResultsPath,figureFusName{1});
pptx_addContent(presentation,chapterTitles{chapterNum},subtitle,figureName,department,redactor,dateText);


%%

close(presentation);

if ispc
    winopen(fullfile(reportResultsPath,reportName));
end