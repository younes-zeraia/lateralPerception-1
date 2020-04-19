function heading = estimateHeading(x,y)
    error(nargchk(2, 2, nargin));  %2 arguments required
    n1=length(x);
    n2=length(y);
    if (n1~=n2)
       error('x and y vectors should have the same length');
    end
    
    nHeading = 8;
    
    heading = zeros(n1,1);
    xTemp = x;
    yTemp = y;
    deltaX = diff(xTemp);
    deltaY = diff(yTemp);
    distStep = sqrt(deltaX.*deltaX + deltaY.*deltaY); % Computes the step distance between consecutives points
    distStepTemp = distStep;
    for i=1:n1
        xHeading = [xTemp(end-nHeading+1:end)
                    xTemp(1:nHeading+1)];
        yHeading = [yTemp(end-nHeading+1:end)
                    yTemp(1:nHeading+1)];
        
        xHeading = xHeading-xTemp(1);
        yHeading = yHeading-yTemp(1);
        
        
        straightLine    = polyfit(xHeading,yHeading,1); % Linear curve fitting for Heading computing
        if i>1
            prevAngle = yaw;
        end
        yaw = atan(straightLine(1));
        deltaX = xTemp(1)-xTemp(3);
        deltaY = yTemp(1)-yTemp(3); 
        if abs(deltaX)<distStepTemp(1)*1 % Issue when the slope is almost vertical
            if (deltaY>0 && yaw > 0)...
                    || (deltaY<0 && yaw<0)
                 yaw= yaw+pi;
            else
                1+1;
            end
        else % in most cases
            if deltaX>0
                yaw= yaw+pi;
            end
        end
        if yaw>pi
            yaw = yaw - 2*pi;
        elseif yaw<-pi
            yaw = yaw + 2*pi;
        end
        
        heading(i) = yaw;
        xTemp   = circshift(xTemp,-1); %Shift the array
        yTemp   = circshift(yTemp,-1); %Shift the array
        distStepTemp = circshift(distStepTemp,-1); %Shift the array
    end
end