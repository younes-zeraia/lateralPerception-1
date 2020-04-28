% this function is intended to open google maps or street view web page
% Based on the gps position corresponding to the current frame

function openGoogle(handles,eventdata)
    if handles.currTime>handles.loadedLog.t(end)
        currIndexe = size(handles.loadedLog.t,1);
    elseif handles.currTime<handles.loadedLog.t(1)
        currIndexe = 1;
    else
        currIndexe = ceil(interp1(handles.loadedLog.t,[1:size(handles.loadedLog.t,1)]',handles.currTime));
    end

    if isfield(handles.loadedLog,'PosLat') && isfield(handles.loadedLog,'PosLon')
        posLat = handles.loadedLog.PosLat(currIndexe);
        posLon = handles.loadedLog.PosLon(currIndexe);
    elseif isfield(handles.loadedLog,'Latitude') && isfield(handles.loadedLog,'Longitude')
        posLat = handles.loadedLog.Latitude(currIndexe)/60;
        posLon = handles.loadedLog.Longitude(currIndexe)/(-60);
    else
        msgbox('No GPS signal found');
        return;
    end

    if isfield(handles.loadedLog,'Heading')
        heading = handles.loadedLog.Heading(currIndexe);
    else
        heading = 0;
    end

    switch eventdata.Source.String
        case 'Google Earth'
            url = sprintf('https://earth.google.com/web/@%1.8f,%1.8f,130a,100d,35y,%fh,0t,0r',posLat,posLon,heading);
        case 'Street View'
            url = sprintf('http://maps.google.com/maps?q=&layer=c&cbll=%1.8f,%1.8f&cbp=11,%f,0,0,0',posLat,posLon,heading);
    end
    web(url, '-browser')
end