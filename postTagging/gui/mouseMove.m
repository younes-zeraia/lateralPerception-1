function mouseMove (object, eventdata,handles)
global currSignal
if isfield(handles,'loadedLog')
    xData = handles.loadedLog.t;
    yData = getfield(handles.loadedLog,currSignal);
    
    C = get (gca, 'CurrentPoint');
    
    xPointer = C(1,1);
    yPointer = C(1,2);
    if xPointer>=handles.Graph.XLim(1) && xPointer<=handles.Graph.XLim(2) &&...
            yPointer>=handles.Graph.YLim(1) && yPointer<=handles.Graph.YLim(2)
        distances = sqrt(sum((([xData yData]-[xPointer yPointer])./handles.Graph.Position(3:4)).^2,2));
        [minDist,indClosest] = min(distances);
        set(handles.cursorMarker,'XData',xData(indClosest),...
                                    'YData',yData(indClosest));
    elseif ~isnan(handles.cursorMarker.XData)
        set(handles.cursorMarker,'XData',NaN,'YData',NaN);
    end
end
end