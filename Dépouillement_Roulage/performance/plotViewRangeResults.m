function figViewRange = plotViewRangeResults(measure1Left,measure1Right,measure2Left,measure2Right,...
                                             results1Left,results1Right,results2Left,results2Right,...
                                             t,turnFlag,name1,name2,beginR)
    figViewRange = figure('units','normalized','outerposition',[0 0 1 1]);
    axVR(1) = subplot(3,1,1);
    xlim([t(1) t(end)]);
    hold on
    grid minor
    
    axVR(2) = subplot(3,1,2);
    hold on
    grid minor
    
    axVR(3) = subplot(3,1,3);
    ylim([-0.1 1]);
    hold on
    grid minor
    
    linkaxes(axVR,'x');
    
    plot(axVR(1),t,measure1Left,'LineWidth',1);
    plot(axVR(1),t,measure2Left,'LineWidth',1);
    
    plot(axVR(2),t,measure1Right,'LineWidth',1);
    plot(axVR(2),t,measure2Right,'LineWidth',1);
    
    plot(axVR(1),[t(1) t(end)],[results1Left.mean results1Left.mean],'--k','LineWidth',2);
    plot(axVR(1),[t(1) t(end)],[results2Left.mean results2Left.mean],'--r','LineWidth',2);
    
    plot(axVR(2),[t(1) t(end)],[results1Right.mean results1Right.mean],'--k','LineWidth',2);
    plot(axVR(2),[t(1) t(end)],[results2Right.mean results2Right.mean],'--r','LineWidth',2);
    
    plot(axVR(3),t,turnFlag,'LineWidth',1);
    
    linkaxes(axVR,'x');
    
    ylabel(axVR(1),'ViewRange Left (m)');
    ylabel(axVR(2),'ViewRange Right (m)');
    set(axVR(3),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axVR(3),'Time (s)');
    
    legend(axVR(1),name1,name2,strcat('mean ',name1),sprintf('mean \t %s',name2));
    legend(axVR(2),name1,name2,strcat('mean ',name1),sprintf('mean \t %s',name2));
    
    title(axVR(1),{strcat('\color{blue}',strrep(name1,'_',' '),'\color{black} Left line ViewRange - Mean ViewRange \color{blue}',num2str(results1Left.mean),'\color{black} m'),...
                   strcat('\color{blue}',strrep(name2,'_',' '),'\color{black} Left line ViewRange - Mean ViewRange \color{blue}',num2str(results2Left.mean),'\color{black} m')});
    
    title(axVR(2),{strcat('\color{blue}',strrep(name1,'_',' '),'\color{black} Right line ViewRange - Mean ViewRange \color{blue}',num2str(results1Right.mean),'\color{black} m'),...
                   strcat('\color{blue}',strrep(name2,'_',' '),'\color{black} Right line ViewRange - Mean ViewRange \color{blue}',num2str(results2Right.mean),'\color{black} m')});
    
    title(axVR(3),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
    