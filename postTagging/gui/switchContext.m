function handles = switchContext(handles)
    global currFrame
    % This function updates the handles and the context video
    % When their is a new capsule selected
    handles.hvidCont= VideoReader(fullfile(handles.logVContext(handles.NumCapsule).path,handles.logVContext(handles.NumCapsule).name));
    imCont=readFrame(handles.hvidCont);
    % Display 1st Frame of Contextual video
    image(imCont,'parent',handles.axes_video);
    axis(handles.axes_video,'off');
        
    % % init Video controls
    % Video Nb of frames
    handles.vCont.frameRate = handles.hvidCont.FrameRate;
    handles.vCont.nbFrames = floor(handles.hvidCont.Duration*handles.vCont.frameRate);
    set(handles.text_dynamic_nb_frames,'String',num2str(handles.vCont.nbFrames));
    % Video Duration
    set(handles.text_dynamic_video_duration,'String',num2str(handles.hvidCont.Duration));
    % Video Current Frame ID
    currFrame = 1;
    set(handles.text_dynamic_frame_ID,'String',num2str(currFrame));
    % Video Current Time
    set(handles.text_dynamic_time,'String',num2str(handles.hvidCont.CurrentTime));
    
    % % Init video slider :
    set(handles.slider_video, 'Min', 1);
    set(handles.slider_video, 'Value', currFrame);
    set(handles.slider_video, 'Max', handles.vCont.nbFrames-1);
    

    % % Init play/pause HMI state
    handles.playbtnState = 'PAUSE';
    
    set(handles.togglebutton_play, 'String', 'PLAY');
    set(handles.togglebutton_play, 'BackgroundColor', [0.15 0.15 0.15]);
    set(handles.togglebutton_play, 'ForegroundColor', [0    1    0]);
    set(handles.togglebutton_play, 'Value', 0);
end