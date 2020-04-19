%charger fichier acquis dans le wk         
% NomDateEssai = uigetdir('M:\1_Essais_FrCam\');
clear
clc
cd('C:\Users\p102581\Alliance\Métier Prestation Perception Latérale - Depouillement_Eval_FrCam_Fusion\Dépouillement_Roulage\fct');
directory_fct='C:\Users\p102581\Alliance\Métier Prestation Perception Latérale - Depouillement_Eval_FrCam_Fusion\Dépouillement_Roulage\fct';
startPath='M:\1_Essais_FrCam';
CheminEssai = uigetdir(startPath,'cliquer sur le roulage à post-traiter');
[startPath,NomEssai] = fileparts(CheminEssai);
path = strcat(CheminEssai,'\logsRaw\canape');
N = fileSearch2(path, '*.mat');
if isempty(N)
    fprintf('No .mat in file\n');
return
end
if length(N)>=1
%     pref_value=uigetpref('Je vois plusieurs acquis !','concaténer les acquis ?')
    concatenation_acquis_2(path,directory_fct);
    G = fileSearch2(path, '*_total.mat');
    matFile1 = fullfile(G(1).path, G(1).name);
    load(matFile1);
else
    matFile2 = fullfile(N(1).path, N(1).name);
    load(matFile2);
    var = whos( '-file', matFile2 );
end
% cd(folder_name)
% path = path(NomDateEssai,'logsRaw');
cd(path)
% polynomeLines
    %Cam  
%left
CamLeftLineOffset=Cam_InfrastructureLines_CamLeftLineOffset;
CamLeftLineYawAngle=Cam_InfrastructureLines_CamLeftLineYawAngle;
CamLeftLineCurvature=Cam_InfrastructureLines_CamLeftLineCurvature;
CamLeftLineCurvatureRate=Cam_InfrastructureLines_CamLeftLineCurvatureRate;
%right
CamRightLineOffset=Cam_InfrastructureLines_CamRightLineOffset;
CamRightLineYawAngle=Cam_InfrastructureLines_CamRightLineYawAngle;
CamRightLineCurvature=Cam_InfrastructureLines_CamRightLineCurvature;
CamRightLineCurvatureRate=Cam_InfrastructureLines_CamRightLineCurvatureRate;

    %fusion
%left
FusionLeftLineOffset=PositionLineLeft;
FusionLeftLineYawAngle=LeftLineYawAngle;
FusionLeftLineCurvature=CurvatureLineLeft;
FusionLeftLineCurvatureRate=CurvatureDerivativeLineLeft;
%right
FusionRightLineOffset=PositionLineRight;
FusionRightLineYawAngle=RightLineYawAngle;
FusionRightLineCurvature=CurvatureLineRight;
FusionRightLineCurvatureRate=CurvatureDerivativeLineRight;

    %RT
%left
RTLeftLineOffset=abs(Line1PosLateralA);
RTLeftLineYawAngle = LeftLineHeadingOfA;
RTLeftLineCurvature = Line1Curvature;
%
%right
RTRightLineOffset=-Line2PosLateralA;
RTLeftLineYawAngle=RightLineHeadingOfA;
RTRightLineCurvature= Line2Curvature;
%
%%
fig1=figure;
ax(1)=subplot(4,2,1);

plot(ax(1),t,CamLeftLineOffset);
hold on
% plot(ax(1),t,FusionLeftLineOffset);
% plot(ax(1),t,Line1PosLateralAabs);
plot(ax(1),t,GT_leftLineOffset);
grid on
ylim([-0.5 4]);
% legend('CAM','Fusion','Image Process');
legend('CAM','GT');
title(ax(1),'C0 left')

ax(2)=subplot(4,2,2);
plot(ax(2),t,CamRightLineOffset);
hold on
% plot(ax(2),t,FusionRightLineOffset);
% plot(ax(2),t,Line2PosLateralAneg);
plot(ax(2),t,GT_rightLineOffset);
grid on
ylim([-4 0.5]);
% legend('CAM','Fusion','Image Process');
legend('CAM','GT');
title(ax(2),'C0 right')

ax(3)=subplot(4,2,[3,4]);
plot(ax(3),t,CamRightLineYawAngle)
hold on
% plot(ax(3),t,FusionRightLineYawAngle)
plot(ax(3),t,CamLeftLineYawAngle)
% plot(ax(3),t,FusionLeftLineYawAngle)
plot(ax(3),t,GT_leftLineYawAngle./(180*pi));
plot(ax(3),t,GT_rightLineYawAngle./(180*pi));
% hold on
% plot(ax(3),t,RightLineHeadingOfA)
% hold on
% plot(ax(3),t,LeftLineHeadingOfA)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft','RTright','RTleft');
legend('CAMright','CAMleft','GTleft','GTright');
title(ax(3),'C1 right/left')

ax(4)=subplot(4,2,[5,6]);
plot(ax(4),t,CamRightLineCurvature)
hold on
% plot(ax(4),t,FusionRightLineCurvature)
plot(ax(4),t,CamLeftLineCurvature)
% plot(ax(4),t,FusionLeftLineCurvature)
plot(ax(4),t,GT_leftLineCurvature);
plot(ax(4),t,GT_rightLineCurvature);
% hold on
% plot(ax(4),t,Line1Curvature)
% hold on
% plot(ax(4),t,Line2Curvature)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft','RTleft','RTright');
legend('CAMright','CAMleft','GTleft','GTright');
title(ax(4),'C2 right/left')

ax(5)=subplot(4,2,[7,8]);
plot(ax(5),t,CamRightLineCurvatureRate)
% hold on
% plot(ax(5),t,FusionRightLineCurvatureRate)
hold on
plot(ax(5),t,CamLeftLineCurvatureRate)
plot(ax(5),t,GT_leftLineDerivativeCurvature);
plot(ax(5),t,GT_rightLineDerivativeCurvature);
% hold on
% plot(ax(5),t,FusionLeftLineCurvatureRate)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft');
legend('CAMright','CAMleft');
title(ax(5),'C3 right/left')

            
%% CenterLines
   %CAM
CamHPPOffset=Cam_InfrastructureInfo_CamHPPOffset;
CamHPPYawAngle=Cam_InfrastructureInfo_CamHPPYawAngle;
CamHPPCurvature=Cam_InfrastructureInfo_CamHPPCurvature;
CamHPPCurvatureRate=Cam_InfrastructureInfo_CamHPPdCurvature;
  %FUSION
%FusionHPPOffset=CenterLineOffset;
%FusionHPPYawAngle=CenterLineYawAngle;
%FusionHPPCurvature=CenterLineCurvature;
%FusionHPPCurvatureRate=CenterLineCurvatureRate;
fig2=figure;
ax(1)=subplot(4,1,1);

plot(ax(1),t,CamHPPOffset)
hold on
% plot(ax(1),t,FusionHPPOffset)
grid on
legend('CAM');
title(ax(1),'C0 Center line')

ax(2)=subplot(4,1,2);
plot(ax(2),t,CamHPPYawAngle)
hold on
% plot(ax(2),t,FusionHPPYawAngle)
grid on
legend('CAM');
title(ax(2),'C1 Center line')

ax(3)=subplot(4,1,3);
plot(ax(3),t,CamHPPCurvature)
hold on
% plot(ax(3),t,FusionHPPCurvature)
% hold on
% plot(ax(4),t,Line1Curvature)
% hold on
% plot(ax(4),t,Line2Curvature)
grid on
legend('CAM');
title(ax(3),'C2 right/left')

ax(4)=subplot(4,1,4);
plot(ax(4),t,CamHPPCurvatureRate)
% hold on
% plot(ax(5),t,FusionRightLineCurvatureRate)
hold on
% plot(ax(4),t,FusionHPPCurvatureRate)
% hold on
% plot(ax(5),t,FusionLeftLineCurvatureRate)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft');
legend('CAM');
title(ax(4),'C3 right/left')

%% Nextlines
    %CAM
%left
CamNextLeftLineOffset=Cam_InfrastructureLines_CamLeftLeftLineOffset;
CamNextLeftLineYawAngle=Cam_InfrastructureLines_CamLeftLeftLineYawAngle;
CamNextLeftLineCurvature=Cam_InfrastructureLines_CamLeftLeftLineCurvature;
CamNextLeftLineCurvatureRate=Cam_InfrastructureLines_CamLeftLeftLineCurvatureRate;
%right
CamNextRightLineOffset=Cam_InfrastructureLines_CamRightRightLineOffset;
CamNextRightLineYawAngle=Cam_InfrastructureLines_CamRightRightLineYawAngle;
CamNextRightLineCurvature=Cam_InfrastructureLines_CamRightRightLineCurvature;
CamNextRightLineCurvatureRate=Cam_InfrastructureLines_CamRightRightLineCurvatureRate;

    %fusion
%left
%
%
%
%
%right
%
%
%
% 
    %RT
%left
%
%
%
%?
%right
%
%
%
%?     

fig2=figure;
ax(1)=subplot(4,2,1);

plot(ax(1),t,CamLeftLeftLineOffset)
hold on
plot(ax(1),t,FusionLeftLeftLineOffset)
hold on
plot(ax(1),t,Line3PosLateralAabs)
grid on
legend('CAM','Fusion','RT');
title(ax(1),'C0 left')

ax(2)=subplot(4,2,2);
plot(ax(2),t,CamRightRightLineOffset)
hold on
plot(ax(2),t,FusionRightRightLineOffset)
hold on
plot(ax(2),t,Line4PosLateralAneg)
grid on
legend('CAM','Fusion','RT');
title(ax(2),'C0 right')

ax(3)=subplot(4,2,[3,4]);
plot(ax(3),t,CamRightRightLineYawAngle)
hold on
plot(ax(3),t,FusionRightRightLineYawAngle)
hold on
plot(ax(3),t,CamLeftLeftLineYawAngle)
hold on
plot(ax(3),t,FusionLeftLeftLineYawAngle)
% hold on
% plot(ax(3),t,RightLineHeadingOfA)
% hold on
% plot(ax(3),t,LeftLineHeadingOfA)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft','RTright','RTleft');
legend('CAMright','Fusionright','CAMleft','Fusionleft');
title(ax(3),'C1 right/left')

ax(4)=subplot(4,2,[5,6]);
plot(ax(4),t,CamRightRightLineCurvature)
hold on
plot(ax(4),t,FusionRightRightLineCurvature)
hold on
plot(ax(4),t,CamLeftLeftLineCurvature)
hold on
plot(ax(4),t,FusionLeftLeftLineCurvature)
% hold on
% plot(ax(4),t,Line1Curvature)
% hold on
% plot(ax(4),t,Line2Curvature)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft','RTleft','RTright');
legend('CAMright','Fusionright','CAMleft','Fusionleft');
title(ax(4),'C2 right/left')

ax(5)=subplot(4,2,[7,8]);
plot(ax(5),t,CamRightRightLineCurvatureRate)
% hold on
% plot(ax(5),t,FusionRightRightLineCurvatureRate)
hold on
plot(ax(5),t,CamLeftLeftLineCurvatureRate)
% hold on
% plot(ax(5),t,FusionLeftLeftLineCurvatureRate)
grid on
% legend('CAMright','Fusionright','CAMleft','Fusionleft');
legend('CAMright','CAMleft');
title(ax(5),'C3 right/left')

