% this function is intended to compare a measured line to a ground truth
% the comparison is based on C0-C1-C2-C3 coeffs :

% 1 : Line offsets (c0) : mean absolute error
% 2 : Line curvatures (c2) : error of each turn + mean error + mean over and under shoots
% 3 : projected laneWidth (c0-c1-c2-c3) : mean absolute error + pics (laneWidth measure < 2.5m)

function compareDetection();
    %% load logs
    scriptPath = pwd;
    run('initParams');
    testpath1 = getTestPath(initPath);
    testpath2 = getTestPath(initPath);
    logName1  = uigetfile(testpath1,'*.mat');
    logName2  = uigetfile(testpath2,'*.mat');
    
    log1 = load(fullfile(testpath1,logName1));
    log2 = load(fullfile(testpath2,logName2));
    %% lines detection
    lines1 = detectPolyCoefs(log1);
    lines2 = detectPolyCoefs(log2);
    
    %% Logs synchronisation

    % If the logs were taken at different speeds : adjust the slowest one
    % to match the fastest
    inTurnFlag1 = getInTurnFlag(lines1.CamLeftLine.curvature,beginR,endR);
    inTurnFlag2 = getInTurnFlag(lines2.CamLeftLine.curvature,beginR,endR);
    
    iTurn1      = [find(diff(inTurnFlag1)==1) find(diff(inTurnFlag1)==-1)];
    iTurn2      = [find(diff(inTurnFlag2)==1) find(diff(inTurnFlag2)==-1)];
    
    turnDuration1 = mean(iTurn1(:,2)-iTurn1(:,1));
    turnDuration2 = mean(iTurn2(:,2)-iTurn2(:,1));

    if turnDuration1>turnDuration2 % first log at lower speed
        t           = log1.t;
        tInterp1    = t(1:turnDuration1/turnDuration2:end);
        tInterp2    = log2.t;
        lines1      = interpLines(lines1,t,tInterp1);
        inTurnFlag1 = getInTurnFlag(lines1.CamLeftLine.curvature,beginR,endR);
    else
        t           = log2.t;
        tInterp2    = t(1:turnDuration1/turnDuration2:end);
        tInterp1    = log1.t;
        lines2      = interpLines(lines2,t,tInterp2);
        inTurnFlag2 = getInTurnFlag(lines2.CamLeftLine.curvature,beginR,endR);
    end 
    
    
    % Once the turns have the same durations, we synchronized the logs so
    % that they begin at the same time.
%     [offset correlCoef] = findCorrelation(inTurnFlag1,inTurnFlag2,100,100,true);
    [offset correlCoef] = findCorrelation(lines1.CamLeftLine.curvature,lines2.CamLeftLine.curvature,100,100,false);
    t1 = tInterp1;
    t2 = tInterp2;
    if offset<0
        indBegin    = abs(offset);
        indEnd      = length(t2)-1+abs(offset);
        t1Offset    = t1(indBegin:indEnd);
        lines1      = interpLines(lines1,t1,t1Offset);
        t = [0:length(t2)-1]./100;
    else
        indBegin    = abs(offset);
        indEnd      = length(t1)-1+abs(offset);
        t2Offset    = t2(indBegin:indEnd);
        lines2      = interpLines(lines2,t2,t2Offset);
        t = [0:length(t1)-1]./100;
    end
    
    %% Curvature comparison

    % Curvature process
    leftturns  = detectTurns(lines1.CamLeftLine.curvature,lines2.CamLeftLine.curvature,lines1.GTLeftLine.curvature,beginR,endR);
    rightTurns = detectTurns(lines1.CamRightLine.curvature,lines2.CamRightLine.curvature,lines1.GTRightLine.curvature,beginR,endR);
    
    % Curvature plot
    plotCurvResults(lines1.CamRightLine.curvature,lines2.CamLeftLine.curvature,t,leftturns,'left curv ZF Frcam','left curv Valeo FrCam');
    plotCurvResults(lines1.CamRightLine.curvature,lines2.CamRightLine.curvature,t,rightTurns,'right curv ZF Frcam','right curv Valeo FrCam');
    
    %% LaneWidth comparison
    
    % Lanewidth process
    CamProjLaneWidth = getProjLaneWidth(lines1.CamLeftLine.offset,log.Cam_InfrastructureLines_CamLeftLineYawAngle,log.Cam_InfrastructureLines_CamLeftLineCurvature,log.Cam_InfrastructureLines_CamLeftLineCurvatureRate,...
                                        log.Cam_InfrastructureLines_CamRightLineOffset,log.Cam_InfrastructureLines_CamRightLineYawAngle,log.Cam_InfrastructureLines_CamRightLineCurvature,log.Cam_InfrastructureLines_CamRightLineCurvatureRate,...
                                        log.Cam_InfrastructureLines_CamLeftLineQuality,log.Cam_InfrastructureLines_CamRightLineQuality,distProjLaneWidth);
    FusionProjLaneWidth = getProjLaneWidth(log.PositionLineLeft,log.LeftLineYawAngle,log.CurvatureLineLeft,log.CurvatureDerivativeLineLeft,...
                                           log.PositionLineRight,log.RightLineYawAngle,log.CurvatureLineRight,log.CurvatureDerivativeLineRight,...
                                           log.QualityLineLeft,log.QualityLineRight,distProjLaneWidth);
    GTProjLaneWidth = getProjLaneWidth(log.GT_leftC0Raw,log.GT_leftC1Raw,log.GT_leftC2Raw,log.GT_leftC3Raw,...
                                       log.GT_rightC0Raw,log.GT_rightC1Raw,log.GT_rightC2Raw,log.GT_rightC3Raw,...
                                       log.QualityLineLeft.*0+1,log.QualityLineLeft.*0+1,distProjLaneWidth);
    
    
    % LaneWidth plot
    
    
    %% Line quality Comparison
    
    % Process
    
    % Plot
    
    %% Line Type Comparison
    
    % Process
    
    % Plot
end

%% FUNCTIONS

% This function is intended to detect all poly coefs of a log
function lines = detectPolyCoefs(log)
    fields = fieldnames(log);
    
    indCurvatureNames       = find(contains(lower(fields),'curvature'));
    indCurvatureRateNames   = find(contains(lower(fields),'derivativecurvature') | contains(lower(fields),'curvaturerate') &...
                                   ~contains(fields,'VAR'));
    gtLinesFound            = false;                       
    camLinesFound           = false;
    for currInd = indCurvatureRateNames'
        indStrLine          = strfind(lower(fields{currInd}),'line');
        lineName            = fields{currInd}(1:indStrLine(end)+3); % we save the name of the line (keeping the last 'Line')
        lineVar             = fields(find(startsWith(fields,lineName)  & ~contains(fields,'VAR')));
        
        currLine = struct();
        
        try
            currLine.offset              = getfield(log,lineVar{find(contains(lower(lineVar),'offset'))});
        end
        
        try
            currLine.yawAngle            = getfield(log,lineVar{find(contains(lower(lineVar),'yaw'))});
        end
        
        try
            currLine.curvature           = getfield(log,lineVar{find(contains(lower(lineVar),'curvature') & ~contains(lower(lineVar),'curvaturerate') & ~contains(lower(lineVar),'derivativecurvature'))});
        end
        
        try
            currLine.curvatureRate       = getfield(log,lineVar{find(contains(lower(lineVar),'curvaturerate') | contains(lower(lineVar),'derivativecurvature'))});
        end
        
        if any(contains(lower(lineVar),'quality'))
            currLine.confidence          = getfield(log,lineVar{find(contains(lower(lineVar),'quality'))});
        else
            try
                currLine.confidence          = getfield(log,lineVar{find(contains(lower(lineVar),'confidence'))});
                if max(currLine.confidence <=3)
                    currLine.confidence = interp1([0:3],[0:100],currLine.confidence);
                end
            end
        end
        
        if contains(lower(lineName),'gt')
            gtLinesFound    = true;
            if contains(lower(lineName),'left')
                if contains(lower(lineName),'leftleft') || contains(lower(lineName),'nextleft')
                    lines.GTNextLeftLine   = currLine;
                else
                    lines.GTLeftLine       = currLine;
                end
            elseif contains(lower(lineName),'right')
                if contains(lower(lineName),'rightright') || contains(lower(lineName),'nextright')
                    lines.GTNextRightLine  = currLine;
                else
                    lines.GTRightLine      = currLine;
                end
            end
        elseif contains(lower(lineName),'cam')
            camLinesFound   = true;
            if contains(lower(lineName),'left')
                if contains(lower(lineName),'leftleft') || contains(lower(lineName),'nextleft')
                    lines.CamNextLeftLine   = currLine;
                else
                    lines.CamLeftLine       = currLine;
                end
            elseif contains(lower(lineName),'right')
                if contains(lower(lineName),'rightright') || contains(lower(lineName),'nextright')
                    lines.CamNextRightLine  = currLine;
                else
                    lines.CamRightLine      = currLine;
                end
            end
        else
            if contains(lower(lineName),'left')
                if contains(lower(lineName),'leftleft') || contains(lower(lineName),'nextleft')
                    lines.FusNextLeftLine   = currLine;
                else
                    lines.FusLeftLine       = currLine;
                end
            elseif contains(lower(lineName),'right')
                if contains(lower(lineName),'rightright') || contains(lower(lineName),'nextright')
                    lines.FusNextRightLine  = currLine;
                else
                    lines.FusRightLine      = currLine;
                end
            end
        end
    end
    
    
    if camLinesFound == false
        lines.CamNextLeftLine   = lines.FusNextLeftLine;
        lines.CamLeftLine       = lines.FusLeftLine;
        lines.CamNextRightLine  = lines.FusNextRightLine;
        lines.CamRightLine      = lines.FusRightLine;
        
        lines = rmfield(lines,'FusNextLeftLine');
        lines = rmfield(lines,'FusLeftLine');
        lines = rmfield(lines,'FusNextRightLine');
        lines = rmfield(lines,'FusRightLine');
    end
end


function inTurn = getInTurnFlag(curvature,beginR,endR)
    nElems = length(curvature);
    inTurn = zeros(nElems,1);
    for i = 2:nElems
        if inTurn(i-1) == 0 
            if abs(curvature(i))> 1/beginR
                inTurn(i) = 1;
            end
        else
            if abs(curvature(i)) > 1/endR
                inTurn(i) = 1;
            end
        end
    end
end

function lines = interpLines(lines,tOrig,tInterp)
    lineNames = fieldnames(lines);
    for currLineInd = 1:length(lineNames)
        currLine = getfield(lines,lineNames{currLineInd});
        fields = fieldnames(currLine);
        for currFieldInd = 1:length(fields)
            currField = fields{currFieldInd};
            currValue = getfield(currLine,currField);
            currLine  = setfield(currLine,currField,interp1(tOrig,currValue,tInterp));
        end
        lines = setfield(lines,lineNames{currLineInd},currLine);
    end
end

function plotCurvResults(curv1,curv2,t,turns,nameCurv1,nameCurv2)
    
    iRiseTurn = find(diff(turns.InTurnFlag)==1);
    iFallTurn = find(diff(turns.InTurnFlag)==-1);

    figCurve = figure;
    axCurv(1) = subplot(1,1,1);
%     ylim([-0.004 0.004]);
    xlim([0 t(end)]);
    hold on
    grid minor
    
%     axCurv(2) = subplot(2,1,2);
% %     ylim([-0.004 0.004]);
%     hold on
%     grid minor
    
    linkaxes(axCurv,'x');
    
    plot(axCurv(1),t,curv1,'LineWidth',1,'color','b');
    plot(axCurv(1),t,curv2,'LineWidth',1,'color','k');
    for turn = 1:length(turns.curvatureError1)
        plot(axCurv(1),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.curvatureNom1(turn) turns.curvatureNom1(turn)],'--b','LineWidth',1);
        text(axCurv(1),t(iFallTurn(turn)),turns.curvatureNom1(turn),strcat('\leftarrow \color{blue} Error : ',num2str(turns.curvatureError1(turn)*100),'%'));
        
        plot(axCurv(1),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.curvatureNom2(turn) turns.curvatureNom2(turn)],'--k','LineWidth',1);
%         plot(axCurv(2),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.GTCurvatureNom(turn)  turns.GTCurvatureNom(turn)],'--r','LineWidth',1);
        text(axCurv(1),t(iFallTurn(turn)),turns.curvatureNom2(turn),strcat('\leftarrow \color{black} Error : ',num2str(turns.curvatureError2(turn)*100),'%'));
        
        
        plot(axCurv(1),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.GTCurvatureNom(turn)  turns.GTCurvatureNom(turn)],'--r','LineWidth',1);
    end
    
    title(axCurv(1),{strcat('\color{blue} Curvature 1 \color{black} (C2) - Mean Error : \color{blue}',num2str(mean(turns.curvatureError1)*100),'\color{black} %',...   
                     ' / Mean Overshoot : \color{red}',num2str(mean(turns.curvatureOvershoot1)*100),'\color{black} %',...
                     ' / Mean Undershoot : \color{magenta} ',num2str(mean(turns.curvatureUndershoot1(turn))*100),'\color{black} %'),...
                     strcat('Curvature 2 (C2) - Mean Error : \color{blue}',num2str(mean(turns.curvatureError2)*100),'\color{black} %',...   
                     ' / Mean Overshoot : \color{red}',num2str(mean(turns.curvatureOvershoot2)*100),'\color{black} %',...
                     ' / Mean Undershoot : \color{magenta} ',num2str(mean(turns.curvatureUndershoot2(turn))*100),'\color{black} %')});
                 
%     title(axCurv(2),['Curvature 2 (C2) - Mean Error : \color{blue}' num2str(mean(turns.curvatureError2)*100) '\color{black} %'...   
%                      ' / Mean Overshoot : \color{red}' num2str(mean(turns.curvatureOvershoot2)*100) '\color{black} %'...
%                      ' / Mean Undershoot : \color{magenta} ' num2str(mean(turns.curvatureUndershoot2)*100) '\color{black} %']);
    legend(axCurv(1),{nameCurv1,nameCurv2,strcat('mean',nameCurv1),strcat('mean',nameCurv2),'mean Ground Truth'},'EdgeColor','r','FontSize',14);
    ylabel(axCurv(1),'Curvature (C2)');
%     ylabel(axCurv(2),'Curvature (C2)');
    xlabel(axCurv(1),'Time (s)');
end