% This function is intended to trim canape logs
% The objective is to get logs of the same length (ex : 90s).
% We trim all logs according to the duration of the 1st one.

function canTrim(canapeFolder)
    initPath = pwd;

    % Liste des fichiers de mesures au format .mat
    List_file = filesearch(canapeFolder, 'mat');
    
     for fic = 1:length(List_file)
        
        canape    = load(fullfile(List_file(fic).path, List_file(fic).name));
        if fic == 1
            prevcanapeDuration = round(canape.t(end));
        else
            recordOffset = canape.t(end)-prevcanapeDuration;
            if recordOffset>1 % There is a record offset
                tIndCommon = find(canape.t>=prevcanapeDuration);

                newCanape.t = canape.t(tIndCommon)-prevcanapeDuration;
                fields    = fieldnames(canape);
                for f = 1:length(fields)
                    name = fields{f};
                    value = getfield(canape,name);
                    if size(value,1)==size(canape.t,1) && ~isequal(name,'t') % All signals except time array
                        newCanape= setfield(newCanape,name,value(tIndCommon));
                    elseif size(value,1)~=size(canape.t,1) % Other value (as date, ID, comment, etc..)
                        newCanape= setfield(newCanape,name,value);
                    end
                end
                
                fprintf('\n %s has been trimmed. \n',List_file(fic).name);
                save(fullfile(List_file(fic).path, List_file(fic).name),'-struct','newCanape');
            end
            prevcanapeDuration = canape.t(end);
        end
     end
end