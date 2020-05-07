function handles = switchCapsule(handles)
    % This function updates the handles, the signal list and the plot windows
    % When their is a new capsule selected
    global currLineMarkingLeft
    global currLineMarkingRight
    global currRoadEvents
    global currLineColorLeft
    global currLineColorRight
    global lineMarkingLeftSignal
    global lineMarkingRightSignal
    global roadEventsSignal
    global lineColorLeftSignal
    global lineColorRightSignal
    global pushbutton2beReset
    global RoadEvents2beReset
    global currSignal
    global currTime
    
    handles.hWaitMsgBox = msgbox('Loading...');
    % Load the log
    logPath = handles.logCAN(handles.NumCapsule).path; % We first assume the log hasn't been taggued
    if handles.restoreCapsule == 0 % If we didn't pushed "Restore capsule"
        % Test if the log has already been tagged
        if exist(handles.canapeTaggingPath,'dir')==7 % Check if the folder of taggued files exists
            taggedFiles = filesearch(handles.canapeTaggingPath,'mat');
            indFile = find(contains({taggedFiles.name}',handles.logCAN(handles.NumCapsule).name));
            if ~isempty(indFile) % Check if the current log exists in the folder of tagged files
                logPath = handles.canapeTaggingPath; % If so, we will load the log from it
            end
        end
    else % We load the "raw" file and reset the restoreCapsule variable
        handles.restoreCapsule =0;
    end
    handles.loadedLog = load(fullfile(logPath,handles.logCAN(handles.NumCapsule).name));
    % Set the tagging variables
    initLineMarking = 0;
    if ~isfield(handles.loadedLog,'Line_Marking_Left')
        handles.loadedLog.Line_Marking_Left = handles.loadedLog.t*0+initLineMarking;
    end
    if ~isfield(handles.loadedLog,'Line_Marking_Right')
        handles.loadedLog.Line_Marking_Right = handles.loadedLog.t*0+initLineMarking;
    end
    if ~isfield(handles.loadedLog,'Road_Events')
        handles.loadedLog.Road_Events = handles.loadedLog.t*0;
    end
    
    initColor   = 1; % White
    if ~isfield(handles.loadedLog,'Line_Color_Left')
        handles.loadedLog.Line_Color_Left = handles.loadedLog.t*0+initColor;
    end
    if ~isfield(handles.loadedLog,'Line_Color_Right')
        handles.loadedLog.Line_Color_Right = handles.loadedLog.t*0+initColor;
    end
    
    % Init Global tagging variables
    currTime = handles.loadedLog.t(1);
    initCurrTagging(handles)
    lineMarkingLeftSignal   = handles.loadedLog.Line_Marking_Left;
    lineMarkingRightSignal  = handles.loadedLog.Line_Marking_Right;
    roadEventsSignal        = handles.loadedLog.Road_Events;
    lineColorLeftSignal     = handles.loadedLog.Line_Color_Left;
    lineColorRightSignal    = handles.loadedLog.Line_Color_Right;
    
    handles.currTime            = handles.loadedLog.t(1);
    handles.prevRoadEvents = handles.loadedLog.Road_Events(1);
    pushbutton2beReset = 1;
    RoadEvents2beReset = 0;
    
    % Init signals list
    handles.SignauxName=fieldnames(handles.loadedLog);
    set(handles.listsignaux, 'value', 1);
    set(handles.listsignaux, 'string', handles.SignauxName);
    
    % Create plot line
    handles.currSignal = handles.SignauxName{1};
    currSignal         = handles.SignauxName{1};
    xlim(handles.Graph,[handles.loadedLog.t(1) handles.loadedLog.t(end)]);
    drawnow;
    
    % Upload figure mouse over function
    set(handles.figure1,'WindowButtonMotionFcn', {@mouseMove,handles});
end