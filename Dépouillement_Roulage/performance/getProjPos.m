function [leftProjPos rightProjPos] = getProjPos(lineData,Heading,distProjLaneWidth,lineDataPath,fileName);


    ws = load(fullfile(dataPath,fileName));
    %% Initialisation of variables
    % (the array will be circularly shifted of one position at each loop 
    % -> current point will always be at the first position).
    xLeft   = lineData.xLineLeft;
    yLeft   = lineData.yLineLeft;
    xRight  = lineData.xLineRight;
    yRight  = lineData.yLineRight;
    xVeh    = lineData.xVehicle;
    yVeh    = lineData.yVehicle;
    headingVeh = lineData.vehHeading;
    
    % Size of the arrays
    nLeft   = getSizeLine(xLeft,yLeft);
    nRight  = getSizeLine(xRight,yRight);
    nVeh    = getSizeLine(xVeh,yVeh);
    
    if range([nLeft nRight nVeh])~=0
        error('Left Line, Right Line and Vehicle gps pos must have the same number of measure !');
    else
        nElem = nLeft;
    end
    
    % step distances between all consecutives points
    distStepLeft    = getDistStep(xLeft,yLeft);
    distStepRight   = getDistStep(xRight,yRight);
    distStepVeh     = getDistStep(xVeh,yVeh);