% This fuction is intended to create a new contextual video for each CAN log.

% Creation : Mathieu DELANNOY - RENAULT - 2020
function synchroVidforCANape(vboPath,CANapePath,videoPath,fVbo,fCan,fVid)
    
    extVid = 'mp4'; %(.avi or .mp4)
    % Search the desired logs (VBO, Video and CAN log)
    listVbo = filesearch(vboPath, 'mat');
    listCan = filesearch(CANapePath, 'mat');
    listVid = filesearch(videoPath,extVid);
    
    % Main Loop
    countCan = 0; % index of CAN files
    for countVbo = 1:length(listVbo) % We sweep all vbo logs (for each vbo, there can be several videos)
        fprintf('%u/%u %s\n', countVbo, length(listVbo), fullfile(listVbo(countVbo).path, listVbo(countVbo).name) );
        vbo = load(fullfile(vboPath, listVbo(countVbo).name));
        prevVidName = '';
        
        %% Loop looking for all videos corresponding to the current vbo
        count2 = 0; % Index of Video files
        videoInd = []; % initialize the list of videos corresponding to this vbo
        while count2<length(listVid)
            count2 = count2+1;
            videoFound = contains(listVid(count2).name,listVbo(countVbo).name(1:end-4));
            if videoFound == true
                videoInd = [videoInd;count2];
            end
        end
         
        %% Loop looking for all CAN logs corresponding to the current vbo
        lastCanFound = false;
        firstCanFound= false;
        while lastCanFound == false && countCan<length(listCan)
            countCan = countCan+1;
            can = load(fullfile(CANapePath, listCan(countCan).name));
            [offset correlFound] = findCorrelation(can.Velocity,vbo.velocity,fCan,fVbo); 
            
            if correlFound == true % If the 2 logs (vbo, CAN) are correlated
                indVid   = vbo.avifileindex(ceil(offset*fVbo/fCan)); % select the right video (several videos can correspond to 1 vbo)
                videoName  = listVid(videoInd(indVid)).name;
                vidBegin = ceil(vbo.avitime(1)*fVid/1000 + offset*fVid/fCan); % First frame of the video to be kept
                vidEnd   = ceil((size(can.Velocity,1)/fCan)*fVid + vidBegin); % Last frame of the video to be kept
                firstCanFound = true; % Allow to detect if no CAN file has been detected for the current vbo (ex a calibration video without CAN acquisition).
                
                if ~isequal(videoName,prevVidName)
                    prevVidName = videoName;
                    video = VideoReader(fullfile(videoPath,videoName));
                end
                cropVbox(videoPath,videoName,listCan(countCan).name(1:end-4),vidBegin,vidEnd,video); % Split the selected video to match with the current CAN log
            elseif firstCanFound == true % if at least one CAN log corresponded to the current vbo, and the current CAN log doesn't correspond, it means that the next ones won't neiter
                lastCanFound = true; % We detected at least a CAN file and also the last one
                countCan = countCan-1; % We incremented count3 once too much
            end
        end
        if countCan>=length(listCan) && lastCanFound == false % If the current vbo didn't correspond to any CAN file -> We swept all CAN so count3 = length(listCan)
            countCan = 0; % reset of the counter (we assume that only the first vbo can be in this case 
        end
    end
end
            