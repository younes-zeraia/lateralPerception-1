figure;
ax(1) = subplot(5,1,1);
hold on
ax(2) = subplot(5,1,2);
hold on
ax(3) = subplot(5,1,3);
hold on
ax(4) = subplot(5,1,4);
hold on
ax(5) = subplot(5,1,5);
hold on

plot(ax(1),log.Cam_InfrastructureLines_CamLeftLineOffset,'LineWidth',1);
plot(ax(1),log.Cam_InfrastructureLines_CamLeftLeftLineOffset,'LineWidth',1);

plot(ax(2),log.Cam_InfrastructureLines_CamLeftLineYawAngle,'LineWidth',1);
plot(ax(2),log.Cam_InfrastructureLines_CamLeftLeftLineYawAngle,'LineWidth',1);

plot(ax(3),log.Cam_InfrastructureLines_CamLeftLineCurvature,'LineWidth',1);
plot(ax(3),log.Cam_InfrastructureLines_CamLeftLeftLineCurvature,'LineWidth',1);

plot(ax(4),log.Cam_InfrastructureLines_CamLeftLineCurvatureRate,'LineWidth',1);
plot(ax(4),log.Cam_InfrastructureLines_CamLeftLeftLineCurvatureRate,'LineWidth',1);

plot(ax(5),log.Cam_InfrastructureLines_CamLeftLineQuality,'LineWidth',1);

linkaxes(ax,'x');

title(ax(1),'Line Offset (m)');
title(ax(2),'Line Yaw Angle (rad)');
title(ax(3),'Line Curvature (C2)');
title(ax(4),'Line Curvature Rate (C3)');
title(ax(5),'Line Quality (x)');

legend(ax(1),'FrCam Left Line','FrCam Left Left Line');
legend(ax(5),'FrCam Left Line Quality');