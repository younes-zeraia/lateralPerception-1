import mlreportgen.ppt.*

presentationTitle = 'Evaluation Performance Perception Laterale';
presentationSubTitle = Paragraph('ZF FrCam ');
FrCamSW = Text('SW5.1');
FrCamSW.Style = {FontColor('red')};
append(presentationSubTitle,FrCamSW);
append(presentationSubTitle,Text('RSA Fusion '));
FusionSW = Text('RM5.1');
FusionSW.Style = {FontColor('red')};
append(presentationSubTitle,FusionSW);

date = '01/05/2020';
redactor = 'Mathieu Delannoy';
department = 'DEA-TVC3';

chapterTitles = {'Histogramms','Offset C0','Yaw C1','Curvature C2','Proj. Offset yL40m','Proj. LaneWidth','ViewRange','Quality'};
chapterSubtitles = {'FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1','FrCam SW5.1 / Fusion RM5.1'};

presentationName = 'myNewPPTPresentationRenault.pptx';
presentation     = Presentation(presentationName,'templateRenault.pptx');

pptx_addCover(presentation,presentationTitle,presentationSubTitle,department,redactor,date);
pptx_addAgenda(presentation,chapterTitles,chapterSubtitles,department,redactor,date);
pptx_addChapter(presentation,chapterTitles{1},chapterSubtitles{1},1,department,redactor,date);
pptx_addContent(presentation,chapterTitles{1},chapterSubtitles{1},'HHN_Alot_20_FRC5.1_RM5.1_EvalFRCam_10.04.2020_155045_total_C0_left.png',department,redactor,date);

close(presentation);

if ispc
    winopen(presentationName);
end