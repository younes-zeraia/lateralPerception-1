figure;
ax(1) = subplot(3,1,1);
hold on
grid minor
ax(2) = subplot(3,1,2);
hold on
grid minor
ax(3) = subplot(3,1,3);
hold on
grid minor

plot(ax(1),log.Cam_InfrastructureLines_CamLeftLineQuality,'LineWidth',1);
plot(ax(2),log.QualityLineLeft,'LineWidth',1);
plot(ax(3),log.Cam_InfrastructureLines_CamLeftLineCurvature,'LineWidth',1);

linkaxes(ax,'x');

legend(ax(1),'Line Quality FrCam');
legend(ax(2),'Line Quality Fusion');
legend(ax(3),'Line Curvature FrCam (C2)');