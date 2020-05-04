function figYawAngle = plotYawAngleResults(measure1,measure2,reference,t,results1,results2,inTurnFlag,nameCurve1,nameCurve2,beginR,targetPrecision,side)

    figYawAngle = figure('units','normalized','outerposition',[0 0 1 1]);
    axYaw(1) = subplot(4,1,1);
    ylim([-0.1 0.1]);
    xlim([t(1) t(end)]);
    hold on
    grid minor
    
    axYaw(2) = subplot(4,1,2);
    ylim([-0.05 0.05]);
    hold on
    grid minor
    
    axYaw(3) = subplot(4,1,3);
    ylim([-0.05 0.05]);
    hold on
    grid minor
    
    axYaw(4) = subplot(4,1,4);
    ylim([-0.1 1.1]);
    hold on
    grid minor
    
    linkaxes(axYaw,'x');
    
    plot(axYaw(1),t,measure1,'LineWidth',1);
    plot(axYaw(1),t,measure2,'LineWidth',1);
    plot(axYaw(1),t,reference,'LineWidth',1);
    
    plot(axYaw(2),t,results1.error,'LineWidth',1);
    
    plot(axYaw(3),t,results2.error,'LineWidth',1);
    
    plot(axYaw(4),t,inTurnFlag,'LineWidth',1);
    
    linkaxes(axYaw,'x');
    
    ylabel(axYaw(1),'Yaw Angle (rad)');
    ylabel(axYaw(2),strcat('Angle Error (rad)'));
    ylabel(axYaw(3),strcat('Angle Error (rad)'));
    set(axYaw(4),'ytick',[0 1],'yticklabel',{'Straight';'Curve'});
    xlabel(axYaw(4),'Time (s)');
    
    legend(axYaw(1),nameCurve1,nameCurve2,'GroundTruth');
    
    title(axYaw(1),strcat('\color{blue}',side, '\color{black} line Yaw Angle (rad)'));
    title(axYaw(2),strcat('\color{blue}',strrep(nameCurve1,'_',' '), '\color{black} VS GroundTruth - [ {\mu} : \color{red}',num2str(results1.errorMean*180/pi),'\color{black}°',...   
                     ' / {\mu}-2{\sigma} : \color{blue}',num2str((results1.errorMean-2*results1.errorStd)*180/pi),'\color{black}°',...
                     ' / {\mu}+2{\sigma} : \color{blue}',num2str((results1.errorMean+2*results1.errorStd)*180/pi),'\color{black}° ]'));
    title(axYaw(3),strcat('\color{blue}',strrep(nameCurve2,'_',' '), '\color{black} VS GroundTruth - [ {\mu} : \color{red}',num2str(results2.errorMean*180/pi),'\color{black}°',...   
                      ' / {\mu}-2{\sigma} : \color{blue}',num2str((results2.errorMean-2*results2.errorStd)*180/pi),'\color{black}°',...
                     ' / {\mu}+2{\sigma} : \color{blue}',num2str((results2.errorMean+2*results2.errorStd)*180/pi),'\color{black}° ]'));
    title(axYaw(4),strcat('In Curve indicator (Radius < \color{blue}',num2str(beginR),'\color{black} m'));
end