function figPosition = plotOffsetResults(measure1,measure2,reference,t,results1,results2,inTurnFlag,nameCurve1,nameCurve2,beginR,targetPrecision,side,distProjection)

    figPosition = figure('units','normalized','outerposition',[0 0 1 1]);
    axPos(1) = subplot(4,1,1);
    xlim([t(1) t(end)]);
    hold on
    grid minor
    
    axPos(2) = subplot(4,1,2);
    if distProjection == 0
        ylim([-0.5 0.5]);
    else
        ylim([-1 1]);
    end
    
    hold on
    grid minor
    
    axPos(3) = subplot(4,1,3);
    if distProjection == 0
        ylim([-0.5 0.5]);
    else
        ylim([-1 1]);
    end
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
    
    plot(axPos(2),t,results1.error,'LineWidth',1);
    
    plot(axPos(3),t,results2.error,'LineWidth',1);
    
    plot(axPos(4),t,inTurnFlag,'LineWidth',1);
    
    linkaxes(axPos,'x');
    
    ylabel(axPos(1),'Line Offset (m)');
    ylabel(axPos(2),strcat(nameCurve1,'Offset Error (m)'));
    ylabel(axPos(3),strcat(nameCurve2,'Offset Error (m)'));
    set(axPos(4),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axPos(4),'Time (s)');
    
    legend(axPos(1),nameCurve1,nameCurve2,'GroundTruth');
    
    title(axPos(1),strcat('\color{blue}',side, '\color{black} line position projected at \color{blue}',num2str(distProjection),'\color{black} m'));
    title(axPos(2),strcat('\color{blue}',strrep(nameCurve1,'_',' '), '\color{black} VS GroundTruth - {\mu} : \color{red}',num2str(results1.errorMean*100),'\color{black} cm',...   
                     ' / {\mu}-2{\sigma} : \color{blue}',num2str((results1.errorMean-2*results1.errorStd)*100),'\color{black} cm',...
                     ' / {\mu}+2{\sigma} : \color{blue}',num2str((results1.errorMean+2*results1.errorStd)*100),'\color{black} cm'));
    title(axPos(3),strcat('\color{blue}',strrep(nameCurve2,'_',' '), '\color{black} VS GroundTruth - {\mu} : \color{red}',num2str(results2.errorMean*100),'\color{black} cm',...   
                     ' / {\mu}-2{\sigma} : \color{blue}',num2str((results2.errorMean-2*results2.errorStd)*100),'\color{black} cm',...
                     ' / {\mu}+2{\sigma} : \color{blue}',num2str((results2.errorMean+2*results2.errorStd)*100),'\color{black} cm'));
    title(axPos(4),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
end