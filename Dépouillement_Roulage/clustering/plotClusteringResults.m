function figClustering = plotClusteringResults(lineTypeMesLeft,lineTypeGTLeft,lineTypeMesRight,lineTypeGTRight,lineColorMesLeft,lineColorGTLeft,lineColorMesRight,lineColorGTRight,...
                                               qualityLeft,qualityRight,t,param,clusteringResultsLeft,clusteringResultsRight)

    figClustering = figure('units','normalized','outerposition',[0 0 1 1]);
    axCL(1) = subplot(4,1,1); % Left Line Type (Reference + Measure)
    
    hold on
    grid on
    set(axCL(1),'YTick',[param.undecided param.solidLine param.roadEdge param.dashedLine param.doubleLane param.bottsDots param.barrier],...
                'YTickLabel',{'UNDECIDED','SOLID','ROAD EDGE','DASHED','DOUBLE LINE','BOTTS DOTS','BARRIER'});
    ylim(axCL(1),[param.undecided param.barrier]);
    
    axCL(2) = subplot(4,1,2); % Right Line Type (Reference + Measure)
    hold on
    grid on
    set(axCL(2),'YTick',[param.undecided param.solidLine param.roadEdge param.dashedLine param.doubleLane param.bottsDots param.barrier],...
                'YTickLabel',{'UNDECIDED','SOLID','ROAD EDGE','DASHED','DOUBLE LINE','BOTTS DOTS','BARRIER'});
    ylim(axCL(2),[param.undecided param.barrier]);

    axCL(3) = subplot(4,1,3); % Next Measured Line Type
    hold on
    grid on
    set(axCL(3),'YTick',[param.undecided param.white param.yellow param.blue],...
                'YTickLabel',{'UNDECIDED','WHITE','YELLOW','BLUE'});
    ylim(axCL(3),[param.undecided param.blue]);

    axCL(4) = subplot(4,1,4); % Measure Line Quality
    hold on
    grid minor
    ylim([0 105]);
    linkaxes(axCL,'x');
    xlim([t(1) t(end)]);
    ylabel(axCL(4),'Quality %');
    xlabel(axCL(4),'Time (s)');
    
    % axCL 1 
    plot(axCL(1),t,lineTypeMesLeft,'LineWidth',1);
    plot(axCL(1),t,lineTypeGTLeft,'LineWidth',1);
    legend(axCL(1),'Measure','GroundTruth');
    
    % axCL 2
    plot(axCL(2),t,lineTypeMesRight,'LineWidth',1);
    plot(axCL(2),t,lineTypeGTRight,'LineWidth',1);
    legend(axCL(2),'Measure','GroundTruth');
    
    % axCL 3
    plot(axCL(3),t,lineColorMesLeft,'LineWidth',1);
    plot(axCL(3),t,lineColorGTLeft,'LineWidth',1);
    plot(axCL(3),t,lineColorMesRight,'LineWidth',1);
    plot(axCL(3),t,lineColorGTRight,'LineWidth',1);
    legend(axCL(3),'Measure Left','GroundTruth Left','Measure Right','GroundTruth Right');
    
    % axCL 4
    plot(axCL(4),t,qualityLeft,'LineWidth',1);
    plot(axCL(4),t,qualityRight,'LineWidth',1);
    legend(axCL(4),'Left','Right');
    
    
    
    
    title(axCL(1),strcat('Left  Line Type  \color{red} Hit% \color{black}: [ Solid : \color{blue}',...
                         num2str(clusteringResultsLeft.solid.Hit*100),'\color{black} % - Dashed : \color{blue}',...
                         num2str(clusteringResultsLeft.dashed.Hit*100),'\color{black} % - Road Edge : \color{blue}',...
                         num2str(clusteringResultsLeft.roadEdge.Hit*100),'\color{black} % ]'));
    title(axCL(2),strcat('Right  Line Type  \color{red} Hit% \color{black}: [ Solid : \color{blue}',...
                         num2str(clusteringResultsRight.solid.Hit*100),'\color{black} % - Dashed : \color{blue}',...
                         num2str(clusteringResultsRight.dashed.Hit*100),'\color{black} % - Road Edge : \color{blue}',...
                         num2str(clusteringResultsRight.roadEdge.Hit*100),'\color{black} % ]'));
    title(axCL(3),strcat('Line Color  \color{red} Hit% \color{black}: [ White : \color{blue}',...
                         num2str((clusteringResultsLeft.white.Hit+clusteringResultsRight.white.Hit)/2*100),'\color{black} % - Yellow : \color{blue}',...
                         num2str((clusteringResultsLeft.yellow.Hit+clusteringResultsRight.yellow.Hit)/2*100),'\color{black} % - Blue : \color{blue}',...
                         num2str((clusteringResultsLeft.blue.Hit+clusteringResultsRight.blue.Hit)/2*100),'\color{black} % ]'));
    title(axCL(4),strcat('Lines Quality: [ Overall : \color{blue}',...
                         num2str((clusteringResultsLeft.quality+clusteringResultsRight.quality)/2),'\color{black} - Solid : \color{blue}',...
                         num2str((clusteringResultsLeft.solid.qualityMeanMes+clusteringResultsRight.solid.qualityMeanMes)/2),'\color{black} - Dashed : \color{blue}',...
                         num2str((clusteringResultsLeft.dashed.qualityMeanMes+clusteringResultsRight.dashed.qualityMeanMes)/2),'\color{black} - RoadEdge : \color{blue}',...
                         num2str((clusteringResultsLeft.roadEdge.qualityMeanMes+clusteringResultsRight.roadEdge.qualityMeanMes)/2),'\color{black} ]'));
    end