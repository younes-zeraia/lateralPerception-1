function figQuality = plotQualityResults(measure1Left,measure1Right,measure2Left,measure2Right,...
                                             results1Left,results1Right,results2Left,results2Right,...
                                             t,turnFlag,name1,name2,beginR)
    figQuality = figure('units','normalized','outerposition',[0 0 1 1]);
    axQuality(1) = subplot(3,1,1);
    xlim([t(1) t(end)]);
    ylim([-0.1 100.1]);
    hold on
    grid minor
    
    axQuality(2) = subplot(3,1,2);
    ylim([-0.1 3.1]);
    hold on
    grid minor
    
    axQuality(3) = subplot(3,1,3);
    ylim([-0.1 1]);
    hold on
    grid minor
    
    linkaxes(axQuality,'x');
    
    plot(axQuality(1),t,measure1Left,'LineWidth',1);
    plot(axQuality(1),t,measure1Right,'LineWidth',1);
    
    plot(axQuality(2),t,measure2Left,'LineWidth',1);
    plot(axQuality(2),t,measure2Right,'LineWidth',1);
    
    plot(axQuality(3),t,turnFlag,'LineWidth',1);
    
    linkaxes(axQuality,'x');
    
    ylabel(axQuality(1),'Quality FrCam');
    ylabel(axQuality(2),'Quality Fusion');
    set(axQuality(3),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axQuality(3),'Time (s)');
    
    legend(axQuality(1),'Left','Right');
    legend(axQuality(2),'Left','Right');
    
    title(axQuality(1),{strcat('\color{blue}',name1,'\color{black} Left line Quality - Good Quality overall \color{red}',num2str(results1Left.overall*100),'\color{black} %',...
                        '- Good Quality in turn \color{blue}',num2str(results1Left.curve*100),'\color{black} %','- Good Quality in straight line \color{blue}',num2str(results1Left.straight*100),'\color{black} %'),...
                        strcat('\color{red}',name1,'\color{black} Right line Quality - Good Quality overall \color{red}',num2str(results1Right.overall*100),'\color{black} %',...
                        '- Good Quality in turn \color{blue}',num2str(results1Right.curve*100),'\color{black} %','- Good Quality in straight line \color{blue}',num2str(results1Right.straight*100),'\color{black} %')});
    
    title(axQuality(2),{strcat('\color{blue}',name2,'\color{black} Left line Quality - Good Quality overall \color{red}',num2str(results2Left.overall*100),'\color{black} %',...
                        '- Good Quality in turn \color{blue}',num2str(results2Left.curve*100),'\color{black} %','- Good Quality in straight line \color{blue}',num2str(results2Left.straight*100),'\color{black} %'),...
                        strcat('\color{red}',name2,'\color{black} Right line Quality - Good Quality overall \color{red}',num2str(results2Right.overall*100),'\color{black} %',...
                        '- Good Quality in turn \color{blue}',num2str(results2Right.curve*100),'\color{black} %','- Good Quality in straight line \color{blue}',num2str(results2Right.straight*100),'\color{black} %')});
    
    title(axQuality(3),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
end