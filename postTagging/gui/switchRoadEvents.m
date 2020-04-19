% This function is intended to assign value to "RoadEvents" according to
% the button pushed
function  roadEvent = switchRoadEvents(eventdata)
    global RoadEvents2beReset
    switch eventdata.Source.String
        case 'TarSeam'
            if eventdata.Source.Value == 1 %Toggle button "Tar-Seam" pushed
                roadEvent = 1;
            elseif eventdata.Source.Value == 0 %Toggle button "Tar-Seam" unpushed
                roadEvent = 2;
            end
        case 'Lane Split'
            roadEvent = 3;
        case 'Lane Merge'
            roadEvent = 4;
        case 'Arrow'
            roadEvent = 5;
        case 'Zebra'
            roadEvent = 6;
        case 'Cones'
            roadEvent = 7;
        case 'Barrier'
            roadEvent = 8;
        case 'Highw. Exit L'
            roadEvent = 9;
        case 'Highw. Exit R'
            roadEvent = 10;
        case 'Tunnel'
            if eventdata.Source.Value == 1 %Toggle button "Tunnel" pushed
                roadEvent = 11;
            elseif eventdata.Source.Value == 0 %Toggle button "Tunnel" unpushed
                roadEvent = 12;
            end
        case 'Yellow Line'
            if eventdata.Source.Value == 1 %Toggle button "Yellow Line" pushed
                roadEvent = 13;
            elseif eventdata.Source.Value == 0 %Toggle button "Yellow Line" unpushed
                roadEvent = 14;
            end
        case 'Line Used'
            if eventdata.Source.Value == 1 %Toggle button "Line Used" pushed
                roadEvent = 15;
            elseif eventdata.Source.Value == 0 %Toggle button "Line Used" unpushed
                roadEvent = 16;
            end
        case 'Clear all Road Events'
            roadEvent = 0;
            RoadEvents2beReset = 1;
        otherwise
            error('Error in Line Marking Tagging has an undefined state');
    end
end
