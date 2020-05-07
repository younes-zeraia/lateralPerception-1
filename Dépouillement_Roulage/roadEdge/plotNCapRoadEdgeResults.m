function figNCapRoadEdge = plotNCapRoadEdgeResults(lineTypeMes,nextLineTypeMes,lineTypeGT,measureQuality,nextMeasureQuality,t,param,NCapRoadEdgeResults,qualityMax)

    figNCapRoadEdge = figure('units','normalized','outerposition',[0 0 1 1]);
    axRE(1) = subplot(6,1,1); % Ground Truth Road Type
    
    hold on
    grid on
    set(axRE(1),'YTick',[param.undecided param.solidLine param.roadEdge param.dashedLine param.doubleLane param.bottsDots param.barrier],...
                'YTickLabel',{'UNDECIDED','SOLID','ROAD EDGE','DASHED','DOUBLE LINE','BOTTS DOTS','BARRIER'});
    ylim(axRE(1),[param.undecided param.barrier]);
    
    axRE(2) = subplot(6,1,2); % Measured Line Type
    hold on
    grid on
    set(axRE(2),'YTick',[param.undecided param.solidLine param.roadEdge param.dashedLine param.doubleLane param.bottsDots param.barrier],...
                'YTickLabel',{'UNDECIDED','SOLID','ROAD EDGE','DASHED','DOUBLE LINE','BOTTS DOTS','BARRIER'});
    ylim(axRE(2),[param.undecided param.barrier]);

    axRE(3) = subplot(6,1,3); % Next Measured Line Type
    hold on
    grid on
    set(axRE(3),'YTick',[param.undecided param.solidLine param.roadEdge param.dashedLine param.doubleLane param.bottsDots param.barrier],...
                'YTickLabel',{'UNDECIDED','SOLID','ROAD EDGE','DASHED','DOUBLE LINE','BOTTS DOTS','BARRIER'});
    ylim(axRE(3),[param.undecided param.barrier]);

    axRE(4) = subplot(6,1,4); % Offset difference
    hold on
    grid minor
    ylim([0 0.4]);

    axRE(5) = subplot(6,1,5); % Measure Line Quality
    hold on
    grid minor
    ylim([0 qualityMax*1.05]);
    
    axRE(6) = subplot(6,1,6); % Measure Next Line Quality
    hold on
    grid minor
    ylim([0 qualityMax*1.05]);
    linkaxes(axRE,'x');
    xlim([t(NCapRoadEdgeResults.indFirstPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(end))]);
    
    % axRE 1 
    plot(axRE(1),t,lineTypeGT,'LineWidth',1,'color','b');
    plot(axRE(1),[t(NCapRoadEdgeResults.indSecondPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(1))],ylim(axRE(1)),'k--','LineWidth',0.5);
    text(axRE(1),mean(t(NCapRoadEdgeResults.indFirstPhase)),param.bottsDots,'First Phase','HorizontalAlignment','center','FontSize',14);
    text(axRE(1),mean(t(NCapRoadEdgeResults.indSecondPhase)),param.bottsDots,'Second Phase','HorizontalAlignment','center','FontSize',14);
    % axRE 2
    if ~isempty(NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState) && NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState <= NCapRoadEdgeResults.indSecondPhase(end) && NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState >= NCapRoadEdgeResults.indFirstPhase(1)
        plot(axRE(2),[t(NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState) t(NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState)],ylim(axRE(2)),'r--','LineWidth',0.5);
        quiver(axRE(2), t(NCapRoadEdgeResults.indSecondPhase(1)),param.bottsDots,t(NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState)-t(NCapRoadEdgeResults.indSecondPhase(1)),0,0,'k');
        text(axRE(2),t(NCapRoadEdgeResults.secondPhaseFirstRoadEdgeState)+0.1,param.bottsDots,strcat('Delay = \color{blue}',num2str(NCapRoadEdgeResults.transitionDelay),'\color{black} s'),'FontSize',10)
    end
    plot(axRE(2),t,lineTypeMes,'LineWidth',1,'color','b');
    plot(axRE(2),[t(NCapRoadEdgeResults.indSecondPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(1))],ylim(axRE(2)),'k--','LineWidth',0.5);
    
    % axRE 3
    plot(axRE(3),t,nextLineTypeMes,'LineWidth',1,'color','b');
    plot(axRE(3),[t(NCapRoadEdgeResults.indSecondPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(1))],ylim(axRE(3)),'k--','LineWidth',0.5);
    
    % axRE 4
    plot(axRE(4),t,NCapRoadEdgeResults.diffOffset,'LineWidth',1,'color','b');
    plot(axRE(4),[t(NCapRoadEdgeResults.indSecondPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(1))],ylim(axRE(4)),'k--','LineWidth',0.5);
%     plot(axRE(4),[t(NCapRoadEdgeResults.indFirstPhase(1)) t(NCapRoadEdgeResults.indFirstPhase(end))],[NCapRoadEdgeResults.diffOffsetMean NCapRoadEdgeResults.diffOffsetMean],'k--','LineWidth',1);
    
    % axRE 5
    plot(axRE(5),t,measureQuality,'LineWidth',1,'color','b');
    plot(axRE(5),[t(NCapRoadEdgeResults.indSecondPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(1))],ylim(axRE(5)),'k--','LineWidth',0.5);
    
    % axRE 6
    plot(axRE(6),t,nextMeasureQuality,'LineWidth',1,'color','b');
    plot(axRE(6),[t(NCapRoadEdgeResults.indSecondPhase(1)) t(NCapRoadEdgeResults.indSecondPhase(1))],ylim(axRE(5)),'k--','LineWidth',0.5);
    
    ylabel(axRE(4),'{\Delta}Offset (m)');
    ylabel(axRE(5),'Quality %');
    ylabel(axRE(6),'Quality %');
    
    title(axRE(1),'\color{blue} Right Line GroundTruth \color{black}(from manual Tagging)');
    title(axRE(2),strcat('\color{blue} Right  Line \color{black} - RoadEdge Detection Results [ HIT = \color{green}',...
                         num2str(NCapRoadEdgeResults.rightRoadEdge.HIT*100),'\color{black} % - FP = \color{magenta}',...
                         num2str(NCapRoadEdgeResults.rightRoadEdge.FP*100),'\color{black} % - FN = \color{red}',...
                         num2str(NCapRoadEdgeResults.rightRoadEdge.FN*100),'\color{black} % ]'));
    title(axRE(3),strcat('\color{blue} Next Right Line \color{black} - RoadEdge Detection Results [ HIT = \color{green}',...
                         num2str(NCapRoadEdgeResults.nextRightRoadEdge.HIT*100),'\color{black} % - FN = \color{magenta}',...
                         num2str(NCapRoadEdgeResults.nextRightRoadEdge.FN*100),'\color{black} % ]'));
    
    title(axRE(4),strcat('Next Right Line and Right Line position difference - Mean During First Phase : \color{red}',num2str(NCapRoadEdgeResults.diffOffsetMean),'\color{black} m'));
    title(axRE(5),strcat('Right Line Detected Quality - Second Phase Mean =  \color{red}',num2str(NCapRoadEdgeResults.rightRoadEdge.qualityRef*100),'\color{black} %'));
    title(axRE(6),strcat('Next Right Line Detected Quality - First Phase Mean =  \color{red}',num2str(NCapRoadEdgeResults.nextRightRoadEdge.qualityRef*100),'\color{black} %'));
end