function enterPlotFcn(hAxes, cpp)
    lineHandle = findobj(hAxes, 'tag', 'rollover');
    hFig         = ancestor(hAxes,'figure');
    figPos       = hFig.Position
    [xData,yData] = getpoints(lineHandle);
    CP = get(gca,'CurrentPoint')
    cpp
%     x  = CP(1,1);
%     y  = CP(1,2);
%     distances  = sqrt(sum(([xData',yData']-[x y]).^2,2));
%     [minDist indClosest] = min(distances);
%     markerHandle = findobj('tag','rolloverMarker');
end