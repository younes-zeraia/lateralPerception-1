% This fuction is intended to create a new contextual CAN log for each video.

% Creation : Mathieu DELANNOY - RENAULT - 2020
function synchroCANapeforVid(vboPath,CANapeRawPath,CANapePath,videoPath,fVbo,fCan)

    extVid = 'mp4'; %(.avi or .mp4)
    % Search the desired logs (VBO, Video and CAN log)
    listVbo = filesearch(vboPath, 'mat');
    listCan = filesearch(CANapeRawPath, 'mat');
    listVid = filesearch(videoPath,extVid);
    % Main Loop
    countVbo = 0; % index of Vbo files
    
    for countCan = 1:length(listCan) % We sweep all can logs (for each can, there can be several vbo)
        fprintf('%u/%u %s\n', countCan, length(listCan), fullfile(listCan(countCan).path, listCan(countCan).name) );
        canape = load(fullfile(CANapeRawPath, listCan(countCan).name));
         
        %% Loop looking for all vbo logs corresponding to the current CAN
        lastVboFound = false;
        firstVboFound= false;
        while lastVboFound == false && countVbo<length(listVbo)
            countVbo = countVbo+1;
            vbo = load(fullfile(vboPath, listVbo(countVbo).name));
            [offset,correlFound] = findCorrelation(canape.Velocity,vbo.velocity,fCan,fVbo); 
            if correlFound == true % If the 2 logs (vbo, CAN) are correlated
                
                %% Loop looking for all videos corresponding to the current vbo
                countVid = 0; % Index of Video files
                videoInd = []; % initialize the list of videos corresponding to this vbo
                while countVid<length(listVid)
                    countVid = countVid+1;
                    videoFound = contains(listVid(countVid).name,listVbo(countVbo).name(1:end-4));
                    if videoFound == true
                        videoInd = [videoInd;countVid];
                    end
                end
                indVid   = 1; % We assume there has been only 1 video in this vbo file
                vidName  = listVid(videoInd(indVid)).name;
                canBegin = max(1,ceil( - vbo.avitime(1)*fCan/1000 - offset)); % First sample of the log to be kept
                canEnd   = floor((size(vbo.velocity,1)/fVbo)*fCan- vbo.avitime(1)*fCan/1000 - offset); % Last frame of the video to be kept
                firstVboFound = true; % Allow to detect if no CAN file has been detected for the current vbo (ex a calibration video without CAN acquisition).
                
                newCanapeName = strcat(listCan(countCan).name(1:end-4),'_',num2str(countCan));
                cropCANlog(canape,newCanapeName,CANapePath,canBegin,canEnd,fCan); % Split the selected Can log to match with the current Video
                movefile(fullfile(videoPath,vidName),fullfile(videoPath,[newCanapeName '.' extVid]));
                
            elseif firstVboFound == true % if at least one vbo corresponded to the current can, and the current vbo log doesn't correspond, it means that the next ones won't neiter
                lastVboFound = true; % We detected at least a CAN file and also the last one
                countVbo = countVbo-1; % We incremented countVbo once too much
            end
        end
        if countVbo>=length(listCan) && lastVboFound == false % If the current vbo didn't correspond to any vbo file -> We swept all vbo so countVbo = length(listVbo)
            countVbo = 0; % reset of the counter (we assume that only the first Can logs can be in this case)
        end
    end
end
%% FUNCTIONS
% Crop CAN logs to be synchronized with current vbo
function cropCANlog(canape,canapeName,CANapePath,canBegin,canEnd,fCan)
    fields = fieldnames(canape);
    
    for f=1:length(fields)
        fieldName   = fields{f};
        if ~isequal(fieldName,'t')
            value       = getfield(canape,fieldName);
            canape      = setfield(canape,fieldName,value(canBegin:canEnd));
        else
            canape      = setfield(canape,fieldName,[0:(canEnd-canBegin)]./fCan);
        end
    end
    
    save(fullfile(CANapePath,canapeName),'-struct','canape');
    
end