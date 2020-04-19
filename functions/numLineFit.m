function [leftLine rightLine] = numLineFit(ws,nHeading,viewRange,dataPath,fileName)
    
    plotLine = 0;
    savePlot = 0;
    %% Plot init if plotLine == 1
    if plotLine
        fig = figure;
        axes1 = axes('Parent',fig,'YLim',[0 viewRange],'XLim',[-viewRange/2 viewRange/2]);
        
        line1Points = animatedline('LineStyle','none','Marker','+','Color','black','Parent',axes1);
        line1Fit    = animatedline('LineStyle','--','Color','blue','LineWidth',2,'Parent',axes1);
        line2Points = animatedline('LineStyle','none','Marker','+','Color','black','Parent',axes1);
        line2Fit    = animatedline('LineStyle','--','Color','red','LineWidth',2,'Parent',axes1);
        grid(axes1,'minor');
        textLeft = annotation(fig,'textbox',...
                            [0.14 0.85 0.40 0.07],...
                            'Color',[0 0 1],...
                            'String',{sprintf(['C0 : ' '\n' 'C1 : ' '\n' 'C2 : ' '\n' 'C3 : '])},...
                            'FitBoxToText','off',...
                            'EdgeColor','none');

        textRight = annotation(fig,'textbox',...
                            [0.65 0.85 0.4 0.07],...
                            'Color',[1 0 0],...
                            'String',{sprintf(['C0 : ' '\n' 'C1 : ' '\n' 'C2 : ' '\n' 'C3 : '])},...
                            'FitBoxToText','off',...
                            'EdgeColor','none');
    end
    if savePlot
        plotVid = VideoWriter([dataPath '\' erase(fileName,'.mat') '_CurveFitted.avi']);
        plotVid.FrameRate = 30;
        open(plotVid);
    end
    laneWidthCompute = 1;
    laneWidth = [];
    ws = load(fullfile(dataPath,fileName));
    %% Initialisation of variables
    % (the array will be circularly shifted of one position at each loop 
    % -> current point will always be at the first position).
    xLeft   = ws.xLineLeft;
    yLeft   = ws.yLineLeft;
    xRight  = ws.xLineRight;
    yRight  = ws.yLineRight;
    xVeh    = ws.xVehicle;
    yVeh    = ws.yVehicle;
    headingVeh = ws.vehHeading;
    
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

    polyCoefsLeft    = zeros(nElem,4); % 3rd Poly coefs of Left Line
    polyCoefsRight   = zeros(nElem,4); % 3rd Poly coefs of Right Line
%     headingVeh      = zeros(nElem,1); % Vehicle Heading array
    
    h = waitbar(0,'Curve fitting...');
    for i = 1:nElem
        waitbar((i-1)/nElem,h,'Curve fitting...');
%         
%         headingVeh(i) = headingVeh
        
        [xLeftRel yLeftRel]   = getRelativeCoord(xLeft,yLeft,distStepLeft,xVeh(1),yVeh(1),headingVeh(i),viewRange);
        [xRightRel yRightRel]   = getRelativeCoord(xRight,yRight,distStepRight,xVeh(1),yVeh(1),headingVeh(i),viewRange);
        if size(xLeftRel,1)>=10 && size(xRightRel,1)>=10
            polyCoefsLeft(i,:)   = getPolyCoef(-xLeftRel,yLeftRel);
            polyCoefsRight(i,:)  = getPolyCoef(-xRightRel,yRightRel);
            
            if plotLine ==1
                [line1Points line2Points line1Fit line2Fit] = plotLines(xLeftRel,yLeftRel,xRightRel,yRightRel,...
                                                                        polyCoefsLeft(i,:),polyCoefsRight(i,:),...
                                                                        line1Points,line2Points,line1Fit,line2Fit,...
                                                                        textLeft,textRight);
                if savePlot == 1
                    writeVideo(plotVid, getframe(gcf));
                end
            end
            
        else
            polyCoefsLeft(i,:)   = 0;
            polyCoefsRight(i,:)  = 0;
        end
        
        
        
        %% SHIFT ALL ARRAYS CIRCULARLY (1st point -> Nth point ; 2nd -> 1st ; etc...)
        xLeft           = circshift(xLeft,-1);
        yLeft           = circshift(yLeft,-1);
        xRight          = circshift(xRight,-1);
        yRight          = circshift(yRight,-1);
        xVeh            = circshift(xVeh,-1);
        yVeh            = circshift(yVeh,-1);
%         headingVeh      = circshift(headingVeh,-1);
        distStepLeft    = circshift(distStepLeft,-1);
        distStepRight   = circshift(distStepRight,-1);
        distStepVeh     = circshift(distStepVeh,-1);
        
        
    end
    close(h);
    if savePlot
        close(plotVid);
    end
    %%
%     polyCoefsLeftFiltered = filterPoly(polyCoefsLeft,[filtC3 filtC2 10 10],nElem);
%     polyCoefsRightFiltered = filterPoly(polyCoefsRight,[filtC3 filtC2 10 10],nElem);
    
%     leftLine.C0 = polyCoefsLeft(:,4);
%     leftLine.C1 = polyCoefsLeft(:,3);
%     leftLine.C2 = polyCoefsLeft(:,2);
%     leftLine.C3 = polyCoefsLeft(:,1);
%     
%     rightLine.C0 = polyCoefsRight(:,4);
%     rightLine.C1 = polyCoefsRight(:,3);
%     rightLine.C2 = polyCoefsRight(:,2);
%     rightLine.C3 = polyCoefsRight(:,1);
    leftLine = polyCoefsLeft;
    rightLine= polyCoefsRight;
end
%% Functions

%% getSizeLine : Get the number of elements of the 2 arrays
% -> Returns an error if the two arrays don't have the same size
function n = getSizeLine(x,y)
    [mx px] = size(x);
    [my py] = size(y);
    
    if px>1 || py>1
        error('x,y must be column vectors');
    elseif mx~=my
        error('x,y must be the same size');
    else
        n = mx;
    end
end
    
%% getDistStep :  Get the array of step distance between all points given their x,y coords
function distStep = getDistStep(x,y)
    deltaX = diff(x);
    deltaY = diff(y);
    distStep = sqrt(deltaX.*deltaX + deltaY.*deltaY); % Computes the step distance between consecutives points
end

%% getAbsoluteHeading : Get the heading in word coordinates given xk,yk coordinates
% (The heading is 0 when the line is horizontal (dy/dx = 0)
% The heading is in radian
function heading = getAbsoluteHeading(x,y,nHeading,distStep)
        xHeading = [x(end-nHeading+1:end)
                    x(1:nHeading+1)];
        yHeading = [y(end-nHeading+1:end)
                    y(1:nHeading+1)];
        
        xHeading = xHeading-x(1);
        yHeading = yHeading-y(1);
        straightLine    = polyfit(xHeading,yHeading,1); % Linear curve fitting for Heading computing
        
        heading = atan(straightLine(1));
        deltaX = x(1)-x(3);
        deltaY = y(1)-y(3); 
        
        % Vertical lines issue patch
        if abs(deltaX)<distStep % Issue when the slope is almost vertical
            if (deltaY>0 && heading > 0)...
                    || (deltaY<0 && heading<0)
                 heading= heading+pi;
            end
        else % in most cases
            if deltaX>0
                heading= heading+pi;
            end
        end
        
        % Rescale in [-pi;pi] range
        if heading>pi
            heading = heading - 2*pi;
        elseif heading<-pi
            heading = heading + 2*pi;
        end
end

%% getRelativeCoord : 
% SELECTION of the x,y Line coordinates of the visible points (given the viewrange)
% TRANSLATION to the referential where (x0,y0) is at origin.
% ROTATION according to Heading.

function [xRel yRel] = getRelativeCoord(xAbs,yAbs,distStepTemp,x0,y0,heading,viewRange)
    
    % SELECTION
    distCum = cumsum(distStepTemp); % Cumulative distance
    indPoint = find(distCum<viewRange); % Treat only points visibles by Ego
    xLine0 = xAbs(indPoint); % x Coordinates in world reference
    yLine0 = yAbs(indPoint); % y Coordinates in world reference
    
    % TRANSLATION
    xLine1 = xLine0-x0; % x Coordinates translated to x0
    yLine1 = yLine0-y0; % y Coordinates translated to y0
    
    % ROTATION
    rotAngle = -heading+pi/2; % Vehicle referential : x to the front, y to the left
    rotMat = [cos(rotAngle)   sin(rotAngle)
              -sin(rotAngle)  cos(rotAngle)];
    xyLine2 = [xLine1 yLine1]*rotMat;

    xRel = xyLine2(:,1); % x Coordinates rotated to be in front the vehicle
    yRel = xyLine2(:,2); % y Coordinates rotated to be in front the vehicle
end

%% getPolyCoef :
% 3rd order polynomial curve fitting on x,y array
function polyCoef = getPolyCoef(x,y);
    fun = @(c,x)(c(1)*x.^3 + c(2)*x.^2 + c(3)*x + c(4)*ones(size(x,1),1));
    lowB = [-inf -inf -inf -inf];
    highB= [inf   inf  inf inf];
    opts = optimset('Display','off');
    cInit = [0 0 0 0];
    polyCoef = lsqcurvefit(fun,cInit,y,x,lowB,highB,opts);
end

%% filterPolyCoefs
function polyCoefsFiltered = filterPoly(polyCoefs,filterWindows,nElem)
    polyCoefsFiltered = zeros(nElem,4);
    for i=1:size(filterWindows,2)
        kernel = ones(filterWindows(i),1) / filterWindows(i);
        polyCoefsFiltered(:,i) = filter(kernel, 1, polyCoefs(:,i));
    end
end
    
%% plotLines :

function [line1Points line2Points line1Fit line2Fit] = plotLines(xLeftRel,yLeftRel,xRightRel,yRightRel,...
                                                                 polyCoefsLeft,polyCoefsRight,...
                                                                 line1Points,line2Points,line1Fit,line2Fit,...
                                                                 textLeft,textRight);
    clearpoints(line1Points);
    clearpoints(line2Points);
    clearpoints(line1Fit);
    clearpoints(line2Fit);

    xLeftFit    = polyval(polyCoefsLeft,yLeftRel);
    xRightFit   = polyval(polyCoefsRight,yRightRel);

    addpoints(line1Points,xLeftRel,yLeftRel);
    addpoints(line2Points,xRightRel,yRightRel);
    addpoints(line1Fit,-xLeftFit,yLeftRel);
    addpoints(line2Fit,-xRightFit,yRightRel);
    drawnow limitrate
    
    leftC0 = num2str(polyCoefsLeft(4));
    leftC1 = num2str(polyCoefsLeft(3));
    leftC2 = num2str(polyCoefsLeft(2));
    leftC3 = num2str(polyCoefsLeft(1));
    
    rightC0 = num2str(polyCoefsRight(4));
    rightC1 = num2str(polyCoefsRight(3));
    rightC2 = num2str(polyCoefsRight(2));
    rightC3 = num2str(polyCoefsRight(1));
    
    set(textLeft,'String',{sprintf(['C0 : ' leftC0 '\n' 'C1 : ' leftC1 '\n' 'C2 : ' leftC2 '\n' 'C3 : ' leftC3])});
    set(textRight,'String',{sprintf(['C0 : ' rightC0 '\n' 'C1 : ' rightC1 '\n' 'C2 : ' rightC2 '\n' 'C3 : ' rightC3])});
end