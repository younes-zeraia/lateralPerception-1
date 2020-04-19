function handles = switchLateral(handles)
    % This function updates the handles and the lateral videos
    % When their is a new capsule selected
    % %1er Image video vbox
    % [cheminVideoVbox]=fullfile([logVvbox(NumCapsule).folder],[logVvbox(NumCapsule).name]);
    run('initParams');
    handles.hvidVbox= VideoReader(fullfile(handles.loadedLog.vboxVideoPath,handles.loadedLog.vboxVideoName));
    handles.vVbox.currFrame = round(interp1([1 handles.vCont.nbFrames],[handles.loadedLog.vboxVideoFrameBegin handles.loadedLog.vboxVideoFrameEnd],handles.vCont.currFrame));
    handles.hvidVbox.CurrentTime = handles.vVbox.currFrame/handles.hvidVbox.FrameRate;
    
    imVbox=readFrame(handles.hvidVbox);
    imcLeft=imcrop(imVbox,cropParams.leftWindow);
    imcLeft=imrotate(imcLeft, 90);
    imcRight=imcrop(imVbox,cropParams.rightWindow);
    imcRight=imrotate(imcRight, -90);
    
    % Display 1st Frame of Lateral videos
    % Left
    image(imcLeft,'parent',handles.axes_videoLeft);
    axis(handles.axes_videoLeft,'off');
    % Right
    image(imcRight,'parent',handles.axes_videoRight);
    axis(handles.axes_videoRight,'off');
end