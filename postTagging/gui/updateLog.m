function handles = updateLog(handles)
    % This function is intended to update the Loaded Log signals
    % according to a new tag information given by user in GUI
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
    global RoadEvents2beReset
    global logSaved
    
    currIndexe = ceil(interp1(handles.loadedLog.t,[1:size(handles.loadedLog.t,1)]',handles.currTime));
    
    if ~isnan(currIndexe)
        logSaved = 0; % the log tagging signals are about to be changed -> the last version of the log isn't saved anymore
        % Update Line Marking Left
        if currLineMarkingLeft ~= -1
            lineMarkingLeftSignal = updateSignal(lineMarkingLeftSignal,handles.loadedLog.t,...
                                                 currLineMarkingLeft,handles.loadedLog.t(currIndexe));
            currLineMarkingLeft = -1;
        end
        handles.loadedLog.Line_Marking_Left = lineMarkingLeftSignal;
        
        % Update Line Marking Right
        if currLineMarkingRight ~= -1
            lineMarkingRightSignal = updateSignal(lineMarkingRightSignal,handles.loadedLog.t,...
                                                  currLineMarkingRight,handles.loadedLog.t(currIndexe));
            currLineMarkingRight = -1;
        end
        handles.loadedLog.Line_Marking_Right = lineMarkingRightSignal;
        
        % Update Line Color Left
        if currLineColorLeft ~=-1
            lineColorLeftSignal = updateSignal(lineColorLeftSignal,handles.loadedLog.t,...
                                               currLineColorLeft,handles.loadedLog.t(currIndexe));
            currLineColorLeft = -1;
        end
        handles.loadedLog.Line_Color_Left = lineColorLeftSignal;
        
        % Update Line Color Left
        if currLineColorRight ~=-1
            lineColorRightSignal = updateSignal(lineColorRightSignal,handles.loadedLog.t,...
                                               currLineColorRight,handles.loadedLog.t(currIndexe));
            currLineColorRight = -1;
        end
        handles.loadedLog.Line_Color_Right = lineColorRightSignal;
        
        % Update Road events
        if currRoadEvents ~= -1 % Case a road event push button or toggle button was pushed
                if roadEventsSignal(currIndexe) ~= currRoadEvents
                    roadEventsSignal(currIndexe) = currRoadEvents;
                else % Case we want pushed 2 times on the same button -> We want to reset the road event
                    roadEventsSignal(currIndexe) = 0;
                end
                currRoadEvents               = -1;
        end
        if RoadEvents2beReset ==1
            roadEventsSignal = roadEventsSignal*0;
            currRoadEvents               = 0;
        end
        handles.loadedLog.Road_Events = roadEventsSignal;
    end
    % Upload figure mouse over function
    set(handles.figure1,'WindowButtonMotionFcn', {@mouseMove,handles});
end
% Update signal function
function updatedSignal = updateSignal(prevSignal,timeArray,currValue,currTime)
    timeSwitchSignal = unique([timeArray(1);timeArray(find(diff(prevSignal)~=0));timeArray(end)]);
    if currTime<timeArray(end)
        timeSwitchNext   = timeSwitchSignal(find(currTime<timeSwitchSignal,1,'first'));
    else
        timeSwitchNext = timeArray(end);
    end
    indSignal2BeChanged = find(timeArray>=currTime & timeArray<=timeSwitchNext);
    updatedSignal    = prevSignal;
    updatedSignal(indSignal2BeChanged) = currValue;
end

