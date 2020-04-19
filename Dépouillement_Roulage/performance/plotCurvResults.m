function figCurve = plotCurvResults(curv1,curv2,t,turns,nameCurv1,nameCurv2)
    
    iRiseTurn = find(diff(turns.InTurnFlag)==1);
    iFallTurn = find(diff(turns.InTurnFlag)==-1);

    figCurve = figure('units','normalized','outerposition',[0 0 1 1]);
    axCurv(1) = subplot(1,1,1);
%     ylim([-0.004 0.004]);
    xlim([0 t(end)]);
    hold on
    grid minor
    
%     axCurv(2) = subplot(2,1,2);
% %     ylim([-0.004 0.004]);
%     hold on
%     grid minor
    
    linkaxes(axCurv,'x');
    
    plot(axCurv(1),t,curv1,'LineWidth',1,'color','b');
    plot(axCurv(1),t,curv2,'LineWidth',1,'color','k');
    for turn = 1:length(turns.curvatureError1)
        plot(axCurv(1),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.curvatureNom1(turn) turns.curvatureNom1(turn)],'--b','LineWidth',1);
%         text(axCurv(1),t(iFallTurn(turn)),turns.curvatureNom1(turn),strcat('\leftarrow \color{blue} Error : ',num2str(turns.curvatureError1(turn)*100),'%'));
        
        plot(axCurv(1),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.curvatureNom2(turn) turns.curvatureNom2(turn)],'--k','LineWidth',1);
%         text(axCurv(1),t(iFallTurn(turn)),turns.curvatureNom2(turn),strcat('\leftarrow \color{black} Error : ',num2str(turns.curvatureError2(turn)*100),'%'));
        
        plot(axCurv(1),t([iRiseTurn(turn) iFallTurn(turn)]),[turns.GTCurvatureNom(turn)  turns.GTCurvatureNom(turn)],'--r','LineWidth',1);
    end
    
    
    title(axCurv(1),{strcat('\color{blue}',nameCurv1,'\color{black} Curvature (C2) - Mean Error : \color{red}',num2str(mean(turns.curvatureError1)*100),'\color{black} %',...   
                     ' / Mean Overshoot : \color{red}',num2str(mean(turns.curvatureOvershoot1)*100),'\color{black} %',...
                     ' / Mean Undershoot : \color{red} ',num2str(mean(turns.curvatureUndershoot1(turn))*100),'\color{black} %'),...
                     strcat('\color{blue}',nameCurv2,'\color{black} Curvature (C2) - Mean Error : \color{red}',num2str(mean(turns.curvatureError2)*100),'\color{black} %',...   
                     ' / Mean Overshoot : \color{red}',num2str(mean(turns.curvatureOvershoot2)*100),'\color{black} %',...
                     ' / Mean Undershoot : \color{red} ',num2str(mean(turns.curvatureUndershoot2(turn))*100),'\color{black} %')});
                 
%     title(axCurv(2),['Curvature 2 (C2) - Mean Error : \color{blue}' num2str(mean(turns.curvatureError2)*100) '\color{black} %'...   
%                      ' / Mean Overshoot : \color{red}' num2str(mean(turns.curvatureOvershoot2)*100) '\color{black} %'...
%                      ' / Mean Undershoot : \color{magenta} ' num2str(mean(turns.curvatureUndershoot2)*100) '\color{black} %']);
    legend(axCurv(1),{nameCurv1,nameCurv2,strcat('mean',nameCurv1),strcat('mean',nameCurv2),'mean Ground Truth'},'EdgeColor','r','FontSize',14);
    ylabel(axCurv(1),'Curvature (C2)');
%     ylabel(axCurv(2),'Curvature (C2)');
    xlabel(axCurv(1),'Time (s)');
end