function handles = refreshButtons(handles)
    global pushbutton2beReset
    global RoadEvents2beReset
    global logSaved
    inactiveButtonBackgroundColor = [0.15,0.15,0.15];
    activeButtonBackgroundColor   = [0,1,0];
    whiteColor = [1,1,1];
    yellowColor= [1,1,0];
    blueColor  = [0.3,0.75,0.93];
    activeSaveButtonColor   = [0.17 0.58 0.12];
    inactiveSaveButtonColor = inactiveButtonBackgroundColor;
    
    currIndexe = ceil(interp1(handles.loadedLog.t,[1:size(handles.loadedLog.t,1)]',handles.currTime));
    if ~isnan(currIndexe)
        % Line Marking Left
        switch handles.loadedLog.Line_Marking_Left(currIndexe)
            case 0 % Undecided
                set(handles.pushbutton_undecided_left,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_solid_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_left,'BackgroundColor',inactiveButtonBackgroundColor);
            case 1 % Solid
                set(handles.pushbutton_undecided_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_left,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_left,'BackgroundColor',inactiveButtonBackgroundColor);
            case 2 % Road Edge
                set(handles.pushbutton_undecided_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_left,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_dashed_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_left,'BackgroundColor',inactiveButtonBackgroundColor);
            case 3 % Dashed
                set(handles.pushbutton_undecided_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_left,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_left,'BackgroundColor',inactiveButtonBackgroundColor);
            case 4 % Double Line
                set(handles.pushbutton_undecided_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_left,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_barrier_left,'BackgroundColor',inactiveButtonBackgroundColor);
            case 6 % Barrier
                set(handles.pushbutton_undecided_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_left,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_left,'BackgroundColor',activeButtonBackgroundColor);
        end
        % Line Marking Right
        switch handles.loadedLog.Line_Marking_Right(currIndexe)
            case 0 % Undecided
                set(handles.pushbutton_undecided_right,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_solid_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_right,'BackgroundColor',inactiveButtonBackgroundColor);
            case 1 % Solid
                set(handles.pushbutton_undecided_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_right,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_right,'BackgroundColor',inactiveButtonBackgroundColor);
            case 2 %  Road Edge
                set(handles.pushbutton_undecided_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_right,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_dashed_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_right,'BackgroundColor',inactiveButtonBackgroundColor);
            case 3 % Dashed
                set(handles.pushbutton_undecided_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_right,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_right,'BackgroundColor',inactiveButtonBackgroundColor);
            case 4 % Double Line
                set(handles.pushbutton_undecided_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_right,'BackgroundColor',activeButtonBackgroundColor);
                set(handles.pushbutton_barrier_right,'BackgroundColor',inactiveButtonBackgroundColor);
            case 6 % Barrier
                set(handles.pushbutton_undecided_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_solid_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_roadEdge_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_dashed_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_doubleLine_right,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_barrier_right,'BackgroundColor',activeButtonBackgroundColor);
        end
        
        % Line Color left
        switch handles.loadedLog.Line_Color_Left(currIndexe)
            case 1 % White
                set(handles.pushbutton_white_left,'BackgroundColor',whiteColor,'ForegroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_yellow_left,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',yellowColor);
                set(handles.pushbutton_blue_left,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',blueColor);
                set(handles.uipanel_lineColorLeft,'ForegroundColor',whiteColor,'HighlightColor',whiteColor,'ShadowColor',whiteColor);
            case 2 % Yellow
                set(handles.pushbutton_white_left,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',whiteColor);
                set(handles.pushbutton_yellow_left,'BackgroundColor',yellowColor,'ForegroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_blue_left,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',blueColor);
                set(handles.uipanel_lineColorLeft,'ForegroundColor',yellowColor,'HighlightColor',yellowColor,'ShadowColor',yellowColor);
            case 3 % Blue
                set(handles.pushbutton_white_left,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',whiteColor);
                set(handles.pushbutton_yellow_left,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',yellowColor);
                set(handles.pushbutton_blue_left,'BackgroundColor',blueColor,'ForegroundColor',inactiveButtonBackgroundColor);
                set(handles.uipanel_lineColorLeft,'ForegroundColor',blueColor,'HighlightColor',blueColor,'ShadowColor',blueColor);
        end
        
        % Line Color right
        switch handles.loadedLog.Line_Color_Right(currIndexe)
            case 1 % White
                set(handles.pushbutton_white_right,'BackgroundColor',whiteColor,'ForegroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_yellow_right,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',yellowColor);
                set(handles.pushbutton_blue_right,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',blueColor);
                set(handles.uipanel_lineColorRight,'ForegroundColor',whiteColor,'HighlightColor',whiteColor,'ShadowColor',whiteColor);
            case 2 % Yellow
                set(handles.pushbutton_white_right,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',whiteColor);
                set(handles.pushbutton_yellow_right,'BackgroundColor',yellowColor,'ForegroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_blue_right,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',blueColor);
                set(handles.uipanel_lineColorRight,'ForegroundColor',yellowColor,'HighlightColor',yellowColor,'ShadowColor',yellowColor);
            case 3 % Blue
                set(handles.pushbutton_white_right,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',whiteColor);
                set(handles.pushbutton_yellow_right,'BackgroundColor',inactiveButtonBackgroundColor,'ForegroundColor',yellowColor);
                set(handles.pushbutton_blue_right,'BackgroundColor',blueColor,'ForegroundColor',inactiveButtonBackgroundColor);
                set(handles.uipanel_lineColorRight,'ForegroundColor',blueColor,'HighlightColor',blueColor,'ShadowColor',blueColor);
        end
        
        % Road events
        if pushbutton2beReset == 1 || RoadEvents2beReset == 1 % Reset de pushButtons (ponctual events)
                set(handles.pushbutton_LS,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_LM,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_arrow,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_zebra,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_cones,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_HwEL,'BackgroundColor',inactiveButtonBackgroundColor);
                set(handles.pushbutton_HwER,'BackgroundColor',inactiveButtonBackgroundColor);
                pushbutton2beReset = 0;
        end
        
        if RoadEvents2beReset == 1 % Reset de Toggle button events (continuous events)
            set(handles.togglebutton_tarSeam,'BackgroundColor',inactiveButtonBackgroundColor);
            set(handles.togglebutton_tarSeam,'Value',0);
            set(handles.togglebutton_tunnel,'BackgroundColor',inactiveButtonBackgroundColor);
            set(handles.togglebutton_tunnel,'Value',0);
            set(handles.togglebutton_lineUsed,'BackgroundColor',inactiveButtonBackgroundColor);
            set(handles.togglebutton_lineUsed,'Value',0);
            RoadEvents2beReset = 0;
        end
                
        switch handles.loadedLog.Road_Events(currIndexe)
            case 1
                set(handles.togglebutton_tarSeam,'BackgroundColor',activeButtonBackgroundColor);
            case 2
                set(handles.togglebutton_tarSeam,'BackgroundColor',inactiveButtonBackgroundColor);
            case 3
                set(handles.pushbutton_LS,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 4
                set(handles.pushbutton_LM,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 5
                set(handles.pushbutton_arrow,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 6
                set(handles.pushbutton_zebra,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 7
                set(handles.pushbutton_cones,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 8
%                 set(handles.pushbutton_barrier,'BackgroundColor',activeButtonBackgroundColor);
%                 pushbutton2beReset = 1;
            case 9
                set(handles.pushbutton_HwEL,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 10
                set(handles.pushbutton_HwER,'BackgroundColor',activeButtonBackgroundColor);
                pushbutton2beReset = 1;
            case 11
                set(handles.togglebutton_tunnel,'BackgroundColor',activeButtonBackgroundColor);
            case 12
                set(handles.togglebutton_tunnel,'BackgroundColor',inactiveButtonBackgroundColor);
            case 13
%                 set(handles.togglebutton_yellowLine,'BackgroundColor',activeButtonBackgroundColor);
            case 14
%                 set(handles.togglebutton_yellowLine,'BackgroundColor',inactiveButtonBackgroundColor);
            case 15
                set(handles.togglebutton_lineUsed,'BackgroundColor',activeButtonBackgroundColor);
            case 16
                set(handles.togglebutton_lineUsed,'BackgroundColor',inactiveButtonBackgroundColor);
        end
        
        
    end
    if logSaved == 0
        if ~isequal(get(handles.pushbutton_saveCapsule,'Enable'),'on')
            set(handles.pushbutton_saveCapsule,'BackgroundColor',activeSaveButtonColor);
            set(handles.pushbutton_saveCapsule,'Enable','on');
        end
    else
        set(handles.pushbutton_saveCapsule,'BackgroundColor',inactiveSaveButtonColor);
        set(handles.pushbutton_saveCapsule,'Enable','off');
    end
end

%% FUNCTIONS
% flipFlog switch
function signalOut = flipFlop(setArray,resetArray,timeArray)
    timeBegin   = timeArray(find(setArray==1));
    timeEnd     = timeArray(find(resetArray==1));
    times       = [];
    for i=1:length(timeBegin)
        currTimeEnd = timeArray(find(timeEnd>=timeBegin(i)));
        if length(currTimeEnd)>=1
            times(i,:) = [timeBegin(i),currTimeEnd(1)];
        else
            times(i,:) = [timeBegin(i),timeArray(end)];
        end
    end
    if size(times,2)==2
        [raw indUnique] = unique(times(:,2));
        timeBrkptsRaw = times(indUnique,:);
        valueBrkptsRaw= [ones(size(timeBrkptsRaw,1),1) zeros(size(timeBrkptsRaw,1),1)];
        timeBrkptsRawVert = reshape(timeBrkptsRaw',[],1);
        valueBrkptsRawVert= reshape(valueBrkptsRaw',[],1);
        [timeBrkpts, uniqueInd]       = unique([0;timeBrkptsRawVert;100]);
        valBrkpts         = [0;valueBrkptsRawVert;0];
        signalOut = interp1(timeBrkpts,valBrkpts(uniqueInd),timeArray,'previous');
    else
        signalOut = timeArray.*0;
    end
end