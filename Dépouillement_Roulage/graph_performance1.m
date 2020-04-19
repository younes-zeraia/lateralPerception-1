%charger fichier acquis dans le wk

% PerformanceLines
        %Cam
CamLeftLineStartViewRange=Cam_InfrastructureLines_CamLeftLineStartViewRange;
% CamLeftLineEndViewRange=Cam_InfrastructureLines_CamLeftLineEndViewRange;
CamLeftLineQuality=Cam_InfrastructureLines_CamLeftLineQuality;
CamLeftLineMarkWidth=Cam_InfrastructureLines_CamLeftLineMarkWidth;
CamLeftLineID=Cam_InfrastructureLines_CamLeftLineID;

CamRightLineStartViewRange=Cam_InfrastructureLines_CamRightLineStartViewRange;
CamRightLineEndViewRange=Cam_InfrastructureLines_CamRightLineEndViewRange;
CamRightLineQuality=Cam_InfrastructureLines_CamRightLineQuality;
CamRightLineMarkWidth=Cam_InfrastructureLines_CamRightLineMarkWidth;
CamRightLineID=Cam_InfrastructureLines_CamRightLineID;

CamLeftLeftLineStartViewRange=Cam_InfrastructureLines_CamLeftLeftLineStartViewRange;
CamLeftLeftLineEndViewRange=Cam_InfrastructureLines_CamLeftLeftLineEndViewRange;
CamLeftLeftLineQuality=Cam_InfrastructureLines_CamLeftLeftLineQuality;
CamLeftLeftLineMarkWidth=Cam_InfrastructureLines_CamLeftLeftLineMarkWidth;
CamLeftLeftLineID=Cam_InfrastructureLines_CamLeftLeftLineID;

CamRightRightLineStartViewRange=Cam_InfrastructureLines_CamRightRightLineStartViewRange;
CamRightRightLineEndViewRange=Cam_InfrastructureLines_CamRightRightLineEndViewRange;
CamRightRightLineQuality=Cam_InfrastructureLines_CamRightRightLineQuality;
CamRightRightLineMarkWidth=Cam_InfrastructureLines_CamRightRightLineMarkWidth;
CamRightRightLineID=Cam_InfrastructureLines_CamRightRightLineID;

CamHPPLaneWidthEstimation=Cam_InfrastructureInfo_CamHPPLaneWidthEstimation;
CamHPPConfidence=Cam_InfrastructureInfo_CamHPPConfidence; % ??

        %Fusion
    
    %ViewRange left/right
FusionViewRangeLineLeft=ViewRangeLineLeft;
FusionViewRangeLineRight=ViewRangeLineRight;
    %Quality left/right
FusionQualityLineLeft=QualityLineLeft;
FusionQualityLineRight=QualityLineRight;

    %Type left/right
FusionLineTypeLeft=LineTypeLeft;
FusionLineTypeRight=LineTypeRight;
    %


fig1=figure;
ax(1)=subplot(4,2,1);

% plot(ax(1),t,CamLeftLineEndViewRange)
% hold on
plot(ax(1),t,FusionViewRangeLineLeft)
grid on
% legend('CAM','Fusion');
legend('Fusion');
title(ax(1),'ViewRange leftLine')

ax(2)=subplot(4,2,2);
plot(ax(2),t,CamRightLineEndViewRange)
hold on
plot(ax(2),t,FusionViewRangeLineRight)
grid on
legend('CAM','Fusion');
title(ax(2),'ViewRange RightLine')

ax(3)=subplot(4,2,3);
plot(ax(3),t,CamLeftLineQuality)
hold on
plot(ax(3),t,FusionQualityLineLeft)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft','RTright','RTleft');
legend('CAMleft','Fusionleft');
title(ax(3),'Quality left')

ax(4)=subplot(4,2,4);
plot(ax(4),t,CamRightLineQuality)
hold on
plot(ax(4),t,FusionQualityLineRight)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft','RTleft','RTright');
legend('CAMright','Fusionright');
title(ax(4),'Quality right')

ax(5)=subplot(4,2,5);
hold on
plot(ax(5),t,CamLeftLineMarkWidth);
plot(ax(5),t,GT_leftLineWidth);
% hold on
% plot(ax(5),t,FusionLineWidthLeft)
grid on
% legend('CAM','fusion');
legend('CAM','Image Process');
title(ax(5),'Line Width Left')

ax(6)=subplot(4,2,6);
hold on
plot(ax(6),t,CamRightLineMarkWidth);
plot(ax(6),t,GT_rightLineWidth);

% hold on
% plot(ax(6),t,FusionLineWidthRight)
grid on
% legend('CAM','fusion');
legend('CAM','Image Process');
title(ax(6),'Line Width Right')

ax(7)=subplot(4,2,[7,8]);
hold on
plot(ax(7),t,CamHPPLaneWidthEstimation)
plot(ax(7),t,GT_laneWidth);
% hold on
% plot(ax(6),t,FusionLineWidthRight)
grid on
legend('CAM','Image Process');
title(ax(7),'Lane Width')