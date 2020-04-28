% this function is intended to reset curr tagging values
% After : A switch capsule, or a jump into the video
function initCurrTagging(handles)
    global currLineMarkingLeft
    global currLineMarkingRight
    global currRoadEvents
    global currLineColorLeft
    global currLineColorRight
    global currTime

    currIndexe = ceil(interp1(handles.loadedLog.t,[1:size(handles.loadedLog.t,1)]',currTime));

    currLineMarkingLeft     = handles.loadedLog.Line_Marking_Left(currIndexe);
    currLineMarkingRight    = handles.loadedLog.Line_Marking_Right(currIndexe);
    currRoadEvents          = handles.loadedLog.Road_Events(currIndexe);
    currLineColorLeft       = handles.loadedLog.Line_Color_Left(currIndexe);
    currLineColorRight      = handles.loadedLog.Line_Color_Right(currIndexe);
end