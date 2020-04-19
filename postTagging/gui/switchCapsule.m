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
    handles.loadedLog = load(fullfile(handles.logCAN(handles.NumCapsule).path,handles.logCAN(handles.NumCapsule).name));
    
    
    initLineMarking = 1;
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
    currLineMarkingLeft     = handles.loadedLog.Line_Marking_Left(1);
    currLineMarkingRight    = handles.loadedLog.Line_Marking_Right(1);
    currRoadEvents          = handles.loadedLog.Road_Events(1);
    currLineColorLeft       = handles.loadedLog.Line_Color_Left(1);
    currLineColorRight      = handles.loadedLog.Line_Color_Right(1);
    lineMarkingLeftSignal   = handles.loadedLog.Line_Marking_Left;
    lineMarkingRightSignal  = handles.loadedLog.Line_Marking_Right;
    roadEventsSignal        = handles.loadedLog.Road_Events;
    lineColorLeftSignal     = handles.loadedLog.Line_Color_Left;
    lineColorRightSignal    = handles.loadedLog.Line_Color_Right;
    
    handles.currTime            = handles.loadedLog.t(1);
    handles.prevRoadEvents = handles.loadedLog.Road_Events(1);
    pushbutton2beReset = 0;
    RoadEvents2beReset = 0;
    handles = refreshButtons(handles);
    
    % Init signals list
    handles.SignauxName=fieldnames(handles.loadedLog);
    set(handles.listsignaux, 'value', 1);
    set(handles.listsignaux, 'string', handles.SignauxName);
    
    % Create plot line
    handles.currSignal = handles.SignauxName{1};
    currSignal         = handles.SignauxName{1};
    handles = refreshGraph(handles);
    xlim(handles.Graph,[handles.loadedLog.t(1) handles.loadedLog.t(end)]);
    drawnow;
end