% this function is intended to transform the (x,y) coordinates of a line in
% the local reference of another line (u,v)

% INPUTS NECESSARY : xLine_mes , yLine_mes , xLine_ref, yLine_ref (Global Reference frame)
% INPUT  OPTIONAL  : yaw_ref (if not : yaw_ref = estimateYawAngle(ref);

% OUTPUT : uLine_mes, vLine_mes (reference line Local reference frame).

% The first line is shifted in the second one reference frame (translation)
% Then it is rotated according to a given array of angles (rotation)
% If the array of angles isn't specified, it is estimated according to the
% reference line

% Creator : Mathieu DELANNOY - RENAULT - 2020

function [uLine_mes,vLine_mes] = transformCoord(xLine_mes,yline_mes,xLine_ref,yLine_ref,yaw_ref)
    
    if nargin < 5 % if yaw Ref not specified
        yaw_ref = estimateHeading(xLine_ref,yLine_ref);
    end
    
    % Translation
    xLine_mes_trans = xLine_mes - xLine_ref;
    yLine_mes_trans = yline_mes - yLine_ref;
    
    % Rotation
    cos_yaw = cos(yaw_ref);
    sin_yaw = sin(yaw_ref);

    uLine_mes   =  xLine_mes_trans.*cos_yaw + yLine_mes_trans.*sin_yaw;
    vLine_mes   =  -xLine_mes_trans.*sin_yaw + yLine_mes_trans.*cos_yaw;
end
    
    
    