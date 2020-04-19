function [risingDelayQuality0 fallingDelayQuality0]  = getDelayQuality0(CamQuality,FusionQuality,time)
    
    CamQuality0     = CamQuality == 0;
    FusionQuality0  = FusionQuality == 0;

    CamQuality0(1)      = 0;
    CamQuality0(end)    = 0;

    FusionQuality0(1)   = 0;
    FusionQuality0(end) = 0;
    
    iRiseCamQuality0 = find(diff(CamQuality0)==1);
    iFallCamQuality0 = find(diff(CamQuality0)==-1);

    iRiseFusionQuality0 = find(diff(FusionQuality0)==1);
    iFallFusionQuality0 = find(diff(FusionQuality0)==-1);

    nQuality0 = size(iRiseCamQuality0,1);

    risingDelayQuality0 = zeros(nQuality0,1);
    fallingDelayQuality0= zeros(nQuality0,1);
    
    countFusion = 1;
    
    for countCam=1:nQuality0
        fusionQuality0Raised = false;
        if countCam<nQuality0 && countFusion<=size(iRiseFusionQuality0,1)
            
            if time(iRiseFusionQuality0(countFusion)) > time(iRiseCamQuality0(countCam)) &&...
                time(iRiseFusionQuality0(countFusion)) < time(iRiseCamQuality0(countCam+1))
                
                fusionQuality0Raised = true;
            end
            
        elseif countFusion<=size(iRiseFusionQuality0,1)
                
                fusionQuality0Raised = true;
        end
        
        if fusionQuality0Raised
            
            risingDelayQuality0(countFusion) = time(iRiseFusionQuality0(countFusion)) - time(iRiseCamQuality0(countCam));
            fallingDelayQuality0(countFusion)= time(iFallFusionQuality0(countFusion)) - time(iFallCamQuality0(countCam));
            countFusion = countFusion+1;
        end
        
    end
    
    risingDelayQuality0 = risingDelayQuality0(1:countFusion-1);
    fallingDelayQuality0= fallingDelayQuality0(1:countFusion-1);
    
end