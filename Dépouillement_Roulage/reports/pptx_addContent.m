% this function is intended to add the slide "1 COLUMN" from the Renault
% .pptx template.

% Inputs : presentation hande , title, subtitle, Image Name, date, redactor, department

% Ouput : none.

function pptx_addContent(presentation,title,subtitle,imageName,department,redactor,date)
    import mlreportgen.ppt.*

    titleParagraph = Paragraph(title);
    subtitleText   = Text(cell2mat(strcat({' - '},{subtitle})));
    subtitleText.Style = {FontColor('#ffc000')};
    append(titleParagraph,subtitleText);
    
    contentSlide = add(presentation,'1 COLUMN');
    
    replace(contentSlide,'Title',titleParagraph);
    replace(contentSlide,'DepartmentRedactorDate',[department '/' redactor ' / ' date]);
    contents = find(contentSlide,'Content');
    image   = Picture(imageName);
    replace(contents(1),image);
end