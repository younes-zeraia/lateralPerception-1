% this function is intended to add the slide "COVER DARK PATTERN" from the Renault
% .pptx template.

% Inputs : presentation hande , title, subtitle, date, redactor, department

% Ouput : none.

function pptx_addCover(presentation,title,subtitle,department,redactor,date)
    import mlreportgen.ppt.*
    
    presentationTitleSlide = add(presentation,'COVER DARK PATTERN');
    replace(presentationTitleSlide,'Title',title);
    replace(presentationTitleSlide,'Subtitle',subtitle);
    replace(presentationTitleSlide,'TextDate',date);
    replace(presentationTitleSlide,'TextRedactor',redactor);
    replace(presentationTitleSlide,'TextDepartment',department);
end