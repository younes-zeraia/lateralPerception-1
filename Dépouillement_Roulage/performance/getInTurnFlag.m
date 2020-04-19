% this function returns a flag set to 1 when the curvature exceed the 1st
% threshold 1/beginR until it decrease below the 2nd Threshold 1/endR
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
