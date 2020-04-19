function imageCalibName = videoCalibSave(videoFolder,videoName,saveFolder,cropWindow,resizeWindow,imageName)
    initPath = pwd;
    cd(videoFolder);
    videoOrigin  = VideoReader(videoName);
    
    imOrig = read(videoOrigin,1);
    imCropped   = imcrop(imOrig,cropWindow);
    imResize    = imresize(imCropped,resizeWindow);
    cd(saveFolder);
    imageCalibName = [imageName '.jpg'];
    
    imwrite(imCropped,fullfile(saveFolder,imageCalibName));
    cd(initPath);
end