% This function crop the video whose path and name are specified in input
% according to beginFrame and endFrame
% if beginFrame is negative, the beginning of the video is the first frame
% if endFrame is out of video frame number, the end of the video is the
% last frame

% Mathieu Delannoy - 2020

function cropVbox(videoPath,videoName,newVideoName,beginFrame,endFrame,video)
    
    wb      = waitbar(0,'Starting video split...');
    wb.Children.Title.Interpreter = 'none';
    

    if beginFrame<1
        beginFrame = 1;
        fprintf('video %s started after %s Canape log !\n',videoName,newVideoName);
    end
    
    if endFrame > floor(video.Duration*video.FrameRate)
        endFrame = floor(video.Duration*video.FrameRate);
        fprintf('video %s stopped before %s Canape log !\n',videoName,newVideoName);
    end
    
%     newVideoLeft = VideoWriter(fullfile(videoPath,[newVideoName '_left']));
%     newVideoLeft.FrameRate = 30;
%     open(newVideoLeft);
%     
%     newVideoRight = VideoWriter(fullfile(videoPath,[newVideoName '_right']));
%     newVideoRight.FrameRate = 30;
%     open(newVideoRight);

    newVideo            = VideoWriter(fullfile(videoPath,newVideoName));
    newVideo.FrameRate  = 30;
    open(newVideo);
    
    currFrame = beginFrame;
    firstImage= readFrame(video);
    video.CurrentTime = currFrame/video.FrameRate;
    
    while currFrame<=endFrame+1
        currImage = readFrame(video);
        writeVideo(newVideo,currImage);
        currFrame = currFrame + 1;
        waitbar((currFrame-beginFrame)/(endFrame-beginFrame),wb,strcat('Split of ',videoName,'...'));
    end
    close(newVideo);
    close(wb);
    
%     while video.hasFrame && currFrame<=endFrame
%         currImage = readFrame(video);
%         currFrame = currFrame + 1;
%         
%         if currFrame > beginFrame && currFrame<endFrame
% %             currImageLeft = imresize(imcrop(currImage,cropParams.leftWindow),cropParams.resizeWindow);
% %             currImageRight= imresize(imcrop(currImage,cropParams.rightWindow),cropParams.resizeWindow);
%             
%             currImageLeft = imcrop(currImage,cropParams.leftWindow);
%             currImageRight= imcrop(currImage,cropParams.rightWindow);
%             
%             writeVideo(newVideoLeft, currImageLeft);
%             writeVideo(newVideoRight, currImageRight);
%         end
%     end
%     close(newVideoLeft);
%     close(newVideoRight);
end
    