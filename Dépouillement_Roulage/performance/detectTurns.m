% This function detect turns according to curvature and identify stabilized
% curvature for each turn
function turns = detectTurns(curvature_1,curvature_2,GTCurvature,beginR,endR)
    
    inTurn1         = getInTurnFlag(curvature_1,beginR,endR);
    inTurn2         = getInTurnFlag(curvature_2,beginR,endR);
    GTInTurn        = getInTurnFlag(GTCurvature,beginR,endR);
    
    inTurn = getFusedFlag([inTurn1,inTurn2,GTInTurn]);
    iBeginTurn   = find(diff(inTurn)==1);
    iEndTurn     = find(diff(inTurn)==-1);
    if size(iBeginTurn,1)~=size(iEndTurn,1)
        if iEndTurn(1)<iBeginTurn(1)
            iEndTurn = iEndTurn(2:end);
        elseif iEndTurn(end)<iBeginTurn(end)
            iBeginTurn = iBeginTurn(1:end-1);
        end
    end
%     figure;
%     ax(1) = subplot(3,1,1);
%     hold on
%     grid minor
%     plot(ax(1),CamCurvature);
%     
%     ax(2) = subplot(3,1,2);
%     hold on
%     grid minor
%     plot(ax(2),FusionCurvature);
%     
%     ax(3) = subplot(3,1,3);
%     hold on
%     grid minor
%     plot(ax(3),GTCurvature);
%     
%     linkaxes(ax,'x');
    
    nTurns = size(iBeginTurn,1);
    curvatureNom1               = zeros(nTurns,1);
    curvatureNom2               = zeros(nTurns,1);
    GTCurvatureNom              = zeros(nTurns,1);
    curvatureOvershoot1         = zeros(nTurns,1);
    curvatureOvershoot2         = zeros(nTurns,1);
    curvatureUndershoot1        = zeros(nTurns,1);
    curvatureUndershoot2        = zeros(nTurns,1);
    curvatureError1             = zeros(nTurns,1);
    curvatureError2             = zeros(nTurns,1);
    
    for i=1:nTurns
        
        % Calculate Nominal Curvature of each turn
        curvatureNom1(i)        = getNominalCurvature(curvature_1(iBeginTurn(i):iEndTurn(i)));
        curvatureNom2(i)        = getNominalCurvature(curvature_2(iBeginTurn(i):iEndTurn(i)));
        GTCurvatureNom(i)       = getNominalCurvature(GTCurvature(iBeginTurn(i):iEndTurn(i)));
        
        curvatureError1(i)      = abs(curvatureNom1(i)-GTCurvatureNom(i))./abs(GTCurvatureNom(i));
        curvatureError2(i)      = abs(curvatureNom2(i)-GTCurvatureNom(i))./abs(GTCurvatureNom(i));
        % Calculate position of max Overshoot and max Undershoot of
        % curvature in each turn
        [curvatureOS1 curvatureUS1]         = getCurvatureOvershoot(curvature_1(iBeginTurn(i):iEndTurn(i)),curvatureNom1(i));
        [curvatureOS2 curvatureUS2]         = getCurvatureOvershoot(curvature_2(iBeginTurn(i):iEndTurn(i)),curvatureNom2(i));
        [GTCurvatureOS GTCurvatureUS]       = getCurvatureOvershoot(GTCurvature(iBeginTurn(i):iEndTurn(i)),GTCurvatureNom(i));
        
        
        % Deduce Overshoot value
        curvatureOvershoot1(i) = abs((curvature_1(curvatureOS1+iBeginTurn(i))-curvatureNom1(i))/curvatureNom1(i));
        curvatureOvershoot2(i) = abs((curvature_2(curvatureOS2+iBeginTurn(i))-curvatureNom2(i))/curvatureNom2(i));
        
        % Deduce Undershoot value
        curvatureUndershoot1(i) = -abs((curvature_1(curvatureUS1+iBeginTurn(i))-curvatureNom1(i))/curvatureNom1(i));
        curvatureUndershoot2(i) = -abs((curvature_2(curvatureUS2+iBeginTurn(i))-curvatureNom2(i))/curvatureNom2(i));
        
        
        curvatureStd1(i)        = getCurvatureStd(curvature_1(iBeginTurn(i):iEndTurn(i)),curvatureNom1(i));
        curvatureStd2(i)        = getCurvatureStd(curvature_2(iBeginTurn(i):iEndTurn(i)),curvatureNom2(i));
        GTCurvatureStd(i)       = getCurvatureStd(GTCurvature(iBeginTurn(i):iEndTurn(i)),GTCurvatureNom(i));
        
        % Plot results
%         plot(ax(1),[iBeginTurn(i) iEndTurn(i)],[CamCurvatureNom(i) CamCurvatureNom(i)],'k--','LineWidth',1);
%         plot(ax(2),[iBeginTurn(i) iEndTurn(i)],[FusionCurvatureNom(i) FusionCurvatureNom(i)],'k--','LineWidth',1);
%         plot(ax(3),[iBeginTurn(i) iEndTurn(i)],[GTCurvatureNom(i) GTCurvatureNom(i)],'k--','LineWidth',1);
%         
%         text(ax(1),iEndTurn(i),CamCurvatureNom(i),strcat('\leftarrow Error : ',num2str(CamCurvatureError(i)*100),'%'));
%         text(ax(2),iEndTurn(i),FusionCurvatureNom(i),strcat('\leftarrow Error : ',num2str(FusionCurvatureError(i)*100),'%'));
%         
%         quiver(ax(1),CamCurvatureOS+iBeginTurn(i),CamCurvatureNom(i),0,CamCurvature(CamCurvatureOS+iBeginTurn(i))-CamCurvatureNom(i),'r');
%         quiver(ax(2),FusionCurvatureOS+iBeginTurn(i),FusionCurvatureNom(i),0,FusionCurvature(FusionCurvatureOS+iBeginTurn(i))-FusionCurvatureNom(i),'r');
%         quiver(ax(3),GTCurvatureOS+iBeginTurn(i),GTCurvatureNom(i),0,GTCurvature(GTCurvatureOS+iBeginTurn(i))-GTCurvatureNom(i),'r');
%         
%         quiver(ax(1),CamCurvatureUS+iBeginTurn(i),CamCurvatureNom(i),0,CamCurvature(CamCurvatureUS+iBeginTurn(i))-CamCurvatureNom(i),'r');
%         quiver(ax(2),FusionCurvatureUS+iBeginTurn(i),FusionCurvatureNom(i),0,FusionCurvature(FusionCurvatureUS+iBeginTurn(i))-FusionCurvatureNom(i),'r');
%         quiver(ax(3),GTCurvatureUS+iBeginTurn(i),GTCurvatureNom(i),0,GTCurvature(GTCurvatureUS+iBeginTurn(i))-GTCurvatureNom(i),'r');
    end
    turns.curvatureNom1         = curvatureNom1;
    turns.curvatureNom2         = curvatureNom2;
    turns.GTCurvatureNom        = GTCurvatureNom;
    
    turns.curvatureError1       = curvatureError1;
    turns.curvatureError2       = curvatureError2;
    turns.curvatureOvershoot1   = curvatureOvershoot1;
    turns.curvatureOvershoot2   = curvatureOvershoot2;
    turns.curvatureUndershoot1  = curvatureUndershoot1;
    turns.curvatureUndershoot2  = curvatureUndershoot2;
    turns.InTurnFlag            = inTurn;
    
    
%     title(ax(1),['FrCam Curvature (C2) - Mean Error : ' num2str(mean(turns.CamError)*100) '%'...   
%                  '- Mean Overshoot : ' num2str(mean(turns.CamOvershoot)*100) '%'...
%                  '- Mean Undershoot : ' num2str(mean(turns.CamUndershoot)*100) '%']);
%     title(ax(2),['Fusion Curvature (C2) - Mean Error : ' num2str(mean(turns.FusionError)*100) '%'... 
%                  '- Mean Overshoot : ' num2str(mean(turns.FusionOvershoot)*100) '%'...
%                  '- Mean Undershoot : ' num2str(mean(turns.FusionUndershoot)*100) '%']);
%     title(ax(3),'Ground Truth Curvature (C2)');
end

function inTurn = getInTurnFlag(curvature,beginR,endR)
    nElems = length(curvature);
    inTurn = zeros(nElems,1);
    for i = 2:nElems
        if inTurn(i-1) == 0 
            if abs(curvature(i))> 1/beginR
                inTurn(i) = 1;
            end
        else
            if abs(curvature(i)) > 1/endR
                inTurn(i) = 1;
            end
        end
    end
end

function fusedFlag = getFusedFlag(flags)
    nFlags = size(flags,2);
    nElems = size(flags,1);
    fusedFlag = zeros(nElems,1);
    for i=2:nElems
        if fusedFlag(i-1) == 0
            if all(flags(i,:))
                fusedFlag(i) = 1;
            end
        else
            if ~all(~flags(i,:))
                fusedFlag(i) = 1;
            end
        end
    end
end

function nominalCurvature = getNominalCurvature(curvature)
    curvature = curvature(find(~isnan(curvature)));
    curvature = neighboorFilt(curvature,200);
    nElems = size(curvature,1);
    % Detect steady state of the curvature during the turn
    diffsNorm = abs(diff(curvature))./mean(abs(curvature));
%     diffsNorm = neighboorFilt(diffsNorm,200);
    diffsNormThresh = quantile(diffsNorm,5);
    steadyFlag = diffsNorm<diffsNormThresh(4);
    steadyFlag(1) = 0;
    steadyFlag(end) = 0;
    iRiseSteady = find(diff(steadyFlag)==1);
    iFallSteady = find(diff(steadyFlag)==-1);
%     if iFallSteady(1)<iRiseSteady(1)
%         iFallSteady = iFallSteady(2:end);
%     end
%     if iFallSteady(end)<iRiseSteady(end)
%         iRiseSteady = iRiseSteady(1:end-1);
%     end
    [maxSteadyDuration indISteady] = max(iFallSteady-iRiseSteady);
    steadyInd = [iRiseSteady(indISteady):iFallSteady(indISteady)];
    steadyCurvature = mean(abs(curvature(steadyInd)));
    upLimit = steadyCurvature*1.1;
    downLimit = steadyCurvature*0.9;
    meanCurvature = curvature(find(abs(curvature)<upLimit & abs(curvature)>downLimit));
    nominalCurvature = mean(meanCurvature);
    offsettedCurvature = meanCurvature - nominalCurvature;
    iRiseOffsetCurv    = find(offsettedCurvature>0,1,'first');
    iFallOffsetCurv    = find(offsettedCurvature>0,1,'last');
    offsettedCurvature = offsettedCurvature(iRiseOffsetCurv:iFallOffsetCurv);
end

function [iOvershoot iUnderShoot] = getCurvatureOvershoot(curvature,nominalCurvature)
    deltaCurv = abs(curvature) -  abs(nominalCurvature);
    deltaCurvPositive = deltaCurv>0;
    deltaCurvPositive(1) = 0;
    deltaCurvPositive(end) = 0;
    iRiseDeltaPositive = find(diff(deltaCurvPositive)==1);
    iFallDeltaPositive = find(diff(deltaCurvPositive)==-1);
     
    [overshoot iOvershoot] = max(deltaCurv(iRiseDeltaPositive(1):iFallDeltaPositive(end)));
    [undershoot iUnderShoot] = min(deltaCurv(iRiseDeltaPositive(1):iFallDeltaPositive(end)));
    iOvershoot = iOvershoot + iRiseDeltaPositive(1);
    iUnderShoot= iUnderShoot+ iRiseDeltaPositive(1);
    %     [entranceOvershoot iEntranceOvershoot] = max(deltaCurv(iRiseDeltaPositive(1):iFallDeltaPositive(1)));
%     iEntranceOvershoot = iEntranceOvershoot + iRiseDeltaPositive(1) - 1;
    
%     [exitOvershoot iUnderShoot] = max(deltaCurv(iRiseDeltaPositive(end):iFallDeltaPositive(end)));
%     iUnderShoot = iUnderShoot + iRiseDeltaPositive(end) - 1;
end

function curvatureStd = getCurvatureStd(curvature,nominalCurvature)
    upLimit = nominalCurvature*1.05;
    downLimit = nominalCurvature*0.95;
    
    steadyCurvature = curvature(find(curvature<upLimit & curvature>downLimit));
    nElem = size(steadyCurvature,1);
    curvatureStd = sqrt(sum((steadyCurvature-mean(steadyCurvature)).^2,1)/size(steadyCurvature,1))/mean(steadyCurvature);
end