% this function is intended to add the slide "Chapter" from the Renault
% .pptx template.

% Inputs : title , subtitle , num

% Ouput : none.

function pptx_addChapter(presentation,title,subtitle,num,department,redactor,date)
    import mlreportgen.ppt.*
    
    presentationChapterSlide = add(presentation,'CHAPTER');
    replace(presentationChapterSlide,'Title',title);
    replace(presentationChapterSlide,'Subtitle',subtitle);
    if num < 10
        numText = ['0' num2str(num)];
    else
        numText = num2str(num);
    end
    replace(presentationChapterSlide,'Num',numText);
    replace(presentationChapterSlide,'DepartmentRedactorDate',[department '/' redactor ' / ' date]);
end