% This function is intended to assign value to "lineColor" according to
% the button pushed
function  lineColor = switchLineColor(eventdata)
    switch eventdata.Source.String
        case 'White'
            lineColor = 1;
        case 'Yellow'
            lineColor = 2;
        case 'Blue'
            lineColor = 3;
        otherwise
            error('Error : Line Color Tagging has an undefined state');
    end
end
