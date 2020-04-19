function saveFrames(videoFolder,videoName,frameFolder,framesInd)
    initPath = pwd;
    cd(videoFolder);
    video  = VideoReader(videoName);
    if ~exist(frameFolder,'dir')
        mkdir(frameFolder);
    end
    cd([videoFolder '\' frameFolder]);
    
    for i = framesInd
        image = read(video,i);
        imwrite(image,[erase(erase(videoName,'.avi'),'.mp4') '_' num2str(i) '.jpg']);
    end
    cd(initPath);
end
    