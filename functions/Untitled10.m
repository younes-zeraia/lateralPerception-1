figure;
ax(1) = subplot(4,1,1);
hold on
grid minor
ax(2) = subplot(4,1,2);
hold on
grid minor
ax(3) = subplot(4,1,3);
hold on
grid minor
ax(4) = subplot(4,1,4);
hold on
grid minor

plot(ax(1),log.Cam_InfrastructureLines_CamRightLineOffset);
plot(ax(1),log.PositionLineRight);

plot(ax(2),log.PositionLineRight-log.Cam_InfrastructureLines_CamRightLineOffset);

plot(ax(3),log.Cam_InfrastructureLines_CamRightLineQuality);
plot(ax(4),log.QualityLineRight);

linkaxes(ax,'x');
