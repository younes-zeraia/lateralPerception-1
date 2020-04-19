% this function is intended to refresh the graph axes
function handles = refreshGraph(handles,onlyMarker)
    if nargin<2 % only the first argument is specified
        onlyMarker = 0;
    end
    global currSignal
    plotValue = getfield(handles.loadedLog,currSignal);
    if size(handles.loadedLog.t,1) == size(plotValue,1)
        currIndexe = ceil(interp1(handles.loadedLog.t,[1:size(handles.loadedLog.t,1)]',handles.currTime));
        if onlyMarker == 0
            set(handles.linePlot,'XData',handles.loadedLog.t,...
                                'YData',plotValue);
        end
        set(handles.markerPlot,'XData',handles.loadedLog.t(currIndexe),...
                                'YData',plotValue(currIndexe));
    else
        error('Wrong signal selected !');
    end
end
    