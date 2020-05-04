function figLaneWidth = plotLaneWidthResults(measure1,measure2,reference,t,results1,results2,inTurnFlag,name1,name2,beginR,targetPrecision,distProjection)

    figLaneWidth = figure('units','normalized','outerposition',[0 0 1 1]);
    axLW(1) = subplot(4,1,1);
    xlim([t(1) t(end)]);
    hold on
    grid minor
    
    axLW(2) = subplot(4,1,2);
%     ylim([-0.1 1]);
    hold on
    grid minor
    
    axLW(3) = subplot(4,1,3);
%     ylim([-0.1 1]);
    hold on
    grid minor
    
    axLW(4) = subplot(4,1,4);
    ylim([-0.1 1.1]);
    hold on
    grid minor
    
    linkaxes(axLW,'x');
    
    
    plot(axLW(1),t,measure1,'LineWidth',1);
    plot(axLW(1),t,measure2,'LineWidth',1);
    plot(axLW(1),t,reference,'LineWidth',1);
    
    plot(axLW(2),t,results1.error,'LineWidth',1);
    
    plot(axLW(3),t,results2.error,'LineWidth',1);
    
    plot(axLW(4),t,inTurnFlag,'LineWidth',1);
    
    linkaxes(axLW,'x');
    
    ylabel(axLW(1),'Line Offset (m)');
    ylabel(axLW(2),strcat(name1,'Offset Error (m)'));
    ylabel(axLW(3),strcat(name2,'Offset Error (m)'));
    set(axLW(4),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axLW(4),'Time (s)');
    
    legend(axLW(1),name1,name2,'GroundTruth');
    
    title(axLW(1),strcat('LaneWidth projected at \color{blue}',num2str(distProjection),'\color{black} m'));
    title(axLW(2),strcat('\color{blue}',strrep(name1,'_',' '), '\color{black} VS GroundTruth - Mean Error : \color{red}',num2str(results1.errorMean*100),'\color{black} cm',...   
                      ' / {\mu}-2{\sigma} : \color{blue}',num2str((results1.errorMean-2*results1.errorStd)*100),'\color{black} cm',...
                     ' / {\mu}+2{\sigma} : \color{blue}',num2str((results1.errorMean+2*results1.errorStd)*100),'\color{black} cm ]'));
    title(axLW(3),strcat('\color{blue}',strrep(name2,'_',' '), '\color{black} VS GroundTruth - Mean Error : \color{red}',num2str(results2.errorMean*100),'\color{black} cm',...   
                      ' / {\mu}-2{\sigma} : \color{blue}',num2str((results2.errorMean-2*results2.errorStd)*100),'\color{black} cm',...
                     ' / {\mu}+2{\sigma} : \color{blue}',num2str((results2.errorMean+2*results2.errorStd)*100),'\color{black} cm ]'));
    title(axLW(4),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
end