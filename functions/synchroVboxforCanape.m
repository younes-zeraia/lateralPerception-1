% This fuction is intended to create a new contextual video for each CAN log.

% Creation : Mathieu DELANNOY - RENAULT - 2020
function synchroVboxforCanape(vboPath,canapePath,videoPath,newVideoPath,fVbo,fCan,fVid)
    
    extVid = 'mp4'; %(.avi or .mp4)
    % Search the desired logs (VBO, Video and CAN log)
    listVbo = filesearch(vboPath, 'mat');
    listCan = filesearch(canapePath, 'mat');
    listVid = filesearch(videoPath,extVid);
    
    % Main Loop
    
    videoFound = {};
    
    for countVbo = 1:length(listVbo) % We sweep all vbo logs (for each vbo, there can be several videos)
        fprintf('%u/%u Current Vbo file : %s\n', countVbo, length(listVbo), listVbo(countVbo).name);
        vbo = load(fullfile(vboPath, listVbo(countVbo).name));
        prevVidName = '';
        
        %% Loop looking for all videos corresponding to the current vbo
        videoInd = getVideoInd(listVbo(countVbo).name,listVid);
        if length(videoInd)==0
            fprintf('No video matches the vbo');
        else
            %% Loop looking for all CAN logs corresponding to the current vbo
            for countCan = 1:length(listCan)
                fprintf('\t %u/%u Current Can file : %s\n',countCan,length(listCan),listCan(countCan).name)
                can = load(fullfile(canapePath, listCan(countCan).name));
                [correlFound,canBegin,canEnd,vboBegin,vboEnd] = findCorrelation(can.Velocity,vbo.velocity,fCan,fVbo);
                if correlFound
                    videoBeginName  = listVid(videoInd(vbo.avifileindex(vboBegin))).name;
                    videoEndName    = listVid(videoInd(vbo.avifileindex(vboEnd))).name;
                    if isequal(videoBeginName,videoEndName) % Same video can/vbo intersection range
                        videoFound = [videoFound;videoBeginName];
                        aviVboTimeBegin = min(vbo.avitime(1:10))/1000;
                        newCan = cropCanape(can,canBegin,canEnd,videoBeginName,newVideoPath,vboBegin,vboEnd,aviVboTimeBegin,fVbo,fCan,fVid);
                        save(fullfile(canapePath, listCan(countCan).name),'-struct','newCan');
                    else % There was a switch between 2 videos (in the same vbo) during the log
                        indSwitchVideo = find(diff(vbo.avifileindex(vboBegin:vboEnd)))+vboBegin;
                        indSwitchVbo   = [vboBegin indSwitchVideo vboEnd];
                        indSwitchCan   = [canBegin interp1([vboBegin vboEnd],[canBegin canEnd],indSwitchVideo) canEnd];
                        for i=1:length(indSwitchCan)-1
                            videoCurrName = listVid(videoInd(vbo.avifileindex(indSwitchVbo(i)))).name;
                            videoFound    = [videoFound;videoCurrName];
                            aviVboTimeBegin = min(vbo.avitime(indSwitchVbo(i):indSwitchVbo(i)+9))/1000;
                            newCan = cropCanape(canape,indSwitchCan(i),indSwitchCan(i+1),videoCurrName,newVideoPath,indSwitchVbo(i),indSwitchVbo(i+1),aviVboTimeBegin,fVbo,fCan,fVid);
                            save([fullfile(canapePath, listCan(countCan).name) '_' num2str(i)],'-struct',newCan);
                        end
                    end
                end
            end
        end
    end
    videoFound = unique(videoFound);
    for vid = 1:length(videoFound)
        fprintf('\n %s matched ! \n Transfering to %s folder...\n',videoFound{vid},newVideoPath);
        [status msg] = movefile(fullfile(videoPath,videoFound{vid}),newVideoPath);
    end
    
end

%% FUNCTIONS
% find all videos corresponding to the current vbo
function videoInd = getVideoInd(vboName,listVid)
    i = 0; % Index of Video files
    videoInd = []; % initialize the list of videos corresponding to this vbo
    while i<length(listVid)
        i = i+1;
        videoFound = contains(listVid(i).name,vboName(1:end-4));
        if videoFound == true
            videoInd = [videoInd;i];
        end
    end
end
% Crop the canape file and add corresponding vbox information and save it
function newCanape = cropCanape(canape,canBegin,canEnd,videoName,videoPath,vboBegin,vboEnd,vboAviTimeOffset,fVbo,fCan,fVid)
    
    % Crop canape log
    fields = fieldnames(canape);
    newCanape = struct();
    for f=1:length(fields)
        fieldName   = fields{f};
        value       = getfield(canape,fieldName);
        if isequal(fieldName,'t')
            newCanape      = setfield(newCanape,fieldName,[0:(canEnd-canBegin)]'./fCan);
            
        elseif size(value,1)>=canEnd
            newCanape      = setfield(newCanape,fieldName,value(canBegin:canEnd));
        else
            newCanape      = setfield(newCanape,fieldName,value);
        end
    end

    % Add vbox information
    newCanape.vboxVideoName = videoName;
    newCanape.vboxVideoPath = videoPath;
    newCanape.vboxVideoFrameBegin  = ceil((vboBegin/fVbo + vboAviTimeOffset)*fVid);
    newCanape.vboxVideoFrameEnd    = floor((vboEnd/fVbo + vboAviTimeOffset)*fVid);
end