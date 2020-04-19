function figPosition = plotOffsetDiffResults(measure1Left,measure1Right,measure2Left,measure2Right,t,inTurnFlag,nameCurve1,nameCurve2,beginR)

    figPosition = figure('units','normalized','outerposition',[0 0 1 1]);
    axPosDiff(1) = subplot(2,1,1);
    ylim([-0.1 1]);
    xlim([t(1) t(end)]);
    hold on
    grid minor
    
    axPosDiff(2) = subplot(2,1,2);
    ylim([-0.1 1.1]);
    hold on
    grid minor
    
    linkaxes(axPosDiff,'x');
    
    plot(axPosDiff(1),t,abs(measure2Left-measure1Left),'LineWidth',1);
    plot(axPosDiff(1),t,abs(measure2Right-measure1Right),'LineWidth',1);
    
    plot(axPosDiff(2),t,inTurnFlag,'LineWidth',1);
    
    linkaxes(axPosDiff,'x');
    
    ylabel(axPosDiff(1),'Line Offset Diff (m)');
    set(axPosDiff(2),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axPosDiff(2),'Time (s)');
    
    legend(axPosDiff(1),'Left','Right');
    
    title(axPosDiff(1),strcat('line Offset Diff between \color{blue}',replace(nameCurve1,'_','\_'),'\color{black} and \color{blue}',replace(nameCurve2,'_','\_')));
    title(axPosDiff(2),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
end