% This function is intended to assign value to "lineMarking" according to
% the button pushed
function  lineMarking = switchLineMarking(eventdata)
    switch eventdata.Source.String
        case 'Undecided'
            lineMarking = 0;
        case 'Solid'
            lineMarking = 1;
        case 'Road Edge'
            lineMarking = 2;
        case 'Dashed'
            lineMarking = 3;
        case 'Double Line'
            lineMarking = 4;
        case 'Barrier'
            lineMarking = 6;
        otherwise
            error('Error : Line Marking Tagging has an undefined state');
    end
end
