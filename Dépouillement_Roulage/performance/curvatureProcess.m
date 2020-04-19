% This function is intended to detect turns according to curvature and identify stabilized curvature for each turn
% It returns some Curvature performance KPI as :
% - Curvature steady value for each turn
% - Curvature steady error compared to a groundTruth for each turn
% - Curvature max overshoot value in each turn (max peak compared to its steady value
% - Curvature max undershoot value in each turn (min off-peak compared to its steady value
% - Curvature std deviation arround its steady value

function curvatureResults = curvatureProcess(curvatureMes_1,curvatureMes_2,curvatureGT,beginR,endR)
    
    inTurn1         = getInTurnFlag(curvatureMes_1,beginR,endR);
    inTurn2         = getInTurnFlag(curvatureMes_2,beginR,endR);
    GTInTurn        = getInTurnFlag(curvatureGT,beginR,endR);
    
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
        curvatureNom1(i)        = getNominalCurvature(curvatureMes_1(iBeginTurn(i):iEndTurn(i)));
        curvatureNom2(i)        = getNominalCurvature(curvatureMes_2(iBeginTurn(i):iEndTurn(i)));
        GTCurvatureNom(i)       = getNominalCurvature(curvatureGT(iBeginTurn(i):iEndTurn(i)));
        
        curvatureError1(i)      = abs(curvatureNom1(i)-GTCurvatureNom(i))./abs(GTCurvatureNom(i));
        curvatureError2(i)      = abs(curvatureNom2(i)-GTCurvatureNom(i))./abs(GTCurvatureNom(i));
        % Calculate position of max Overshoot and max Undershoot of
        % curvature in each turn
        [curvatureOS1 curvatureUS1]         = getCurvatureOvershoot(curvatureMes_1(iBeginTurn(i):iEndTurn(i)),curvatureNom1(i));
        [curvatureOS2 curvatureUS2]         = getCurvatureOvershoot(curvatureMes_2(iBeginTurn(i):iEndTurn(i)),curvatureNom2(i));
        [GTCurvatureOS GTCurvatureUS]       = getCurvatureOvershoot(curvatureGT(iBeginTurn(i):iEndTurn(i)),GTCurvatureNom(i));
        
        % Deduce Overshoot value
        curvatureOvershoot1(i) = abs((curvatureMes_1(curvatureOS1+iBeginTurn(i))-curvatureNom1(i))/curvatureNom1(i));
        curvatureOvershoot2(i) = abs((curvatureMes_2(curvatureOS2+iBeginTurn(i))-curvatureNom2(i))/curvatureNom2(i));
        
        % Deduce Undershoot value
        curvatureUndershoot1(i) = -abs((curvatureMes_1(curvatureUS1+iBeginTurn(i))-curvatureNom1(i))/curvatureNom1(i));
        curvatureUndershoot2(i) = -abs((curvatureMes_2(curvatureUS2+iBeginTurn(i))-curvatureNom2(i))/curvatureNom2(i));
        
        
        curvatureStd1(i)        = getCurvatureStd(curvatureMes_1(iBeginTurn(i):iEndTurn(i)),curvatureNom1(i));
        curvatureStd2(i)        = getCurvatureStd(curvatureMes_2(iBeginTurn(i):iEndTurn(i)),curvatureNom2(i));
        GTCurvatureStd(i)       = getCurvatureStd(curvatureGT(iBeginTurn(i):iEndTurn(i)),GTCurvatureNom(i));
        
    end
    curvatureResults.curvatureNom1         = curvatureNom1;
    curvatureResults.curvatureNom2         = curvatureNom2;
    curvatureResults.GTCurvatureNom        = GTCurvatureNom;
    
    curvatureResults.curvatureError1       = curvatureError1;
    curvatureResults.curvatureError2       = curvatureError2;
    curvatureResults.curvatureOvershoot1   = curvatureOvershoot1;
    curvatureResults.curvatureOvershoot2   = curvatureOvershoot2;
    curvatureResults.curvatureUndershoot1  = curvatureUndershoot1;
    curvatureResults.curvatureUndershoot2  = curvatureUndershoot2;
    curvatureResults.InTurnFlag            = inTurn;
    
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
end

function curvatureStd = getCurvatureStd(curvature,nominalCurvature)
    upLimit = nominalCurvature*1.05;
    downLimit = nominalCurvature*0.95;
    
    steadyCurvature = curvature(find(curvature<upLimit & curvature>downLimit));
    nElem = size(steadyCurvature,1);
    curvatureStd = sqrt(sum((steadyCurvature-mean(steadyCurvature)).^2,1)/size(steadyCurvature,1))/mean(steadyCurvature);
end