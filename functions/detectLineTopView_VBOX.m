function [YLine1,YLine2] = detectLineTopView_VBOX(videosFolder,videoName,cropWindow,pointWheel_px,Calib,ThresholdCoef,resizeWindow)
    global dispPlot
    dispPlot = 1;
% This script intends to detect lines from "Top wheels" Point of view
    camParams   = Calib.camParams;
    RotMat      = Calib.R;
    TransMat    = Calib.t;
    
    pointWheel_mm = pointsToWorld(camParams,RotMat,TransMat,[pointWheel_px(1) pointWheel_px(2)]);
    %% Path
    initPath     = pwd;
    functionPath = [initPath '\functions'];
    addpath(functionPath);
   
    %%
    cd(videosFolder);
    video = VideoReader(videoName);
    cd(initPath);
    l = 1;
    alpha = 0.9999;
    tic
    threshWhite = [255 255 255];
    LineWidth_detected  = zeros(video.NumFrames,1);
    DTLE_detected       = zeros(video.NumFrames,1);
    YLine1              = zeros(video.NumFrames,1);
    YLine2              = zeros(video.NumFrames,1);
    level = 0.6735;
    prevDtle = 0;
    k_switch = 0;
    yLine1   = 0;
    yLine2   = 0;
    lineWidth = 0;
    nPlot       = 0;
    
    windowSize = 10;
    kernel = ones(windowSize) / windowSize ^ 2;
    
    % STREL filters
    SE.I6   = strel('rectangle',[1 10]);
    SE.I8   = strel('rectangle',[1 10]);
    SE.I13  = strel('line',3,0);
    SE.I14  = strel('line',10,0);
    SE.I16  = strel('disk',1);
    
    
    if dispPlot==1
        fig = figure('units','normalized','outerposition',[0 0 1 1]);
        axes1 = axes('Parent',fig,...
        'Position',[0.03 0.08 0.38 0.4],'Ylim',[0 2000],'Xlim',[0 video.NumFrames])
        ylabel(axes1,'Distance Line-Front Wheel (mm)');
        xlabel(axes1,'Video Frame number');
        grid(axes1,'minor');
        hold(axes1,'on');
        axes2 = axes('Parent',fig,...
        'Position',[0.03 0.53 0.38 0.4]);
        hold(axes2,'on');
        axes3 = axes('Parent',fig,...
                'Position',[0.45 0.08 0.52 0.85],...
                'Ylim',[0 2000],'Xlim',[-1000 2000]);
        grid(axes3,'minor');
        hold(axes3,'on');
        
        h_31 = animatedline(0,0,'Marker','+','Color','r','LineWidth',2,'Parent',axes3);
        h_3a(1) = animatedline('LineWidth',2,'Color','blue','Parent',axes3);
        h_3a(2) = animatedline('LineWidth',2,'Color','red','Parent',axes3);
        h_3a(3) = animatedline('LineStyle','--','Color','black','LineWidth',2,'Parent',axes3);
        h_3a(4) = animatedline('LineStyle','--','Color','black','LineWidth',2,'Parent',axes3);
        h_3a(5) = animatedline('LineStyle','none','Marker','+','Color','black','LineWidth',2,'Parent',axes3);

        h_2a(1) = animatedline('LineWidth',2,'Color','blue','Parent',axes2);
        h_2a(2) = animatedline('LineWidth',2,'Color','red','Parent',axes2);

        h_3b(1) = animatedline('LineWidth',2,'Color','green','Parent',axes3);
        h_3b(2) = animatedline('LineWidth',2,'Color','yellow','Parent',axes3);
        h_3b(3) = animatedline('LineStyle','--','Color','black','LineWidth',2,'Parent',axes3);
        h_3b(4) = animatedline('LineStyle','--','Color','black','LineWidth',2,'Parent',axes3);
        h_3b(5) = animatedline('LineStyle','none','Marker','+','Color','black','LineWidth',2,'Parent',axes3);

        h_2b(1) = animatedline('LineWidth',2,'Color','green','Parent',axes2);
        h_2b(2) = animatedline('LineWidth',2,'Color','yellow','Parent',axes2);
    end
    
    while video.hasFrame
        if l==4660
%             dispPlot = 1;
        end
        I1 = readFrame(video);
        [ImOut ImUndistort] = filterImageMDE(I1,cropWindow,resizeWindow,camParams,level,ThresholdCoef,SE,kernel);
        [lines(1).x lines(1).y] = find(ImOut==1);
        [lines(2).x lines(2).y] = find(ImOut==2);
        [lines(3).x lines(3).y] = find(ImOut==3);
        [lines(4).x lines(4).y] = find(ImOut==4);
        
        lines            = sortLines(lines);
        
        xL1_px          = lines(1).x;
        yL1_px          = lines(1).y;
        xL2_px          = lines(2).x;
        yL2_px          = lines(2).y;
        xL3_px          = lines(3).x;
        yL3_px          = lines(3).y;
        xL4_px          = lines(4).x;
        yL4_px          = lines(4).y;
        
        line1.detected   = isDetectedLine(lines(1).x,lines(1).y);
        line2.detected   = isDetectedLine(lines(2).x,lines(2).y);
        line3.detected   = isDetectedLine(lines(3).x,lines(3).y);
        line4.detected   = isDetectedLine(lines(4).x,lines(4).y);
        
        if line3.detected && line4.detected
            nLines = 4;
        elseif line1.detected && line2.detected
            nLines = 2;
        else
            nLines = 0;
        end
        
        if dispPlot == 1
            pause(1/video.FrameRate);
            imshow(ImUndistort,'Parent',axes2);
            clearpoints(h_3a(1));
            clearpoints(h_3a(2));
            clearpoints(h_3a(3));
            clearpoints(h_3a(4));
            clearpoints(h_3a(5));

            clearpoints(h_2a(1));
            clearpoints(h_2a(2));

            clearpoints(h_3b(1));
            clearpoints(h_3b(2));
            clearpoints(h_3b(3));
            clearpoints(h_3b(4));
            clearpoints(h_3b(5));

            clearpoints(h_2b(1));
            clearpoints(h_2b(2));
        end
        
        if nLines > 0
            
            [lineA beta ypp h_3a h_2a] = fitLine(lines(1).x,lines(1).y,lines(2).x,lines(2).y,camParams,pointWheel_px,RotMat,TransMat,h_3a,h_2a);
            
            if nLines > 2
                
                [lineB betaB yppB h_3b h_2b] = fitLine(lines(3).x,lines(3).y,lines(4).x,lines(4).y,camParams,pointWheel_px,RotMat,TransMat,h_3b,h_2b);
            
                beta   = [beta
                          betaB];
            
                ypp    = [ypp
                          yppB];
            end
       if nLines < 4
           lineB.valid = false;
       end
       [yLine1_temp yLine2_temp yRefreshed prevDtle h_3a h_3b] = yLineCompute(beta,ypp,nLines,prevDtle,lineA,lineB,h_3a,h_3b);
            if yRefreshed
                yLine1 = yLine1_temp;
                yLine2 = yLine2_temp;
            end
        end
                       
            
        
        
        YLine1(l)               = yLine1;
        YLine2(l)               = yLine2;
        
        if dispPlot == 1
            
            if nPlot==0
                nPlot = 1;
                h_yline(1) = animatedline([1:l],YLine1(1:l),'Parent',axes1);
                h_yline(2) = animatedline([1:l],YLine2(1:l),'Parent',axes1);
            else
                addpoints(h_yline(1),l,YLine1(l));
                addpoints(h_yline(2),l,YLine2(l));
                drawnow
            end
        end
        
        if rem(l,250)==0
            elapsedTime = toc;
            disp(sprintf('%d frames of the video processed in %4.2f sec',l,elapsedTime));
        end
        l = l+1;
    end
end
%% FUNCTIONS
function [ImOut I4] = filterImageMDE(ImIn,cropWindow,resizeWindow,camParams,level,ThresholdCoef,SE,kernel)
    I3 = imresize(imcrop(ImIn,cropWindow),resizeWindow);
    I4 = undistortImage(imresize(imcrop(ImIn,cropWindow),resizeWindow),camParams);

    I5 = (I4(:,:,1)>(255*level*ThresholdCoef) |...
          I4(:,:,2)>(255*level*ThresholdCoef) |...
          I4(:,:,3)>(255*level*ThresholdCoef));

    I9 = conv2(single(imdilate(bwareaopen(imerode(I5,SE.I6),1000),SE.I8)), kernel, 'same') > 0.5; % Rethreshold
    I15 = bwareaopen(imdilate(imerode(edge(I9,'canny'),SE.I13),SE.I14),40);
    ImOut = bwlabel(bwareafilt(bwmorph(imdilate(I15,SE.I16),'thin',inf),4));
end
function isDetected = isDetectedLine(x,y)
    % Find out if a line has been detected
    isDetected = false;

    n1 = size(x,1);
    n2 = size(y,1);
    
    if n1~=n2
        error('vector must be of the same length !');
    end
    
    if n1 > 1
        isDetected = true;
    else
    end
end

function [lineFit beta ypp h_3 h_2] = fitLine(xL1_px,yL1_px,xL2_px,yL2_px,camParams,pointWheel_px,RotMat,TransMat,h_3,h_2)
global dispPlot
pointsLine1 = pointsToWorld(camParams,RotMat,TransMat,[yL1_px xL1_px]);
    pointsLine2 = pointsToWorld(camParams,RotMat,TransMat,[yL2_px xL2_px]);

    xL1_mm      = pointsLine1(:,1)-pointWheel_px(1);
    yL1_mm      = -(pointsLine1(:,2)-pointWheel_px(2));
    xL2_mm      = pointsLine2(:,1)-pointWheel_px(1);
    yL2_mm      = -(pointsLine2(:,2)-pointWheel_px(2));

    poly1       = polyfit(xL1_mm,yL1_mm,2);
    poly2       = polyfit(xL2_mm,yL2_mm,2);

    line1 = lengthPosLine(xL1_mm,yL1_mm);
    line2 = lengthPosLine(xL2_mm,yL2_mm);

    beta   = atan([poly1(2);poly2(2)]);

    ypp    = [poly1(3);poly2(3)];
    line1.pos = poly1(3);
    line2.pos = poly2(3);

    lineFit = isValidLine(line1,line2);
        
    if dispPlot==1
        if lineFit.valid == true
            xfit1_mm    = [xL1_mm(1):1:xL1_mm(end)];
            xfit2_mm    = [xL2_mm(1):1:xL2_mm(end)];

            yfit1_mm     = polyval(poly1,xfit1_mm);
            yfit2_mm     = polyval(poly2,xfit2_mm);

            addpoints(h_3(1),xL1_mm,yL1_mm);
            addpoints(h_3(2),xL2_mm,yL2_mm);
            addpoints(h_3(3),xfit1_mm,yfit1_mm);
            addpoints(h_3(4),xfit2_mm,yfit2_mm);

            addpoints(h_2(1),yL1_px,xL1_px);
            addpoints(h_2(2),yL2_px,xL2_px);

            uistack(h_2(1),'top')
            uistack(h_2(2),'top')
        end
    end
end

function [yLine1 yLine2 yRefreshed prevDtle h_3a h_3b] = yLineCompute(beta,ypp,nLines,prevDtle,lineA,lineB,h_3a,h_3b)
global dispPlot
    yLine1 = 0;
    yLine2 = 0;
    yRefreshed = false;

    c_beta = cos(beta);
    s_beta = sin(beta);

    xp     = -ypp.*c_beta.*s_beta;
    yp     = ypp.*(ones(nLines,1)-s_beta.^2);
    dist2Wheel    = ypp./c_beta;

    dtle_A = 255000;
    dtle_B = 255000;

    if lineA.valid == true
        [dtle_A ind_A] = min(dist2Wheel(1:2));
    end

    if nLines > 2 && lineB.valid == true
        [dtle_B ind_B] = min(dist2Wheel(3:4));
    end

    [dtle_AB ind_AB] = min([dtle_A dtle_B]);

    if (lineA.valid || nLines > 2 && lineB.valid) && dtle_AB>prevDtle + 200  && prevDtle > 100 && k_switch<=10
        k_switch = k_switch + 1; % don't refresh yLine but increment k_switch until 10
                                 % Once k_switch reach 10 -> Accept to refresh (laneSplit for example).
    elseif (lineA.valid ||  nLines > 2 && lineB.valid)
        yRefreshed  = true;
        k_switch    = 0;
        prevDtle    = dtle_AB;
        indY        = [1;2]+(ind_AB-1)*2;
        yLines      = dist2Wheel(indY);
        yLine1      = min(yLines);
        yLine2      = max(yLines);
    end
    
    if dispPlot==1
        if nLines>0
            
            if lineA.valid == true
                addpoints(h_3a(5),xp(1:2),yp(1:2));
            end
            if nLines >2 && lineB.valid == true
                addpoints(h_3b(5),xp(3:4),yp(3:4));
            end
        end
    end
end
            
function line = lengthPosLine(x,y) 
    % Calculate line length and y position
    line.length  = sqrt((x(end)-x(1)).^2+(y(end)-y(1)).^2);
    line.pos     = mean(y);
end   

function line = isValidLine(line1,line2)
    % Find out if a line is a valid one according to :
    % Length (at least 1m)
    % width (between 10cm and 45cm)
    % Position (between 0m and 2m from the wheel
    line.valid = false;
    lengthValid = false;
    posValid    = false;
    
    if line1.length>0 && line2.length>0
        lengthValid = true;
    end
    
    if line1.pos>0 && line2.pos>0
        posValid    = true;
    end
    
    if lengthValid && posValid
        line.lengthLine  = (line1.length+line2.length)/2;
        line.posLine     = (line1.pos+line2.pos)/2;
        line.widthLine   = abs(line1.pos-line2.pos);
        
        if line.lengthLine > 1000 ...
                && line.widthLine > 100 && line.widthLine < 450 ...
                && line.posLine > 0 && line.posLine < 2000
            
            line.valid = true;
        end
    else
        line.lengthLine  = 0;
        line.posLine     = -255;
        line.widthLine   = 0;
    end
end

function linesSorted = sortLines(lines)
    % Sort lines according to their length
    % longest line at pos 1
    % shortest line at pos 4
    linesTab = zeros(4,3);

    linesTab(1,1) = size(lines(1).x,1)>1;
    linesTab(2,1) = size(lines(2).x,1)>1;
    linesTab(3,1) = size(lines(3).x,1)>1;
    linesTab(4,1) = size(lines(4).x,1)>1;
    
    for i=1:4
        if linesTab(i,1)
            linesTab(i,2) = sqrt((lines(1).x(end)-lines(1).x(1)).^2+(lines(1).y(end)-lines(1).y(1)).^2);
        else
            linesTab(i,2) = 0;
        end
    end
    
    [sortedLines indSorted] = sort(linesTab(:,2),'descend');
    linesSorted = lines(indSorted);
end
    