% %% Path
% currScriptPath = pwd;
% reportPath     = fullfile(currScriptPath,'..','templateReports');
% 
% %%
% import mlreportgen.ppt.*; % Import ppt package name
% % slidesFile = fullfile(reportPath,'template_report_performance_FrCam_Fusion.pptx');
% % slides = Presentation(slidesFile, slidesFile);
% % open(slides);
% 
% slidesFile = fullfile('C:\Users\a029799\OneDrive - Alliance\Bureau\Perception_Laterale\6_Depouillement','templatePerfoTest.pptx');
% slides = Presentation(slidesFile, slidesFile);
% open(slides);
% 
% slide1 = slides.Children(1);
% 
% contents = find(slide1,'Title');
% contents = Paragraph('Modified Content Slide');
% 
% contents = find(slide1,'Content');
% datePara = Paragraph('Fourth item: Updated item');
% 
% add(contents,datePara);
% 
% %%
% 
% import mlreportgen.ppt.*
% slidesFile = 'myTemplate.pptx';
% slides = Presentation('myTemplate');
% 
% open(slides);
% 
% close(slides);
% if ispc
%     winopen(slidesFile);
% end


%%
cd('C:\Users\a029799\OneDrive - Alliance\Bureau\Perception_Laterale\6_Depouillement');
import mlreportgen.ppt.*;
slidesFile = 'myNewPPTPresentation.pptx';
slides = Presentation(slidesFile,'myTemplate');
presentationTitleSlide = add(slides,'Diapositive de titre');
replace(presentationTitleSlide,'Titre 1','Create Histogram Plots');
subtitleText = Paragraph('The ');
funcName = Text('histogram');
funcName.Font = 'Courier New';

append(subtitleText,funcName);
append(subtitleText,' Function');
replace(presentationTitleSlide,'Subtitle',subtitleText);
close(slides);
if ispc
    winopen(slidesFile);
end
%% SLide with picture
x = randn(10000,1);
h = histogram(x);

saveas(gcf,'myPlot_img.png');

plot1 = Picture('myPlot_img.png');

pictureSlide = add(slides,'Titre et contenu');
replace(slides,'Title','Histogram of Vector');
contents = find(pictureSlide,'Content');
replace(contents(1),plot1);