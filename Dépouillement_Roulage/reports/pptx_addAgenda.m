% this function is intended to add the slide "Agenda" from the Renault
% .pptx template.

% Inputs : {Chapter titles} , {Chapter subtitles}

% Ouput : none.

% The function create as many titles as {Chapter titles} defines (up to 10).
% For each chapter, add the corresponding subtitle if it's different from NaN

function pptx_addAgenda(presentation,titles,subtitles,department,redactor,date)
    import mlreportgen.ppt.*
    
    presentationAgendaSlide = add(presentation,'AGENDA');
    replace(presentationAgendaSlide,'Title','AGENDA');
    replace(presentationAgendaSlide,'DepartmentRedactorDate',[department '/' redactor ' / ' date]);
    for i = 1:length(titles)
        if i < 10
            currNum = ['0' num2str(i)];
        else
            currNum = num2str(i);
        end
        currTitle = titles{i};
        currSubtitle = subtitles{i};
        
        replace(presentationAgendaSlide,['ChapterNum' num2str(i)],currNum);
        replace(presentationAgendaSlide,['ChapterTitle' num2str(i)],currTitle);
        replace(presentationAgendaSlide,['ChapterSubtitle' num2str(i)],currSubtitle);
    end
end