% This function is intended to display Line detection results using
function figHist = plotHistResults(results,DetectionSyst,RefSyst,type)

    figHist = figure('units','normalized','outerposition',[0 0 1 1]);

    axHist(1) = subplot(2,3,1);
    axHist(2) = subplot(2,3,2);
    axHist(3) = subplot(2,3,3);
    axHist(4) = subplot(2,3,4);
    axHist(5) = subplot(2,3,5);
    axHist(6) = subplot(2,3,6);
    grid(axHist(1),'minor');
    grid(axHist(2),'minor');
    grid(axHist(3),'minor');
    grid(axHist(4),'minor');
    grid(axHist(5),'minor');
    grid(axHist(6),'minor');
    hold(axHist(1),'on');
    hold(axHist(2),'on');
    hold(axHist(3),'on');
    hold(axHist(4),'on');
    hold(axHist(5),'on');
    hold(axHist(6),'on');

    xlabel(axHist(1),'Position error [m]');
    xlabel(axHist(2),'Heading error [deg]');
    xlabel(axHist(3),'Curvature error [1/m^{-1}]');
    xlabel(axHist(4),'Projected Position Error [m]');
    xlabel(axHist(5),'Projected LaneWidth Error [m]');
    xlabel(axHist(6),'viewRange [m]');
    
    switch type
        case 'overall'
            resultsOffset   = results.offset;
            resultsYaw      = results.yaw;
            resultsCurve    = results.curvature;
            resultsProjOff  = results.projOffset;
            resultsLaneWidth= results.laneWidth;
            resultsViewRange= results.viewRange;
        case 'curve'
            resultsOffset   = results.offset.curve;
            resultsYaw      = results.yaw.curve;
            resultsCurve    = results.curvature.curve;
            resultsProjOff  = results.projOffset.curve;
            resultsLaneWidth= results.laneWidth.curve;
            resultsViewRange= results.viewRange.curve;
        case 'straight'
            resultsOffset   = results.offset.straight;
            resultsYaw      = results.yaw.straight;
            resultsCurve    = results.curvature.straight;
            resultsProjOff  = results.projOffset.straight;
            resultsLaneWidth= results.laneWidth.straight;
            resultsViewRange= results.viewRange.straight;
    end
    
        

    
    histogram(axHist(1),resultsOffset.error,[-1:0.01:1]);
    % histogram(axHist(1),lateralErrorRight,[-1:0.01:1]);
    xlim(axHist(1),[-0.5,0.5]);

    histogram(axHist(2),resultsYaw.error*180/pi,[-5:0.05:5]);
    % histogram(axHist(2),relativeHeadingRight,[-5:0.05:5]);
    xlim(axHist(2),[-2.5,2.5]);

    histogram(axHist(3),resultsCurve.error*2,[-0.002:0.00001:0.002]);
    % histogram(axHist(3),curvatureErrorRight,[-0.002:0.00001:0.001]);
    xlim(axHist(3),[-0.001,0.001]);

    histogram(axHist(4),resultsProjOff.error,[-4:0.04:4]);
    % histogram(axHist(4),derCurvatureErrorLeft,[-0.00002:0.0000001:0.00002]);
    xlim(axHist(4),[-2,2]);

    histogram(axHist(5),resultsLaneWidth.error,[-4:0.04:4]);
    % histogram(axHist(5),viewRangeErrorRight,[-80:0.5:80]);
    xlim(axHist(5),[-2,2]);
    
    
    if ~isfield(resultsViewRange,'array')
        resultsViewRange.array = resultsViewRange.error;
        resultsViewRange.mean  = resultsViewRange.errorMean;
        resultsViewRange.std   = resultsViewRange.errorStd;
        histogram(axHist(6),resultsViewRange.array,[-30:0.5:30]);
        xlim(axHist(6),[-30,30]);
    else
        histogram(axHist(6),resultsViewRange.array,[0:0.5:100]);
        xlim(axHist(6),[0,100]);
    end
    
    
    % Display means
    plot(axHist(1),[resultsOffset.errorMean resultsOffset.errorMean],axHist(1).YLim,'--r','LineWidth',1.5);
    plot(axHist(2),[resultsYaw.errorMean resultsYaw.errorMean].*180/pi,axHist(2).YLim,'--r','LineWidth',1.5);
    plot(axHist(3),[resultsCurve.errorMean resultsCurve.errorMean].*2,axHist(3).YLim,'--r','LineWidth',1.5);
    plot(axHist(4),[resultsProjOff.errorMean resultsProjOff.errorMean],axHist(4).YLim,'--r','LineWidth',1.5);
    plot(axHist(5),[resultsLaneWidth.errorMean resultsLaneWidth.errorMean],axHist(5).YLim,'--r','LineWidth',1.5);
    plot(axHist(6),[resultsViewRange.mean resultsViewRange.mean],axHist(6).YLim,'--r','LineWidth',1.5);
    
    % Display stds
    nbStd = 2;
    % Mean - 2 STD
    plot(axHist(1),[resultsOffset.errorMean-nbStd*resultsOffset.errorStd resultsOffset.errorMean-nbStd*resultsOffset.errorStd],axHist(1).YLim,'--b','LineWidth',1);
    plot(axHist(2),[resultsYaw.errorMean-nbStd*resultsYaw.errorStd resultsYaw.errorMean-nbStd*resultsYaw.errorStd].*180/pi,axHist(2).YLim,'--b','LineWidth',1);
    plot(axHist(3),[resultsCurve.errorMean-nbStd*resultsCurve.errorStd resultsCurve.errorMean-nbStd*resultsCurve.errorStd].*2,axHist(3).YLim,'--b','LineWidth',1);
    plot(axHist(4),[resultsProjOff.errorMean-nbStd*resultsProjOff.errorStd resultsProjOff.errorMean-nbStd*resultsProjOff.errorStd],axHist(4).YLim,'--b','LineWidth',1);
    plot(axHist(5),[resultsLaneWidth.errorMean-nbStd*resultsLaneWidth.errorStd resultsLaneWidth.errorMean-nbStd*resultsLaneWidth.errorStd],axHist(5).YLim,'--b','LineWidth',1);
    plot(axHist(6),[resultsViewRange.mean-nbStd*resultsViewRange.std resultsViewRange.mean-nbStd*resultsViewRange.std],axHist(6).YLim,'--b','LineWidth',1);
    
    % Mean + 2 STD
    plot(axHist(1),[resultsOffset.errorMean+nbStd*resultsOffset.errorStd resultsOffset.errorMean+nbStd*resultsOffset.errorStd],axHist(1).YLim,'--b','LineWidth',1);
    plot(axHist(2),[resultsYaw.errorMean+nbStd*resultsYaw.errorStd resultsYaw.errorMean+nbStd*resultsYaw.errorStd].*180/pi,axHist(2).YLim,'--b','LineWidth',1);
    plot(axHist(3),[resultsCurve.errorMean+nbStd*resultsCurve.errorStd resultsCurve.errorMean+nbStd*resultsCurve.errorStd].*2,axHist(3).YLim,'--b','LineWidth',1);
    plot(axHist(4),[resultsProjOff.errorMean+nbStd*resultsProjOff.errorStd resultsProjOff.errorMean+nbStd*resultsProjOff.errorStd],axHist(4).YLim,'--b','LineWidth',1);
    plot(axHist(5),[resultsLaneWidth.errorMean+nbStd*resultsLaneWidth.errorStd resultsLaneWidth.errorMean+nbStd*resultsLaneWidth.errorStd],axHist(5).YLim,'--b','LineWidth',1);
    plot(axHist(6),[resultsViewRange.mean+nbStd*resultsViewRange.std resultsViewRange.mean+nbStd*resultsViewRange.std],axHist(6).YLim,'--b','LineWidth',1);
    
%     textRatio = [1/10 5/6];
%     text(axHist(1),axHist(1).XLim(1)+(axHist(1).XLim(2)-axHist(1).XLim(1))*textRatio(1),axHist(1).YLim(1)+(axHist(1).YLim(2)-axHist(1).YLim(1))*textRatio(2),[num2str(resultsOffset.errorMean) 'm'],'Color','red');
%     text(axHist(2),axHist(2).XLim(1)+(axHist(2).XLim(2)-axHist(2).XLim(1))*textRatio(1),axHist(2).YLim(1)+(axHist(2).YLim(2)-axHist(2).YLim(1))*textRatio(2),[num2str(resultsYaw.errorMean) '°'],'Color','red');
%     text(axHist(3),axHist(3).XLim(1)+(axHist(3).XLim(2)-axHist(3).XLim(1))*textRatio(1),axHist(3).YLim(1)+(axHist(3).YLim(2)-axHist(3).YLim(1))*textRatio(2),[num2str(resultsCurve.errorMean) 'm^{-1}'],'Color','red');
%     text(axHist(4),axHist(4).XLim(1)+(axHist(4).XLim(2)-axHist(4).XLim(1))*textRatio(1),axHist(4).YLim(1)+(axHist(4).YLim(2)-axHist(4).YLim(1))*textRatio(2),[num2str(resultsProjOff.errorMean) 'm'],'Color','red');
%     text(axHist(5),axHist(5).XLim(1)+(axHist(5).XLim(2)-axHist(5).XLim(1))*textRatio(1),axHist(5).YLim(1)+(axHist(5).YLim(2)-axHist(5).YLim(1))*textRatio(2),[num2str(resultsLaneWidth.errorMean) 'm'],'Color','red');
%     text(axHist(6),axHist(6).XLim(1)+(axHist(6).XLim(2)-axHist(6).XLim(1))*textRatio(1),axHist(6).YLim(1)+(axHist(6).YLim(2)-axHist(6).YLim(1))*textRatio(2),[num2str(resultsViewRange.mean) 'm'],'Color','red');
%     
    title(axHist(1),strcat('Offset : [ {\mu} = \color{red}',num2str(resultsOffset.errorMean,4),'\color{black}m , {\sigma} = \color{blue}',num2str(resultsOffset.errorStd,4),'\color{black}m ]'));
    title(axHist(2),strcat('Yaw : [ {\mu} = \color{red}',num2str(resultsYaw.errorMean*180/pi,4),'\color{black}° , {\sigma} = \color{blue}',num2str(resultsYaw.errorStd*180/pi,4),'\color{black}° ]'));
    title(axHist(3),strcat('Curvature : [ {\mu} = \color{red}',num2str(resultsCurve.errorMean*2,4),'\color{black}m^{-1} , {\sigma} = \color{blue}',num2str(resultsCurve.errorStd*2,4),'\color{black}m^{-1} ]'));
    title(axHist(4),strcat('yL40m : [ {\mu} = \color{red}',num2str(resultsProjOff.errorMean,4),'\color{black}m , {\sigma} = \color{blue}',num2str(resultsProjOff.errorStd,4),'\color{black}m ]'));
    title(axHist(5),strcat('laneWidth : [ {\mu} = \color{red}',num2str(resultsLaneWidth.errorMean,4),'\color{black}m , {\sigma} = \color{blue}',num2str(resultsLaneWidth.errorStd,4),'\color{black}m ]'));
    title(axHist(6),strcat('viewRange : [ {\mu} = \color{red}',num2str(resultsViewRange.mean,4),'\color{black}m , {\sigma} = \color{blue}',num2str(resultsViewRange.std,4),'\color{black}m ]'));

    mtit(figHist,strcat('\color{black}',strrep(DetectionSyst,'_',' '),' \color{green} ',type,'\color{black} VS \color{black}',RefSyst,'\color{black} histogram results'),'xoff',0,'yoff',0.03,'fontsize',16)
%     title(axHist(1),strcat('\color{blue}',DetectionSyst,Side,'\color{black} VS \color{red}',RefSyst,'HIST plot error c0'));
%     title(axHist(2),'HIST plot error c1');
%     title(axHist(3),'HIST plot error c2');
%     title(axHist(4),'HIST plot error c3');
%     title(axHist(5),'HIST plot error viewRange');
%     title(axHist(6),'HIST plot error yL 40m');

end