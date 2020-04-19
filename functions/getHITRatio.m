% This function computes the Hit ratio of a measured signal
% given its GroundTruth signal.
%
%       (n_Samples_Measure == 1 AND n_Samples_GroundTruth == 1)
% HIT% = -------------------------------------------------------
%                    n_Samples_GroundTruth == 1

function HITRatio = getHITRatio(measureFlag,GroundTruthFlag)
    %% Format check
    % Have to be vertical vectors
    [n1 m1] = size(measureFlag);
    [n2 m2] = size(GroundTruthFlag);
    if m1>n1
        measureFlag = measureFlag'; % the array must be vertical
    end
    if m2>n2
        GroundTruthFlag     = GroundTruthFlag'; % the array must be vertical
    end

    if size(measureFlag,2)>1 | size(GroundTruthFlag,2)>1
        error('Has to be vectors of size = [n*1]');
    end

    if size(measureFlag,1)~=size(GroundTruthFlag,1)
        error('Vectors has to be of the same size');
    end

    % Have to be booleans
    if any(measureFlag~=1 & measureFlag~=0)
        error('Vector should only be composed of booleans !');
    elseif any(GroundTruthFlag~=1 & GroundTruthFlag~=0)
        error('Vector should only be composed of booleans !');
    end


    %% Process
    HITRatio = sum(measureFlag & GroundTruthFlag,1)/sum(GroundTruthFlag,1);
end