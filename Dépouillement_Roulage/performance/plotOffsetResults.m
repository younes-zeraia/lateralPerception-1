function figPosition = plotOffsetResults(measure1,measure2,reference,t,results1,results2,inTurnFlag,nameCurve1,nameCurve2,beginR,targetPrecision,side,distProjection)

    figPosition = figure('units','normalized','outerposition',[0 0 1 1]);
    axPos(1) = subplot(4,1,1);
    xlim([t(1) t(end)]);
    hold on
    grid minor
    
    axPos(2) = subplot(4,1,2);
    ylim([-0.1 1]);
    hold on
    grid minor
    
    axPos(3) = subplot(4,1,3);
    ylim([-0.1 1]);
    hold on
    grid minor
    
    axPos(4) = subplot(4,1,4);
    ylim([-0.1 1.1]);
    hold on
    grid minor
    
    linkaxes(axPos,'x');
    
    plot(axPos(1),t,measure1,'LineWidth',1);
    plot(axPos(1),t,measure2,'LineWidth',1);
    plot(axPos(1),t,reference,'LineWidth',1);
    
    plot(axPos(2),t,results1.overall.error,'LineWidth',1);
    
    plot(axPos(3),t,results2.overall.error,'LineWidth',1);
    
    plot(axPos(4),t,inTurnFlag,'LineWidth',1);
    
    linkaxes(axPos,'x');
    
    ylabel(axPos(1),'Line Offset (m)');
    ylabel(axPos(2),strcat(nameCurve1,'Offset Error (m)'));
    ylabel(axPos(3),strcat(nameCurve2,'Offset Error (m)'));
    set(axPos(4),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axPos(4),'Time (s)');
    
    legend(axPos(1),nameCurve1,nameCurve2,'GroundTruth');
    
    title(axPos(1),strcat('\color{blue}',side, '\color{black} line position projected at \color{blue}',num2str(distProjection),'\color{black} m'));
    title(axPos(2),strcat('\color{blue}',nameCurve1, '\color{black} VS GroundTruth - Mean Error : \color{red}',num2str(results1.overall.meanError*100),'\color{black} cm',...   
                     ' / Max Error : \color{red}',num2str(results1.overall.maxError*100),'\color{black} cm',...
                     ' / time ratio good accuracy (<\color{blue}',num2str(targetPrecision*100),'\color{black}cm) : \color{red}',num2str(results1.overall.accuracyRatio*100),'\color{black} %'));
    title(axPos(3),strcat('\color{blue}',nameCurve2, '\color{black} VS GroundTruth - Mean Error : \color{red}',num2str(results2.overall.meanError*100),'\color{black} cm',...   
                     ' / Max Error : \color{red}',num2str(results2.overall.maxError*100),'\color{black} cm',...
                     ' / time ratio good accuracy (<\color{blue}',num2str(targetPrecision*100),'\color{black}cm) : \color{red}',num2str(results2.overall.accuracyRatio*100),'\color{black} %'));
    title(axPos(4),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
end