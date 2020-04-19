function [YLineLeftInt,YLineLeftExt,YLineRightInt,YLineRightExt,lineTypeLeft,lineTypeRight,yRefreshedLeft,yRefreshedRight] = detectLinesTopView_modif(canapeFilePath,canFileName,pointWheelLeft_px,pointWheelRight_px,CalibLeft,CalibRight,VehWidth,cropParams)
    dispPlot = 1;
    savePlot = 0;
% This script intends to detect lines from "Top wheels" Point of view
    camParams   = CalibLeft.camParams;
    
    RotMatLeft  = CalibLeft.R;
    TransMatLeft= CalibLeft.t;
    
    RotMatRight  = CalibRight.R;
    TransMatRight= CalibRight.t;
    
    pointWheelLeft_mm = pointsToWorld(camParams,RotMatLeft,TransMatLeft,[pointWheelLeft_px(2) pointWheelLeft_px(1)]);
    pointWheelRight_mm = pointsToWorld(camParams,RotMatRight,TransMatRight,[pointWheelRight_px(2) pointWheelRight_px(1)]);
    %% Path
    initPath     = pwd;
    functionPath = [initPath '\functions'];
    addpath(functionPath);
   
    canape = load(fullfile(canapeFilePath,[canFileName '.mat']));
    
    
    %%
    if isfield(canape,'vboxVideoPath') && isfield(canape,'vboxVideoName')
        video = VideoReader(fullfile(canape.vboxVideoPath,canape.vboxVideoName));
    else
        error('no video corresponding to this log');
    end
    l = 1;
    tic
    nFrames = canape.vboxVideoFrameEnd-canape.vboxVideoFrameBegin;
    beginTime = canape.vboxVideoFrameBegin / video.FrameRate;
    endTime   = canape.vboxVideoFrameEnd / video.FrameRate;
    %% Parameters
    
    levelLeft           = 0.6735;
    levelRight           = 0.6735;
    windowSize = 10;
    kernel = ones(windowSize) / windowSize ^ 2;
    
    yLineLowSL = 1000; %Slew rate : mm/frame
    
    % STREL filters
    SE.I6   = strel('rectangle',[1 10]);
    SE.I8   = strel('rectangle',[1 10]);
    SE.I13  = strel('line',5,0);
    SE.I14  = strel('line',10,0);
    SE.I16  = strel('disk',1);
    
    %% Initialisation
    
    YLineLeftInt              = zeros(nFrames,1);
    YLineLeftExt              = zeros(nFrames,1);
    YLineRightInt              = zeros(nFrames,1);
    YLineRightExt              = zeros(nFrames,1);
    
    yRefreshedLeft            = zeros(nFrames,1) - 1;
    yRefreshedRight           = zeros(nFrames,1) - 1;
    
    prevDtleLeft    = 0;
    prevDtleRight   = 0;
    prevLineWidthLeft = 0;
    prevLineWidthRight= 0;
    yLine1Left      = 0;
    yLine2Left      = 0;
    yLine1Right     = 0;
    yLine2Right     = 0;
    k_switchLeft    = 0;
    k_switchRight   = 0;
    nPlot           = 0;
    fRefreshLeft    = zeros(nFrames,1);
    fRefreshRight   = zeros(nFrames,1);
    lineTypeLeft    = zeros(nFrames,1);
    lineTypeRight   = zeros(nFrames,1);
    lineTypeLeft_k    = 0;
    lineTypeRight_k   = 0;
    l_previousLeft  = 0;
    l_previousRight = 0;
    
    prevDistLeft    = zeros(nFrames,1);
    prevDistRight   = zeros(nFrames,1);
    stdDistLeft     = [100;zeros(nFrames-1,1)];
    stdDistRight    = [100;zeros(nFrames-1,1)];
    realDistLeft    = zeros(nFrames,1);
    realDistRight   = zeros(nFrames,1);
    
    %% INIT PLOT FIGURE
    % Figure
    fig = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    
    % Axe of yLines (int, ext , Left and Right)
    axesYLines = axes('Parent',fig,...
    'Position',[0.343880126182965 0.58 0.3 0.4])
    ylabel(axesYLines,'Distance Line-Front Wheel (m)');
    xlabel(axesYLines,'Video Frame number');
    grid(axesYLines,'minor');
    hold(axesYLines,'on');
    
    % Axe of the Left video
    axeImLeft = axes('Parent',fig,...
    'Position',[0.03 0.58 0.28571 0.4]);
    hold(axeImLeft,'on');
    
    % Axe of the Right video
    axeImRight = axes('Parent',fig,...
    'Position',[0.67 0.58 0.28571 0.4]);
    hold(axeImRight,'on');
    
    % Axe of the lines in world coordinates
    axesWorld = axes('Parent',fig,...
            'Position',[0.17 0.08 0.64 0.45],...
            'Ylim',[-1 1],'Xlim',[-3 3],'Xdir','reverse');
    ylabel(axesWorld,'x axis in World coordinates (m)');
    xlabel(axesWorld,'y axis in World coordinates (m)');
    grid(axesWorld,'minor');
    hold(axesWorld,'on');
    annotation(fig,'textbox',...
    [0.347395833333333 0.271367521367521 0.0828124999999991 0.0331196581196574],...
    'Color',[1 0 0],...
    'String','Left Wheel pos',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',12);
    annotation(fig,'textbox',...
    [0.546614583333332 0.269764957264957 0.0908854166666677 0.0331196581196574],...
    'Color',[1 0 0],...
    'String','Right Wheel pos',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',12);
    annotation(fig,'textbox',...
    [0.1056875 0.592948717948718 0.103166666666667 0.0491452991452991],...
    'String',{'Left Video'},...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',18);
    annotation(fig,'textbox',...
    [0.749697916666666 0.59241452991453 0.103166666666667 0.0491452991452991],...
    'String','Right Video',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',18,...
    'FitBoxToText','off');
    % Init of animated lines
    edgesColor = [235/255, 52/255, 195/255]; % Rose
    selEdgesColor = [92/255, 235/255,  52/255]; % Green
    % World coord : Left
    hWorldWheelLeft = animatedline(VehWidth/2,0,'Marker','+','Color','r','LineWidth',2,'Parent',axesWorld);
    hWorldLeft(1)   = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldLeft(2)   = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldLeft(3)   = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldLeft(4)   = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldLeft(5)   = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axesWorld);
    hWorldLeft(6)   = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axesWorld);
    hWorldLeft(7)   = animatedline('LineStyle','none','Marker','+','Color','black','LineWidth',2,'Parent',axesWorld);

    % image coord : Left
    hImageLeft(1) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImLeft);
    hImageLeft(2) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImLeft);
    hImageLeft(3) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImLeft);
    hImageLeft(4) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImLeft);
    hImageLeft(5) = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axeImLeft);
    hImageLeft(6) = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axeImLeft);
    

    % World coord : Line 1 Right
    hWorldWheelRight    = animatedline(-VehWidth/2,0,'Marker','+','Color','r','LineWidth',2,'Parent',axesWorld);
    hWorldRight(1) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldRight(2) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldRight(3) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldRight(4) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axesWorld);
    hWorldRight(5) = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axesWorld);
    hWorldRight(6) = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axesWorld);
    hWorldRight(7) = animatedline('LineStyle','none','Marker','+','Color','black','LineWidth',2,'Parent',axesWorld);

    % image coord : Right
    hImageRight(1) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImRight);
    hImageRight(2) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImRight);
    hImageRight(3) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImRight);
    hImageRight(4) = animatedline('LineWidth',1,'Color',edgesColor,'Parent',axeImRight);
    hImageRight(5) = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axeImRight);
    hImageRight(6) = animatedline('LineWidth',2,'Color',selEdgesColor,'Parent',axeImRight);
    
    % Annotations Line types
    textLineTypeLeft = annotation(fig,'textbox',...
                            [0.095 0.93 0.105 0.034],...
                            'Color',[1 1 0],...
                            'VerticalAlignment','middle',...
                            'String',{lineTypeLeft_k},...
                            'LineWidth',1,...
                            'HorizontalAlignment','center',...
                            'FontSize',14,...
                            'FontName','Arial',...
                            'FitBoxToText','off',...
                            'EdgeColor',[1 1 0],...
                            'BackgroundColor',[0 0 0]);

    textLineTypeRight = annotation(fig,'textbox',...
                            [0.758 0.93 0.105 0.034],...
                            'Color',[1 1 0],...
                            'VerticalAlignment','middle',...
                            'String',{lineTypeRight_k},...
                            'LineWidth',1,...
                            'HorizontalAlignment','center',...
                            'FontSize',14,...
                            'FontName','Arial',...
                            'FitBoxToText','off',...
                            'EdgeColor',[1 1 0],...
                            'BackgroundColor',[0 0 0]);
    
    if dispPlot == 1
        fig.Visible = 'on';
        figRight.Visible = 'on';
    end
    
    if savePlot == 1
        plotVid = VideoWriter([canape.vboxVideoPath '\' erase(erase(canFileName,'.mp4'),'.avi') '_processed.avi']);
        plotVid.FrameRate = 30;
        open(plotVid);
    end
    
    video.CurrentTime = beginTime;
    
    while video.CurrentTime < endTime
%         if l==1 
%             video.CurrentTime = beginTime + 305/video.FrameRate;
%         end
        IOrig       = readFrame(video);
        IOrigLeft   = imcrop(IOrig,cropParams.leftWindow);
        IOrigRight  = imcrop(IOrig,cropParams.rightWindow);
        
        [ImLeft,ImUndistortLeft,levelLeft]      = filterImageMDE(IOrigLeft,camParams,levelLeft,SE,kernel);
        [ImRight,ImUndistortRight,levelRight]   = filterImageMDE(IOrigRight,camParams,levelRight,SE,kernel);
        
        % Detect edges
        [EdgesLeft nEdgesLeft]      = findEdges(ImLeft);
        [EdgesRight nEdgesRight]    = findEdges(ImRight);
        if dispPlot == 1
            pause(1/video.FrameRate);
            if nPlot==0
                nPlot = 1;
                hLeft_yline(1) = animatedline([1:l],YLineLeftInt(1:l),'Parent',axesYLines);
%                 hLeft_yline(2) = animatedline([1:l],YLineLeftExt(1:l),'Parent',axesYLines);
                hRight_yline(1) = animatedline([1:l],YLineRightInt(1:l),'Parent',axesYLines);
%                 hRight_yline(2) = animatedline([1:l],YLineRightExt(1:l),'Parent',axesYLines);
                
                imLeft_handle = imshow(ImUndistortLeft,'Parent',axeImLeft);
                imRight_handle = imshow(ImUndistortRight,'Parent',axeImRight);
            else
                addpoints(hLeft_yline(1),l-1,YLineLeftInt(l-1));
%                 addpoints(hLeft_yline(2),l-1,YLineLeftExt(l-1));
                addpoints(hRight_yline(1),l-1,YLineRightInt(l-1));
%                 addpoints(hRight_yline(2),l-1,YLineRightExt(l-1));
                drawnow
                if savePlot == 1
                    frame = getframe(gcf);
                    writeVideo(plotVid, imresize(frame.cdata,[960 1900]));
                end
                set(imLeft_handle,'CData',ImUndistortLeft);
                set(imRight_handle,'CData',ImUndistortRight);
            end
            
        end
        % Fit Edges
        fittedEdgesLeft     = getFittedEdges(EdgesLeft,camParams,pointWheelLeft_mm,RotMatLeft,TransMatLeft);
        fittedEdgesRight    = getFittedEdges(EdgesRight,camParams,pointWheelRight_mm,RotMatRight,TransMatRight);
        
        % Select Edges
        selectedEdgesLeft   = selectedEdges(fittedEdgesLeft);
        selectedEdgesRight  = selectedEdges(fittedEdgesRight);
        
        % Select Edge V2
        selectedEdgeLeft       = selectEdge(fittedEdgesLeft,prevDistLeft(l),stdDistLeft(l));
        selectedEdgeRight      = selectEdge(selectedEdgesRight,prevDistRight(l),stdDistRight(l));
        
        % update dists
        [distLeft  distUpdatedLeft  prevDistLeft(l+1)  stdDistLeft(l+1) realDistLeft(l+1)] = updateDist(selectedEdgeLeft,prevDistLeft(l),stdDistLeft(l),realDistLeft(l));
        [distRight distUpdatedRight prevDistRight(l+1) stdDistRight(l+1) realDistRight(l+1)] = updateDist(selectedEdgeRight,prevDistRight(l),stdDistRight(l),realDistRight(l));
        
        if distUpdatedLeft
            yLine1Left = distLeft;
        end
        if distUpdatedRight
            yLine1Right = distRight;
        end
        
        YLineLeftInt(l)               = yLine1Left;
        YLineRightInt(l)              = -yLine1Right;
        
        % Plot Edges
        [hImageLeft hWorldLeft]  = plotEdges(fittedEdgesLeft,selectedEdgeLeft,hImageLeft,hWorldLeft,VehWidth/2,dispPlot);
        [hImageRight hWorldRight] = plotEdges(fittedEdgesRight,selectedEdgesRight,hImageRight,hWorldRight,-VehWidth/2,dispPlot);
        
        % Fit lines (2 edges)
%         [linesLeft  hImageLeft hLeft_2b hWorldLeft hLeft_3b] = getFittedLines(EdgesLeft,nEdgesLeft,camParams,pointWheelLeft_mm,RotMatLeft,TransMatLeft,hImageLeft,hWorldLeft,VehWidth/2,dispPlot);
%         [linesRight hImageRight hRight_2b hWorldRight hRight_3b] = getFittedLines(EdgesRight,nEdgesRight,camParams,pointWheelRight_mm,RotMatRight,TransMatRight,hImageRight,hImageRight,hWorldRight,hRight_3b,-VehWidth/2,dispPlot);
        yRefreshedLeft_k = false;
        yRefreshedRight_k= false;
        fRefreshLeftk  = 0;
        fRefreshRightk = 0;
        
%         if linesLeft(1).valid || linesLeft(2).valid % Si au moins l'une des deux lignes est valide
%             [yLine1Left_temp,yLine2Left_temp,yRefreshedLeft_k,prevDtleLeft,prevLineWidthLeft,k_switchLeft,hWorldLeft,hLeft_3b,l_previousLeft] = yLineCompute_v2(linesLeft,prevDtleLeft,prevLineWidthLeft,k_switchLeft,hWorldLeft,hLeft_3b,VehWidth/2,dispPlot,l,l_previousLeft);
%         end
%         
%         if linesRight(1).valid || linesRight(2).valid % Si au moins l'une des deux lignes est valide
%             [yLine1Right_temp,yLine2Right_temp,yRefreshedRight_k,prevDtleRight,prevLineWidthRight,k_switchRight,hWorldRight,hRight_3b,l_previousRight] = yLineCompute_v2(linesRight,prevDtleRight,prevLineWidthRight,k_switchRight,hWorldRight,hRight_3b,-VehWidth/2,dispPlot,l,l_previousRight);
%         end
%         
%         if yRefreshedLeft_k
%             if l>1 && fRefreshLeft(l-1)>0.05
%                 yLine1Left        = slewRateY(yLine1Left_temp,yLine1Left,yLineLowSL);
%                 yLine2Left        = slewRateY(yLine2Left_temp,yLine2Left,yLineLowSL);
%             else
%                 yLine1Left        = yLine1Left_temp;
%                 yLine2Left        = yLine2Left_temp;
%             end
%         end
%         
%         if yRefreshedRight_k
%             if l>1 && fRefreshRight(l-1)>0.05
%                 yLine1Right       = slewRateY(yLine1Right_temp,yLine1Right,yLineLowSL);
%                 yLine2Right       = slewRateY(yLine2Right_temp,yLine2Right,yLineLowSL);
%             else
%                 yLine1Right       = yLine1Right_temp;
%                 yLine2Right       = yLine2Right_temp;
%             end
%         end
%         
%         [lineTypeLeft_k fRefreshLeft textLineTypeLeft] = getLineType(yRefreshedLeft_k,fRefreshLeft,l,0.95,lineTypeLeft_k,textLineTypeLeft);
%         [lineTypeRight_k fRefreshRight textLineTypeRight] = getLineType(yRefreshedRight_k,fRefreshRight,l,0.95,lineTypeRight_k,textLineTypeRight);
%         
%         lineTypeLeft(l) = lineTypeLeft_k;
%         lineTypeRight(l)= lineTypeRight_k;
%         
%         YLineLeftInt(l)               = yLine1Left;
%         YLineLeftExt(l)               = yLine2Left;
%         yRefreshedLeft(l)             = yRefreshedLeft_k;
%         
%         YLineRightInt(l)              = -yLine1Right;
%         YLineRightExt(l)              = -yLine2Right;
%         yRefreshedRight(l)            = yRefreshedRight_k;
%         
%         
        
        
        if rem(l,250)==0
            elapsedTime = toc;
            disp(sprintf('%d frames of the video processed in %4.2f sec',l,elapsedTime));
        end
        l = l+1;
    end
    
%     iInterpLeft = find(yRefreshedLeft(1:end-1) == 1 & yRefreshedLeft(2:end) == 1);
%     iInterpRight = find(yRefreshedRight(1:end-1) == 1 & yRefreshedRight(2:end) == 1);
%     t = [0:1:nFrames];
%     
%     YLineLeftInt = interp1(t(iInterpLeft),YLineLeftInt(iInterpLeft),t);
%     YLineLeftExt = interp1(t(iInterpLeft),YLineLeftExt(iInterpLeft),t);
%     YLineRightInt = interp1(t(iInterpRight),YLineRightInt(iInterpRight),t);
%     YLineRightExt = interp1(t(iInterpRight),YLineRightExt(iInterpRight),t);
    
    if savePlot == 1
        close(plotVid);
    end
end
%% FUNCTIONS
function [ImOut,I4,level] = filterImageMDE(ImIn,camParams,level,SE,kernel)
    I4 = undistortImage(ImIn,camParams);
%     levelPrev = level;
%     Isort = sort(I4(:),'descend');
%     newLevel = double(mean(Isort(1:500000)))/255*0.9;
%     newLevel = graythresh(I4)*0.8;
%     level = levelPrev*0.99 + newLevel*0.01;
    level = graythresh(I4);
    if level<0.45
        level = 0.45;%0.6735;
    elseif level > 0.9
        level = 0.9;
    end
    level
    I5 = (I4(:,:,1)>(255*level) |...
          I4(:,:,2)>(255*level) |...
          I4(:,:,3)>(255*level));

    I9 = conv2(single(imdilate(bwareaopen(imerode(I5,SE.I6),1000),SE.I8)), kernel, 'same') > 0.5; % Rethreshold
    I15 = bwareaopen(imdilate(bwareaopen(imerode(edge(I9,'canny'),SE.I13),20),SE.I13),60);
    ImOut = bwlabel(bwareafilt(bwmorph(imdilate(I15,SE.I16),'thin',inf),6));
end

%% Find Edges in binary labelled image
function [edges,nEdges] = findEdges(Im)

    % Detect up to 4 edges in labelled images
    edges = [];
    for i=1:max(Im(:))
        [edges(i).x, edges(i).y]    = find(Im==i);
        edges(i).detected           = isDetectedEdge(edges(i).x,edges(i).y);
    end
    if length(edges)>0
        nEdges = sum([edges.detected]);
    else
        nEdges = 0;
    end
end

function isDetected = isDetectedEdge(x,y)
    % Find out if a edge has been detected
    isDetected = false;

    n1 = size(x,1);
    n2 = size(y,1);
    
    if n1~=n2
        error('vector must be of the same length !');
    end
    
    if n1 > 2
        isDetected = true;
    else
    end
end
%% Get fitted edges
function [fittedEdges] = getFittedEdges(edges,camParams,pointWheel_mm,RotMat,TransMat)
    c2Thresh = 3*10^-5; % Line curvature condition
    c1Thresh = 0.08; % Line heading condition
    c0Threshs= [0 2500];
    fittedEdges = [];
    k = 1;
    for i=1:length(edges)
        edges(i).poly = NaN;
        if edges(i).detected == 1
            [poly X Y] = fitEdge(edges(i).x,edges(i).y,camParams,pointWheel_mm,RotMat,TransMat);
            if abs(poly(1))<c2Thresh % The edge is straight enough
                if abs(poly(2))<c1Thresh % The edge is horizontal enough
                    if poly(3)>c0Threshs(1) && poly(3)<c0Threshs(2)
                        fittedEdges(k).poly = poly;
                        fittedEdges(k).x    = edges(i).x;
                        fittedEdges(k).y    = edges(i).y;
                        fittedEdges(k).X    = X;
                        fittedEdges(k).Y    = Y;
                        k = k+1;
                    end
                end
            end
        end
    end
    
    nEdges = length(fittedEdges);
    i = 1;
    while i<=nEdges-1
        sameEdge = [zeros(1,i-1) 1 zeros(1,nEdges-i)];
        for j = i+1:nEdges
            sameEdge(j) = isSameEdge(fittedEdges(i).poly,fittedEdges(j).poly,[-1000 1000]);
        end
        fittedEdges = mergeEdges(fittedEdges,sameEdge);
        nEdges = length(fittedEdges);
        i = i+1;
    end
    i = 1;
    while i <= nEdges
        if ~isAValidEdge(fittedEdges(i));
            fittedEdges(i) = [];
            nEdges = nEdges - 1;
        else
            i = i+1;
        end
    end
end

function [poly X0 Y0] = fitEdge(x,y,camP,xyWh,R,T)
    XY = pointsToWorld(camP,R,T,[y x]);

    X0      = XY(:,1)-xyWh(1);
    Y0      = (XY(:,2)-xyWh(2));

    poly       = polyfit(X0,Y0,2);
end
function sameEdge = isSameEdge(poly1,poly2,xLim)
    sameEdge = false;
    xRoots = roots(poly1-poly2);
    if all(isreal(xRoots))
        if any(xRoots>[xLim(1);xLim(1)] & xRoots<[xLim(2);xLim(2)])
            sameEdge = true;
        end
    end
end
function edges = mergeEdges(edges,sameEdge)
    arrayx = [];
    arrayy = [];
    arrayX = [];
    arrayY = [];
    nSameEdges = sum(sameEdge);
    indSameEdges = find(sameEdge == 1);
    indUniqueEdges = find(sameEdge == 0);
    for i=indSameEdges
        arrayx = [arrayx;edges(i).x];
        arrayy = [arrayy;edges(i).y];
        arrayX = [arrayX;edges(i).X];
        arrayY = [arrayY;edges(i).Y];
    end
    newPoly = polyfit(arrayX,arrayY,2);
    
    edges(indSameEdges(1)).x    = arrayx;
    edges(indSameEdges(1)).y    = arrayy;
    edges(indSameEdges(1)).X    = arrayX;
    edges(indSameEdges(1)).Y    = arrayY;
    edges(indSameEdges(1)).poly = newPoly;
    
    edges(indSameEdges(2:end)) = [];
    
    
end
 
%% Select Edges
function selectedEdges = selectedEdges(edges)
    nEdges = length(edges);
    if nEdges>1
    edges = sortEdges(edges);
    end
    selectedEdges= [];
    if nEdges>0
        i = 1;
        edgeFound = false;
        lineFound = false;

        while i <= nEdges && ~edgeFound
            edgeFound = isAValidEdge(edges(i));
            if edgeFound
                j=i;
                while j < nEdges && ~lineFound
                    j = j+1;
                    lineFound = isAValidLine(edges(i),edges(j));
                end
                selectedEdges = edges(i);
                if lineFound
                    selectedEdges(2) = edges(j);
                end
            else
                i = i+1;
            end
        end
    end
end

function sortedEdges = sortEdges(edges)
    dists = zeros(length(edges),1);
    for i=1:length(edges)
        dists(i) = edges(i).poly(3);
    end
    [sortedDist indSort] = sort(dists);
    
    sortedEdges = edges(indSort);
end
function validEdge = isAValidEdge(edge)
    validEdge = false;
    lengthThrsh = 1500;
    if (max(edge.X)-min(edge.X))>lengthThrsh
        validEdge = true;
    end
end
function [validLine] = isAValidLine(edge1,edge2)
    minLineWidth = 100;
    maxLineWidth = 400;
    
    validLine   = false;
    lineWidth   = edge2.poly(3)-edge1.poly(3);
    
    if isAValidEdge(edge2)
        if lineWidth>minLineWidth && lineWidth<maxLineWidth
            validLine = true;
        end
    end
end
%% Select Edges V2
function [selectedEdge indEdge] = selectEdge(edges,prevDist,stdDist)
    weights = [1 0 0];
    
    nEdges = length(edges);
    if nEdges>1
        dists = zeros(nEdges,1);
        lengths = zeros(nEdges,1);
        for i = 1:nEdges
            dists(i) = edges(i).poly(3);
            lengths(i) = max(edges(i).X)-min(edges(i).X);
        end
        scores = zeros(nEdges,3);
        scores(:,1) = getDistScores(dists);
        scores(:,2) = getLengthScores(lengths);
        scores(:,3) = getClosenessScores(dists,prevDist);

        confidenceScores = sum(scores.*weights,2)/sum(weights);
        [maxScore indMaxScore] = max(confidenceScores);

            selectedEdge = edges(indMaxScore);
            indEdge      = indMaxScore;
    elseif nEdges ==1
        selectedEdge = edges(1);
        indEdge      = 1;
    else
        selectedEdge = [];
        indEdge      = 0;
    end
end
function distScores = getDistScores(dists)
    distMin = min(dists);
    distMax = max(dists);
    distScores = interp1([distMax;distMin],[0;1],dists);
end
function lengthScores = getLengthScores(lengths)
    lengthMin = min(lengths);
    lengthMax = max(lengths);
    lengthScores = interp1([lengthMax;lengthMin],[1;0],lengths);
end

function closenessScores = getClosenessScores(dists,prevDist,stdDist)
    diffDists = abs(dists-prevDist);
    diffDistMax = min(diffDists);
    diffDistMin = max(diffDists);
    closenessScores = interp1([diffDistMin;diffDistMax],[1;0],diffDists);
end

%% Update Dists
function [newDist distUpdated newPrevDist newStdDist realDist] = updateDist(edge,prevDist,stdDist,prevRealDist)
    diffDistThresh = 0.2;
    newDist        = -255;
    distUpdated    = false;
    if length(edge)>0
        if (abs(edge.poly(3)-prevDist))/stdDist<diffDistThresh
            newDist = edge.poly(3);
            distUpdated = true;
        end
        if prevDist < 50
            aDist   = 0;
            aStd    = 0;
        elseif edge.poly(3) < prevDist
            aDist   = 0.1;
            aStd    = 0.9;
        else
            aDist   = 0.3;
            aStd    = 0.9;
        end
        
        
        realDist = edge.poly(3);
        newPrevDist = prevDist*aDist + edge.poly(3)*(1-aDist);
        newStdDist  = stdDist*aStd  + abs(edge.poly(3)-prevDist)*(1-aStd);
    else
        newPrevDist = prevDist
        newStdDist  = stdDist;
        realDist    = prevRealDist;
    end
end
%% Get fitted lines
function [lines,h_2a,h_2b,h_3a,h_3b] = getFittedLines(Edges,nEdges,camParams,pointWheel_mm,RotMat,TransMat,h_2a,h_2b,h_3a,h_3b,offsetVehWidth,dispPlot)

    line1 = initLine();
    line2 = initLine();
    
    if nEdges > 0
        % 2nd order fit on first line (2 longest edges)
        [line1,h_3a,h_2a] = fitLine(Edges(1).x,Edges(1).y,Edges(2).x,Edges(2).y,camParams,pointWheel_mm,RotMat,TransMat,h_3a,h_2a,offsetVehWidth,dispPlot);

        if nEdges > 2
            % 2nd order fit on second line (2 shortest edges among the 4 detected)
            [line2,h_3b,h_2b] = fitLine(Edges(3).x,Edges(3).y,Edges(4).x,Edges(4).y,camParams,pointWheel_mm,RotMat,TransMat,h_3b,h_2b,offsetVehWidth,dispPlot);
        else
            lineB.valid = false;
        end
    end
    lines(1) = line1;
    lines(2) = line2;
end

function line = initLine()
    line.valid  = false;
    line.length = 0;
    line.pos    = -255;
    line.width  = 0;
    line.ypp    = [];
    line.beta   = [];
end

function [lineFit,h_3,h_2] = fitLine(xL1_px,yL1_px,xL2_px,yL2_px,camParams,pointWheel_mm,RotMat,TransMat,h_3,h_2,offsetVehWidth,dispPlot)
    
    pointsLine1 = pointsToWorld(camParams,RotMat,TransMat,[yL1_px xL1_px]);
    pointsLine2 = pointsToWorld(camParams,RotMat,TransMat,[yL2_px xL2_px]);

    xL1_mm      = pointsLine1(:,1)-pointWheel_mm(1);
    yL1_mm      = (pointsLine1(:,2)-pointWheel_mm(2));
    xL2_mm      = pointsLine2(:,1)-pointWheel_mm(1);
    yL2_mm      = (pointsLine2(:,2)-pointWheel_mm(2));

    poly1       = polyfit(xL1_mm,yL1_mm,2);
    poly2       = polyfit(xL2_mm,yL2_mm,2);

    edge1 = lengthPosLine(xL1_mm,yL1_mm);
    edge2 = lengthPosLine(xL2_mm,yL2_mm);
    edge1.pos = poly1(3);
    edge2.pos = poly2(3);

    lineFit         = isValidLine(edge1,edge2);
    lineFit.ypp     = [poly1(3);poly2(3)];
    lineFit.beta    = atan([poly1(2);poly2(2)]);
    if dispPlot==1 && false
        if lineFit.valid == true
            xfit1_mm    = [xL1_mm(1):1:xL1_mm(end)];
            xfit2_mm    = [xL2_mm(1):1:xL2_mm(end)];
            
            yfit1_mm     = polyval(poly1,xfit1_mm);
            yfit2_mm     = polyval(poly2,xfit2_mm);

            addpoints(h_3(1),yL1_mm.*sign(offsetVehWidth)/1000+offsetVehWidth,xL1_mm./1000);
            addpoints(h_3(2),yL2_mm.*sign(offsetVehWidth)/1000+offsetVehWidth,xL2_mm./1000);
            addpoints(h_3(3),yfit1_mm.*sign(offsetVehWidth)/1000+offsetVehWidth,xfit1_mm./1000);
            addpoints(h_3(4),yfit2_mm.*sign(offsetVehWidth)/1000+offsetVehWidth,xfit2_mm./1000);

            addpoints(h_2(1),yL1_px+offsetVehWidth,xL1_px);
            addpoints(h_2(2),yL2_px+offsetVehWidth,xL2_px);

            uistack(h_2(1),'top')
            uistack(h_2(2),'top')
        end
    end
end

function [yLine1,yLine2,yRefreshed,prevDtle,prevLineWidth,k_switch,h_3a,h_3b] = yLineCompute(lines,prevDtle,prevLineWidth,k_switch,h_3a,h_3b,offsetVehWidth,dispPlot)
% global dispPlot
    yLine1 = 0;
    yLine2 = 0;
    yRefreshed = false;
    if lines(1).valid || lines(2).valid
        beta = [lines(1).beta;lines(2).beta];
        ypp  = [lines(1).ypp; lines(2).ypp];
        
        c_beta = cos(beta);
        s_beta = sin(beta);

        xp     = -ypp.*c_beta.*s_beta;
        yp     = ypp.*(ones(size(beta,1),1)-s_beta.^2);
        dist2Wheel    = ypp./c_beta;

        dtle_A = 255000;
        dtle_B = 255000;
        lineWidth_A = 0;
        lineWidth_B = 0;
        if lines(1).valid
            [dtle_A ind_A]  = min(dist2Wheel(1:2));
            lineWidth_A     = abs(dist2Wheel(1) - dist2Wheel(2));
        end
    
        if lines(2).valid
            [dtle_B ind_B]  = min(dist2Wheel(3:4));
            lineWidth_B     = abs(dist2Wheel(3) - dist2Wheel(4));
        end

        [dtle_AB ind_AB] = min([dtle_A dtle_B]);
        lineWidths       = [lineWidth_A lineWidth_B];
        lineWidth_AB     = lineWidths(ind_AB);
        
        if (((dtle_AB>prevDtle + 200 || dtle_AB<prevDtle - 200)  && prevDtle > 100) || ...
                ((lineWidth_AB > prevLineWidth+100 || lineWidth_AB < prevLineWidth-100) && prevLineWidth > 60))
            
            % Nothing
        
        elseif (((dtle_AB>prevDtle + 100 || dtle_AB<prevDtle - 100)  && prevDtle > 100) || ...
           ((lineWidth_AB > prevLineWidth+50 || lineWidth_AB < prevLineWidth-50) && prevLineWidth > 60)) &&...
           k_switch<=10
            
            k_switch = k_switch + 1; % don't refresh yLine but increment k_switch until 10
                                     % Once k_switch reach 10 -> Accept to refresh (laneSplit for example).
            
            if k_switch ==10
                1+1;
            end
           
        else
            yRefreshed  = true;
            k_switch    = 0;
            prevDtle    = dtle_AB;
            prevLineWidth = lineWidth_AB;
            indY        = [1;2]+(ind_AB-1)*2;
            yLines      = dist2Wheel(indY);
            yLine1      = min(yLines);
            yLine2      = max(yLines);
        end
    end
    
    
    
    if dispPlot==1
        if lines(1).valid
            addpoints(h_3a(5),yp(1:2).*sign(offsetVehWidth)/1000+offsetVehWidth,xp(1:2)./1000);
        end
        if lines(2).valid
            addpoints(h_3b(5),yp(3:4).*sign(offsetVehWidth)/1000+offsetVehWidth,xp(3:4)./1000);
        end
    end
end

function [yLine1,yLine2,yRefreshed,prevDtle,prevLineWidth,k_switch,h_3a,h_3b,l_previous] = yLineCompute_v2(lines,prevDtle,prevLineWidth,k_switch,h_3a,h_3b,offsetVehWidth,dispPlot,l_current,l_previous)
% global dispPlot
    yLine1 = 0;
    yLine2 = 0;
    yRefreshed = false;
    if lines(1).valid || lines(2).valid
        beta = [lines(1).beta;lines(2).beta];
        ypp  = [lines(1).ypp; lines(2).ypp];
        
        c_beta = cos(beta);
        s_beta = sin(beta);

        xp     = -ypp.*c_beta.*s_beta;
        yp     = ypp.*(ones(size(beta,1),1)-s_beta.^2);
        dist2Wheel    = ypp./c_beta;

        dtle_A = 255000;
        dtle_B = 255000;
        lineWidth_A = 0;
        lineWidth_B = 0;
        if lines(1).valid
            [dtle_A ind_A]  = min(dist2Wheel(1:2));
            lineWidth_A     = abs(dist2Wheel(1) - dist2Wheel(2));
        end
    
        if lines(2).valid
            [dtle_B ind_B]  = min(dist2Wheel(3:4));
            lineWidth_B     = abs(dist2Wheel(3) - dist2Wheel(4));
        end

        [dtle_AB ind_AB] = min([dtle_A dtle_B]);
        lineWidths       = [lineWidth_A lineWidth_B];
        lineWidth_AB     = lineWidths(ind_AB);
        
        deltaDTLE        = abs((dtle_AB - prevDtle)/(l_current-l_previous));
        deltaLineW       = abs((lineWidth_AB - prevLineWidth) / (l_current-l_previous));
        
        if ((deltaDTLE < 10 && deltaLineW < 3) && (abs(dtle_AB - prevDtle) < 100 && abs(lineWidth_AB - prevLineWidth) < 10)) || prevDtle < 100 || prevLineWidth < 50 || k_switch > 5
            
            %% Current measure is correct
            yRefreshed  = true; % We refresh the value
            k_switch    = 0; % We reset the counter
            prevDtle    = dtle_AB; % current DTLE becomes reference
            prevLineWidth = lineWidth_AB; % current lineWidth becomes reference
            l_previous  = l_current; % current l becomes reference
            indY        = [1;2]+(ind_AB-1)*2;
            yLines      = dist2Wheel(indY);
            yLine1      = min(yLines);
            yLine2      = max(yLines);
            
        elseif (deltaDTLE < 20 && deltaLineW < 10) %&& (abs(dtle_AB - prevDtle) < 200 && abs(lineWidth_AB - prevLineWidth) < 100)
            k_switch = k_switch + 1; % don't refresh yLine but increment k_switch until 10
                                     % Once k_switch reach 10 -> Accept to refresh (laneSplit for example).
        end
    end
    
    
    
    if dispPlot==1 && false
        if lines(1).valid
            addpoints(h_3a(5),yp(1:2).*sign(offsetVehWidth)/1000+offsetVehWidth,xp(1:2)./1000);
        end
        if lines(2).valid
            addpoints(h_3b(5),yp(3:4).*sign(offsetVehWidth)/1000+offsetVehWidth,xp(3:4)./1000);
        end
    end
end

% Slew rate of yline
function yLineSlewRated = slewRateY(yLine,yLinePrev,slewRateVal)

    if yLine>yLinePrev+slewRateVal
        yLineSlewRated = yLinePrev+slewRateVal;
        
    elseif yLine<yLinePrev-slewRateVal
        yLineSlewRated = yLinePrev-slewRateVal;
        
    else
        yLineSlewRated = yLine;
    end
    
end

% getLineType
function [lineType fRefresh textLineType] = getLineType(yRefresh,fRefreshPrev,l,alphaMeanAverage,lineTypePrev,textLineType)
    
    fRefreshk   = 0;
    fRefresh    = fRefreshPrev;
    lineType    = lineTypePrev;
    
    % Compute fRefreshk
    % If close to 1 -> line detected at almost each frame   -> Solid Line
    % If close to 0 -> line undetected at almost each frame -> Undetected
    % If in between -> line detected half of the time       -> Dashed Line
    
    if yRefresh
        fRefreshk     = 1;
    end

    if l==1
        fRefresh(l)      = 0;
    else
        fRefresh(l)      = fRefresh(l-1)*(alphaMeanAverage) + fRefreshk*(1-alphaMeanAverage);
    end
    
    
    if fRefresh(l)>0.95
        lineType = 3;
    elseif isequal(lineType,3)
        if fRefresh(l)<0.7
            lineType = 2;
        end
    elseif isequal(lineType,2)
        if fRefresh(l)<0.02
            lineType = 0;
        end
    elseif fRefresh(l) > 0.05
        lineType = 2;
    else
        lineType = 0;
    end
    
    switch lineType
        case 0
            lineTypeStr = 'Undetected';
        case 1
            lineTypeStr = 'Road Edge';
        case 2
            lineTypeStr = 'Dashed';
        case 3
            lineTypeStr = 'Solid';
    end
    
    set(textLineType,'String',lineTypeStr);
end
        
        
function line = lengthPosLine(x,y) 
    % Calculate line length and y position
    line.length  = sqrt((x(end)-x(1)).^2+(y(end)-y(1)).^2);
    line.pos     = mean(y);
end   

function line = isValidLine(edge1,edge2)
    % Find out if a line is a valid one according to :
    % Length (at least 1m)
    % width (between 10cm and 45cm)
    % Position (between 0m and 2m from the wheel
    line.valid = false;
    lengthValid = false;
    posValid    = false;
    
    if edge1.length>0 && edge2.length>0
        lengthValid = true;
    end
    
    if edge1.pos>0 && edge2.pos>0
        posValid    = true;
    end
    
    if lengthValid && posValid
        line.length  = (edge1.length+edge2.length)/2;
        line.pos     = (edge1.pos+edge2.pos)/2;
        line.width   = abs(edge1.pos-edge2.pos);
        
        if line.length > 1000 ...
                && line.width > 60 && line.width < 450 ...
                && line.pos > 0 && line.pos < 2000
            
            line.valid = true;
        end
    else
        line.length  = 0;
        line.pos     = -255;
        line.width   = 0;
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

function [hImage  hWorld]  = plotEdges(fittedEdges,selectedEdges,hImage,hWorld,offsetVehWidth,dispPlot)
    if dispPlot==1
            % Clear plots
            clearpoints(hWorld(1));
            clearpoints(hWorld(2));
            clearpoints(hWorld(3));
            clearpoints(hWorld(4));
            clearpoints(hWorld(5));
            clearpoints(hWorld(6));
            
            
            clearpoints(hImage(1));
            clearpoints(hImage(2));
            clearpoints(hImage(3));
            clearpoints(hImage(4));
            clearpoints(hImage(5));
            clearpoints(hImage(6));
            
        
            
            % World Points
            % Detected Edges
            for i = 1:length(fittedEdges)
                addpoints(hWorld(i),fittedEdges(i).Y.*sign(offsetVehWidth)/1000+offsetVehWidth,fittedEdges(i).X./1000);
                addpoints(hImage(i),fittedEdges(i).y,fittedEdges(i).x);
                uistack(hImage(i),'top')
            end
            for i = 1:length(selectedEdges)
                addpoints(hWorld(4+i),selectedEdges(i).Y.*sign(offsetVehWidth)/1000+offsetVehWidth,selectedEdges(i).X./1000);
                addpoints(hImage(4+i),selectedEdges(i).y,selectedEdges(i).x);
                uistack(hImage(4+i),'top')
            end
            
    end
end
