% This function is intended to convert .mat canape files
% Raw files : .mat file with potentially different time arrays (_t01,_t02,...)
% Conv file : .mat file with common time array (t) AND :
%             if concatenateCANapeLogs==1 : Concatenate all logs to a single one.

function canapeConversion(canapeRawFolder,canapeConvFolder,canapeConvConcatFolder,otherRawFolder,otherConvFolder,concatenateCANapeLogs,fCan,maxDuration)
    
    %% Common time Array conversion
    
    % For canape folder
    canCommonTimeArray(canapeRawFolder,canapeConvFolder,fCan); 
    % All logs are copied to convFolder with common time array
    % (Whether they had already one or not).
    
    % Trim all can logs (in case of miss recording)
    canTrim(canapeConvFolder,maxDuration);
    
    % For all other records
    for folder = 1:size(otherRawFolder,1)
        canCommonTimeArray(otherRawFolder{folder},otherConvFolder{folder},fCan);
    end
    
    canMerge(canapeConvFolder,otherConvFolder);
    
    %% CANape concatenation
    if concatenateCANapeLogs==1
        concatenation_acquis_3(canapeConvFolder); % Create a new .mat that concatenate all .mat capsules
        
        [status msg] = movefile('*_total.mat',canapeConvConcatFolder); % move concatenated file in the right folder
        if status==1
            fprintf('\n Concatenated file moved in : \n %s \n',canapeConvConcatFolder);
        else
            fprintf('\n no concatenated file moved to %s \n',canapeConvConcatFolder);
        end
%         % We now delete all not concatenated files in the output folder
%         canapeFiles = filesearch(canapeConvFolder,'mat');
%         canapeNames = {canapeFiles.name};
%         files2BeMoved = canapeNames(find(~contains(canapeNames,'total','IgnoreCase',true)));
%         for f=1:length(files2BeMoved)
%             fid = fullfile(canapeConvFolder,files2BeMoved{f});
%             delete(fid);
%             fprintf('%s deleted. \n',files2BeMoved{f});
%         end
    end
end
%% Function
function canMerge(canapeFolder,otherFolder)
    listOrigMat = filesearch(canapeFolder,'mat');
    for j = 1:length(listOrigMat)
        currOrigMatTime = listOrigMat(j).name(end-9:end-4);
        canOrig         = load(fullfile(listOrigMat(j).path,listOrigMat(j).name));
        for i = 1:size(otherFolder,1)
            listOtherMat = filesearch(otherFolder{i},'mat');
            listOtherMatNames = {listOtherMat.name}';
            indSameMat      = find(contains(listOtherMatNames,currOrigMatTime));
            if length(indSameMat)>0
                canOther= load(fullfile(listOtherMat(indSameMat(1)).path,listOtherMat(indSameMat(1)).name));
                canOrig = mergerMatFiles(canOrig,canOther);
            end
        end
        save(fullfile(listOrigMat(j).path,listOrigMat(j).name),'-struct','canOrig');
    end
end

function newMat = mergerMatFiles(mat1,mat2)
    fields1 = fieldnames(mat1);
    fields2 = fieldnames(mat2);
    
    tOffset = mat2.t(end)-mat1.t(end);
    tIndCommon = find(mat2.t>=tOffset);
    
    newMat = mat1;
    for f = 1:length(fields2)
        name = fields2{f};
        if ~isfield(mat1,name)
            value = getfield(mat2,name);
            if size(value,1)==size(mat2.t,1)
                newMat= setfield(newMat,name,interp1(mat2.t(tIndCommon)-tOffset,value(tIndCommon),mat1.t));
            end
        end
    end
end