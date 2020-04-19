lines = load(fullfile(testPath,logsConvFolderName,'Image_processing',canapeFileName));
canape= load(fullfile(testPath,logsRawFolderName,'canape',canapeFileName));

tVid = [0:length(lines.yLeftExt)-1]/30;
tCan = [0:length(canape.Cam_InfrastructureInfo_CamDistToCrossRoad)-1]'/100;


%%
imProcess_LeftLineOffset = interp1(tVid,lines.yLeftInt,tCan)./1000+VehWidth/2+0.11;
imProcess_RightLineOffset= interp1(tVid,lines.yRightInt,tCan)./1000-VehWidth/2+0.11;
ax(1) = subplot(2,2,1);
hold on
grid minor
plot(tCan,canape.Cam_InfrastructureLines_CamLeftLineOffset,'LineWidth',1);
plot(tCan,imProcess_LeftLineOffset,'LineWidth',1);
plot(tCan,canape.PositionLineLeft,'LineWidth',1);
title('Left Line');
ylabel('Line Position (C0) - m');
legend('FrCam','Image Processing','Fusion');
ylim([0 3]);

% plot(tCan,-canape.Line1PosLateralA);

ax(2) = subplot(2,2,2);
title('Right Line');
hold on
grid minor
plot(tCan,canape.Cam_InfrastructureLines_CamRightLineOffset,'LineWidth',1);
plot(tCan,imProcess_RightLineOffset,'LineWidth',1);
plot(tCan,canape.PositionLineRight,'LineWidth',1);
legend('FrCam','Image Processing','Fusion');
ylim([-3 0]);



FrCam_LeftLineOffset_err = canape.Cam_InfrastructureLines_CamLeftLineOffset - imProcess_LeftLineOffset;
Fusion_LeftLineOffset_err= canape.PositionLineLeft - imProcess_LeftLineOffset;
FrCam_LeftLineOffset_errFilt = filterNoDelay(FrCam_LeftLineOffset_err,100);
Fusion_LeftLineOffset_errFilt = filterNoDelay(Fusion_LeftLineOffset_err,100);

FrCam_RightLineOffset_err = canape.Cam_InfrastructureLines_CamRightLineOffset - imProcess_RightLineOffset;
Fusion_RightLineOffset_err= canape.PositionLineRight - imProcess_RightLineOffset;
FrCam_RightLineOffset_errFilt = filterNoDelay(FrCam_RightLineOffset_err,100);
Fusion_RightLineOffset_errFilt = filterNoDelay(Fusion_RightLineOffset_err,100);
tCanFilt = tCan(1:length(FrCam_LeftLineOffset_errFilt));


ax(3) = subplot(2,2,3);
hold on
grid minor
plot(tCanFilt,FrCam_LeftLineOffset_errFilt);
plot(tCanFilt,Fusion_LeftLineOffset_errFilt);
ylim([-0.3 0.3]);
legend('FrCam','Fusion');
ylabel('Line Position Error (from Image Process Ground Truth) m');

ax(4) = subplot(2,2,4);
hold on
grid minor
plot(tCanFilt,FrCam_RightLineOffset_errFilt);
plot(tCanFilt,Fusion_RightLineOffset_errFilt);
ylim([-0.3 0.3]);
legend('FrCam','Fusion');
xlabel('Time (s)');

linkaxes(ax,'x');
plot(tCan,-canape.Line2PosLateralA);

plot(tCan,abs(canape.Cam_InfrastructureLines_CamLeftLineOffset-canape.PositionLineLeft))

leftLinePos_error = filterNoDelay(abs(canape.Cam_InfrastructureLines_CamLeftLineOffset-canape.PositionLineLeft),20);

plot(tCan(1:length(leftLinePos_error)),leftLinePos_error)

%% Analyse Fourrier 
n = length(tCan);
fs = 100;
f = (-n/2:n/2-1)*(fs/n);    % frequency range
FrCam_LeftLineOffset_fft = fftshift(canape.Cam_InfrastructureLines_CamLeftLineOffset);
Fusion_LeftLineOffset_fft= fftshift(canape.PositionLineLeft);


FrCam_LeftLineOffset_power = abs(FrCam_LeftLineOffset_fft).^2/n;    % power of the DFT
Fusion_LeftLineOffset_power= abs(Fusion_LeftLineOffset_fft).^2/n;    % power of the DFT

figure;
plot(f,FrCam_LeftLineOffset_power);
hold on
plot(f,Fusion_LeftLineOffset_power);
legend('FrCam','Fusion');
title('Spectre fréquentiel des signaux');
ylabel('Puissance');
xlabel('Frequence (Hz)');
