% this function is intended to convert CANape which don't have common time array

function canCommonTimeArray(canapePathInitial,canapePathNew,fCan)

    initPath = pwd;

    % Liste des fichiers de mesures au format .mat
    List_file = filesearch(canapePathInitial, 'mat');
    
    for fic = 1:length(List_file)
        
        canape    = load(fullfile(List_file(fic).path, List_file(fic).name));
        if ~isfield(canape,'t')
            fprintf('%u/%u %s\n', fic, length(List_file), fullfile(List_file(fic).path, List_file(fic).name) );
            canapeNew = struct();
            fields = fieldnames(canape);
            listTimeArrays = fields(startsWith(fields,'t'));
            
            tBeginAll = [];
            tEndAll   = [];
            for indT = 1:length(listTimeArrays)
                tArray = getfield(canape,listTimeArrays{indT});
                if isTimeArray(tArray)
                    tBeginAll = [tBeginAll;tArray(1)];
                    tEndAll   = [tEndAll;tArray(end)];
                end
            end
            
            if size(tBeginAll,1)<1
                error('No Time Array found');
            end
            
            tCommon = [min(tBeginAll):1/fCan:max(tEndAll)]';
            for indT = 1:length(listTimeArrays)
                indDeviceSignals = find(endsWith(fields,listTimeArrays{indT}));
                deviceSignals = fields(indDeviceSignals);
                deviceSignals = deviceSignals(cellfun(@length,deviceSignals)>length(listTimeArrays{indT}));
                
                
                tOld       = getfield(canape,listTimeArrays{indT});
                
                for s = 1:length(deviceSignals)
                    nameOld = deviceSignals{s};
                    valueOld   = getfield(canape,nameOld);
                    nameNew = nameOld(1:end-length(listTimeArrays{indT})-1);
                    if isa(valueOld,'double')
                        if length(tOld)==1
                            tOldCurr        = [tCommon(1);tCommon(end)];
                            valueOld        = [valueOld;valueOld];
                        else
                            tOldCurr        = tOld;
                        end
                        [tOldCurrUnique indUnique] = unique(tOldCurr);
                        valueNew= interp1(tOldCurr(indUnique),valueOld(indUnique),tCommon);
                    else
                        valueNew= valueOld;
                    end
                    canapeNew = setfield(canapeNew,nameNew,valueNew);
                end
                fields(indDeviceSignals) = [];
            end
            
            if tCommon(1) > 10/fCan
                tCommon = tCommon-floor(tCommon(1));
            end
            canapeNew.t = tCommon;
            
            % Add the remaining fields
            for f=1:length(fields)
                value = getfield(canape,fields{f});
                canapeNew = setfield(canapeNew,fields{f},value);
            end
            
            if ~exist(canapePathNew,'dir')
                mkdir(canapePathNew);
            end
            cd(canapePathNew);
            save(List_file(fic).name,'-struct','canapeNew');
        else
            fprintf('%u/%u file has already a common time array.\n', fic, length(List_file));
            if ~exist(canapePathNew,'dir')
                mkdir(canapePathNew);
            end
            cd(canapePathNew);
            save(List_file(fic).name,'-struct','canape');
        end
    end
    
    cd(initPath);
end

%% FUNCTIONS

function signalIsATimeArray = isTimeArray(signal)
    signalIsATimeArray = false;
    
    if length(signal)==1 && isa(signal,'double') && signal>0
        signalIsATimeArray = true;
    else
        diffSignal = diff(signal);
        sampleTime = mean(diff(signal));
        
        if all(diffSignal>0) && mean(abs(diffSignal-sampleTime)/sampleTime) < 0.2
            signalIsATimeArray = true;
        end
    end
end
        


