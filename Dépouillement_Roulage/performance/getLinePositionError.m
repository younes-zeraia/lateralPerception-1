function [positionError steadyError] = getLinePositionError(measuredLinePosition,referenceLinePosition,qualityMeasure,qualityReference)
    t = [0:length(measuredLinePosition)-1]';

    iGoodQuality = find(qualityMeasure>0 & qualityReference>0 & qualityMeasure<=100 & qualityReference<=100 & ~isnan(referenceLinePosition) & ~isnan(measuredLinePosition));
    positionErrorRaw = abs(measuredLinePosition(iGoodQuality))-abs(referenceLinePosition(iGoodQuality));
    steadyError = mean(positionErrorRaw);
%     positionError = positionErrorRaw - steadyError;
    positionError = positionErrorRaw;
    
    positionError = interp1(t(iGoodQuality),positionError,t,'previous');
    positionErrorRaw = interp1(t(iGoodQuality),positionErrorRaw,t,'previous');
    
%     figure;
%     plot(positionErrorRaw);
%     hold on
%     plot([0 length(positionErrorRaw)],[steadyError steadyError],'--k');
    
end

function steadyError = getSteadyError(positionError)
    positionErrorValid = positionError(find(~isnan(positionError)));
    nElems = size(positionError,1);
    % Detect steady state of the curvature during the turn
    diffsNorm = abs(diff(positionErrorValid))./mean(abs(positionErrorValid));
    diffsNorm = neighboorFilt(diffsNorm,100);
    diffsNormThresh = quantile(diffsNorm,3);
    steadyFlag = diffsNorm<diffsNormThresh(1);
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
    steadyError = mean(abs(positionErrorValid(steadyInd)));
    upLimit = steadyError*1.1;
    downLimit = steadyError*0.9;
    meanCurvature = positionErrorValid(find(abs(positionErrorValid)<upLimit & abs(positionErrorValid)>downLimit));
    steadyError = mean(meanCurvature);
end