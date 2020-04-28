% This function is intended to refresh the video and its control
%

function handles = refresh_gui(hObject, eventdata, handles, new_Time)
global currFrame
global currTime
if nargin<4 % No 'new_Time' defined => Read next frame
    readNextFrame = true;
    new_Time      = currTime + 1/handles.vCont.frameRate;
else
    if round((new_Time-currTime)*handles.vCont.frameRate)==1 % We just selected the next time
        readNextFrame = true;
    else
        readNextFrame = false;
    end
end

%% Update GUI state string :
set(handles.text_dynamic_gui_state, 'String', handles.playbtnState);

%% Update frame contextual video :
handles = updateContext(handles,readNextFrame,new_Time);

%% Update frame lateral videos :
% handles = updateLateral(handles);


%% Update slider :
set(handles.slider_video, 'Value', currFrame);

%% Update current frame ID :
set(handles.text_dynamic_frame_ID,'String',num2str(currFrame));

%% Update current time display :
set(handles.text_dynamic_time,'String',sprintf('%.2f',handles.hvidCont.CurrentTime));

end

function handles = updateContext(handles,readNextFrame,new_Time)
    global currFrame
    global currTime
    if ~readNextFrame
        h = msgbox('Loading...');
        handles.hvidCont.CurrentTime = new_Time-1/handles.hvidCont.FrameRate;
        try
            delete(h);
        end
    end
%     if new_frame-currFrame~=1
% %         handles.hvidCont.CurrentTime = min(handles.hvidCont.CurrentTime + (new_frame-currFrame)/handles.vCont.frameRate,handles.hvidCont.Duration-1/handles.vCont.frameRate);
%     end
    % Display next Frame of Contextual video
    image(readFrame(handles.hvidCont),'parent',handles.axes_video);
    currTime            = handles.hvidCont.CurrentTime;
    handles.currTime = currTime;
    currFrame           = round(currTime*handles.vCont.frameRate);
end

function handles = updateLateral(handles);
%     run('initParams');
%     handles.vVbox.currFrame = round(interp1([1 handles.vCont.nbFrames],[handles.loadedLog.vboxVideoFrameBegin handles.loadedLog.vboxVideoFrameEnd],handles.vCont.currFrame));
%     handles.hvidVbox.CurrentTime = handles.vVbox.currFrame/handles.hvidVbox.FrameRate;
    
    imVbox=readFrame(handles.hvidVbox);
    
    % Display next Frame of Lateral videos
    % Left
    image(imrotate(imcrop(imVbox,[4 545 951 531]), 90),'parent',handles.axes_videoLeft);
    % Right
    image(imrotate(imcrop(imVbox,[964 544 951 531]), -90),'parent',handles.axes_videoRight);
end