% this function is intended to add PPK correction for RT logs
% Modified the 10/03/2020 by M. Delannoy - RENAULT

function addPPKMeasure(canapePath,rtPath,fRTPPK)
    %% Search Files
    if exist(rtPath,'dir')==7
        csvFiles         = filesearch(rtPath,'csv');
    else
        fprintf('\n No PPK correction directory -> keep raw GPS datas \n');
        return;
    end
    canapeFiles      = filesearch(canapePath,'mat');
    nCanapeFiles     = length(canapeFiles);
    indBeginLogs     = zeros(nCanapeFiles,1);
    indEndLogs       = zeros(nCanapeFiles,1);

    for f = 1 :length(csvFiles)
        currFile = csvFiles(f);
        ppkTypeRaw = csvFiles(f).name(1:end-4);
        last_pos   = find(ppkTypeRaw == '_',1,'last');
        ppkType  = char(extractAfter(ppkTypeRaw,last_pos));

        if ~isequal(ppkType,'SIMULATED') && ~isequal(ppkType,'COMBINED')
            ppkType = 'SIMULATED';
        end

        csvFileTable = getcsvFileTable(fullfile(currFile.path,currFile.name),2,2);

        for c = 1 : nCanapeFiles
            fprintf('%d/%d File : %s \n',c,nCanapeFiles,canapeFiles(c).name);
            canape = load(fullfile(canapePath,canapeFiles(c).name));

%             if isfield(canape,'TimeSecond')
%                 indNextSecond = find(diff(canape.TimeSecond(1:101)~=0))+1;
%             elseif isfield(canape,'seconds')
%                 
%             end

            % Synchronisation (we assume the log happened during 1 day)
            % UTC time format : dd/mm/yyyy hh:mm:ss.fff
            headersName = fieldnames(csvFileTable);
            indUTCTime = 1;
            UTCtimeFound = false;
            f = 0;
            while UTCtimeFound == false && f<length(headersName)
                f = f+1;
                if contains(headersName{f},'mmssfff')
                    UTCtimeFound = true;
                    indUTCTime = f;
                end
            end

            gpsTimeFound = false;
            f = 0;
            while gpsTimeFound == false && f<length(headersName)
                f = f+1;
                if contains(headersName{f},'gpsns')
                    gpsTimeFound = true;
                    indGPSTime = f;
                end
            end

            if gpsTimeFound && isfield(canape,'MilliTime')
                csvGPSTimeMs   = getfield(csvFileTable,headersName{indGPSTime})./10^6;
                canBeginTimeMs  = canape.MilliTime(1);
                canEndTimeMS    = canape.MilliTime(end);

                csvInd          = csvGPSTimeMs/10;
                canBeginInd     = canBeginTimeMs/10;
                canEndInd       = canEndTimeMS/10;
            else
                csv.utcTime  = cell2mat(getfield(csvFileTable,headersName{indUTCTime}));
                if length(csv.utcTime)>12
                    csv.TimeHour = str2num(csv.utcTime(12:13));
                    csv.TimeMin  = str2num(csv.utcTime(15:16));
                    csv.TimeSec  = str2num(csv.utcTime(18:22));
                else
                    csv.TimeHour = str2num(csv.utcTime(1:2));
                    csv.TimeMin  = str2num(csv.utcTime(4:5));
                    csv.TimeSec  = str2num(csv.utcTime(7:12));
                end
                csvInd          = getcsvInd(csv.TimeHour,csv.TimeMin,csv.TimeSec,fRTPPK);
                if isfield(canape,'TimeHour') && isfield(canape,'TimeMinute') && isfield(canape,'TimeSecond') && isfield(canape,'TimeHSecond')
                    if isfield(canape,'seconds')
                        indFirstNextSecond = find(diff(canape.seconds(1:fRTPPK+1))~=0)+1;
                        HSeconds_1 = (fRTPPK-mod(indFirstNextSecond-1,fRTPPK))/fRTPPK-1/fRTPPK;
                        canBeginInd     = getcsvInd(canape.TimeHour(1),canape.TimeMinute(1),canape.seconds(1)+HSeconds_1,fRTPPK);
                        indLastSecond = find(diff(canape.seconds(end-fRTPPK:end))~=0)+1;
                        HSeconds_end = (fRTPPK-mod(indLastSecond-1,fRTPPK))/fRTPPK-1/fRTPPK;
                        canEndInd       = getcsvInd(canape.TimeHour(end),canape.TimeMinute(end),canape.seconds(end)+HSeconds_end,fRTPPK);
                    else
                        canBeginInd     = getcsvInd(canape.TimeHour(1),canape.TimeMinute(1),canape.TimeSecond(1)+canape.TimeHSecond(1),fRTPPK);
                        canEndInd       = getcsvInd(canape.TimeHour(end),canape.TimeMinute(end),canape.TimeSecond(end)+canape.TimeHSecond(end),fRTPPK);
                    end
                elseif isfield(canape,'hour') && isfield(canape,'minutes') && isfield(canape,'seconds')
                      error('missing signals in the log (timeHour, timeMinute, timeSecond, etc..');
%                     indFirstNextSecond = find(diff(canape.seconds(1:fRTPPK+1))~=0)+1;
%                     HSeconds_1 = (fRTPPK-mod(indFirstNextSecond-1,fRTPPK))/fRTPPK-1/fRTPPK;
%                     
%                     indLastSecond = find(diff(canape.seconds(end-fRTPPK:end))~=0)+1;
%                     HSeconds_end = (fRTPPK-mod(indLastSecond-1,fRTPPK))/fRTPPK-1/fRTPPK;
%                     
%                     canBeginInd     = getcsvInd(canape.hour(1)-2,canape.minutes(1),canape.seconds(1)+HSeconds_1,fRTPPK);
%                     canEndInd       = getcsvInd(canape.hour(end)-2,canape.minutes(end),canape.seconds(end)+HSeconds_end,fRTPPK);
            end




            indBeginLogs(c) = ceil((canBeginInd-csvInd));
            indEndLogs(c)   = ceil((canEndInd-csvInd));

            csvFileTable_c = getcsvFileTable(fullfile(currFile.path,currFile.name),indBeginLogs(c),indEndLogs(c));

            tcsv = [0:size(csvFileTable_c.Latitudedeg,1)-1]'./fRTPPK;

            latField = strcat('PosLat',ppkType);
            lonField = strcat('PosLon',ppkType);
            altField = strcat('PosAlt',ppkType);
            yawField = strcat('AngleHeading',ppkType);

            canape = setfield(canape,latField,interp1(tcsv,csvFileTable_c.Latitudedeg,canape.t));
            canape = setfield(canape,lonField,interp1(tcsv,csvFileTable_c.Longitudedeg,canape.t));
            canape = setfield(canape,altField,interp1(tcsv,csvFileTable_c.Altitudem,canape.t));
            canape = setfield(canape,yawField,interp1(tcsv,csvFileTable_c.Headingdeg,canape.t));

            save(fullfile(canapePath,canapeFiles(c).name),'-struct','canape');
        end
    end
end