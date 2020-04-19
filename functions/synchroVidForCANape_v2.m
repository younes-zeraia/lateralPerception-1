% Tis fuction intends to create a new contextual video for each CAN log.

% Hypothesis :
%             -> All CAN logs are included in one or several videos
%             -> All Videos are included in one or several CAN logs

% Creation : Mathieu DELANNOY - RENAULT - 2020
function synchroVidForCANape_v2(vboPath,CANapePath,videoPath,cropParams,fVbo,fCan,fVid)
    
    extVid = 'mp4'; %(.avi or .mp4)
    % Search the desired logs (VBO, Video and CAN log)
    listVbo = filesearch(vboPath, 'mat');
    listCan = filesearch(CANapePath, 'mat');
    listVid = filesearch(videoPath,extVid);
    
    countVBO = 1;
    countCAN = 1;
    
    while countVBO <= length(listVbo)
        
        videoInd            = findVideosOfThisVbo([listVid.name],listVbo(countVBO).name);
        [indBegin,indEnd]   = findBeginEndVboCan(listVbo(countVBO),listCan(countCAN),fVbo,fCan,fVid);
    % Main Loop
    count3 = 0; % index of CAN files
    for count1 = 1:length(listVbo) % We sweep all vbo logs (for each vbo, there can be several videos)
        fprintf('%u/%u %s\n', count1, length(listVbo), fullfile(listVbo(count1).path, listVbo(count1).name) );
        vbo = load(fullfile(vboPath, listVbo(count1).name));
        %% Loop looking for all videos corresponding to the current vbo
        count2 = 0; % Index of Video files
        videoInd = []; % initialize the list of videos corresponing to this vbo
        while count2<length(listVid)
            count2 = count2+1;
            videoFound = contains(listVid(count2).name,listVbo(count1).name(1:end-4));
            if videoFound == true
                videoInd = [videoInd;count2];
            end
        end
         
        %% Loop looking for all CAN logs corresponding to the current vbo
        lastCanFound = false;
        firstCanFound= false;
        while lastCanFound == false && count3<length(listCan)
            count3 = count3+1;
            can = load(fullfile(CANapePath, listCan(count3).name));
            [offset correlFound] = findCorrelation(can.Velocity,vbo.velocity,fCan,fVbo); 
            
            if correlFound == true % If the 2 logs (vbo, CAN) are correlated
                indVid   = vbo.avifileindex(ceil(offset*fVbo/fCan)); % select the right video (several videos can correspond to 1 vbo)
                vidName  = listVid(videoInd(indVid)).name;
                vidBegin = ceil(vbo.avitime(1)*fVid/1000 + offset*fVid/fCan); % First frame of the video to be kept
                vidEnd   = floor((size(can.Velocity,1)/100)*30); % Last frame of the video to be kept
                firstCanFound = true; % Allow to detect if no CAN file has been detected for the current vbo (ex a calibration video without CAN acquisition).
                cropVbox(videoPath,vidName,listCan(count3).name(1:end-4),vidBegin,vidEnd,cropParams); % Split the selected video to match with the current CAN log
            elseif firstCanFound == true % if at least one CAN log corresponded to the current vbo, and the current CAN log doesn't correspond, it means that the next ones won't neiter
                lastCanFound = true; % We detected at least a CAN file and also the last one
                count3 = count3-1; % We incremented count3 once too much
            end
        end
        if count3>=length(listCan) && lastCanFound == false % If the current vbo didn't correspond to any CAN file -> We swept all CAN so count3 = length(listCan)
            count3 = 0; % reset of the counter (we assume that only the first vbo can be in this case 
        end
    end
    end

%% FUNCTIONS

% Find all videos correponding to the current vbo
function videoInd = findVideosOfThisVbo(videoNames,vboName)
    videoInd = [];
    for i = 1:length(videoNames)
        if contains(videoNames(i),vboName(1:end-4))
            videoInd = [videoInd;i];
        end
    end
    if length(videoInd)<1
        fprintf('No video found for the vbo file : %s',vboName);
    end
end

% Find the begin and the end of the vbo file to be synchronized with the Can file
% If no correlation found -> indBegin = 'NaN' and indEnd = 'NaN'
% If Can Log contained in vbo log -> indBegin>0 and indEnd<size(vbo)
% If Vbo log contained in Can log -> indBegin<0 and indEnd>size(vbo)
function [frameVidBegin,frameVidEnd]   = findBeginEndVboCan(VboFile,CanFile,fVbo,fCan,fVid);
    vbo = load(fullfile(VboFile.path,VboFile.name));
    can = load(fullfile(CanFile.path,CanFile.name));
    
    vboAviIndexSwitch       = find(diff(vbo.avifileindex)==1); % index of videos switchs in vbo file
    vboAviIndewSwitch(1)    = 1; % We consider the first switch (beginning of the 1st video) occurs in the first sample
    
    [offset correlFound]    = findCorrelation(can.Velocity,vbo.velocity,fCan,fVbo);
    
    if correlFound
        % Part of the 2 files has been recorded in the same time
        
        if offset>0 % Can log started after Vbo log
            indVidBegin     = vbo.avifileindex(floor(offset*fVbo/fCan)); % select the video corresponding to the begin of the Can log
            indVidEnd       = vbo.avifileindex(ceil(size(can.Velocity,1)/fCan*fVbo)); % select the video corresponding to the end of the Can log
            
            indVboBegin     = offset*fVbo/fCan;
            indVboEnd       = min([size(can.Velocity,1)*fVbo/fCan,size(vbo.velocity,1)]);
            
            frameVidBegin     = zeros(indVidEnd-indVidBegin+1,1); % prealocate begin frame list of the videos
            frameVidEnd       = zeros(indVidEnd-indVidBegin+1,1); % prealocate end frame list of the videos
            
            for v = 1:indVidEnd-indVidBegin+1 % For all videos concerned
                if v==1 % We apply the offset to the first video of the vbo file
                    frameVidBegin(v) = floor((indVboBegin/fVbo + vbo.avitime(1)/1000)*fVid);
                else % The other videos begins right after the previous ones
                    frameVidBegin(v) = 1;
                end
                
                if v==indVidEnd-indVidBegin+1 % We cut the last video according to the Can log
                    frameVidEnd = floor(
            
            frameVidBegin   =  % First frame of the first video to be kept
            frameVidEnd     = ceil(size(can.Velocity,1)/fCan*fVid); % Last frame of the last video to be kept
            
            if frameVidEnd > floor(size(vbo.velocity,1)/fVbo*fVid) % Can log continues after the end of the video -> we stop the video anyway
                frameVidEnd = floor(size(vbo.velocity,1)/fVbo*fVid);
            end
            
        else % Can log started before vbo log
            
    