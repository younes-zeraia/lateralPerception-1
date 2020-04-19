% Find out if 2 signals are correlated
% If they are correlated, returns the corresponding begin and end indexes
% of each signal (in their own time samples).

% 3 configurations are testes :

% a : The longest  signal begins before and ends after the shortest one
% b : The shortest signal begins before the longest
% c : The shortest signal ends after the longest


% Creation : Mathieu Delannoy - RENAULT 2020
function [correlFound,beginSig1,endSig1,beginSig2,endSig2] = findCorrelation(sig1,sig2,f1,f2,isBoolean)
    correlThreshold = 0.95;
    correlFound = false;
    if nargin <5
        isBoolean = false;
    end

    % We work with vertical arrays
    [n1 m1] = size(sig1);
    if m1>n1
        sig1    = sig1';
        n1      = m1;
    end
    
    % We work with vertical arrays
    [n2 m2] = size(sig2);
    if m2>n2
        sig2    = sig2';
        n2      = m2;
    end
    
    % Signals mays not have the same sample time
    if f1>f2
        t1 = [0:1/f1:(n2-1)/f2]';
        t2 = [0:n2-1]'./f2;
        sig2 = interp1(t2,sig2,t1,'previous');
        n2   = size(sig2,1);
    else
        t1 = [0:n1-1]'./f1;
        t2 = [0:1/f2:(n1-1)/f1]';
        sig1 = interp1(t1,sig1,t2,'previous');
        n1   = size(sig1,1);
    end
    
    
    % Find out which is the shortest and which is the longest signal
    if n1>=n2
        offsetSign = -1; % Remember that shortest signal was sig2 and longest was sig1
        shortSig = sig2;
        longSig  = sig1;
    else
        offsetSign = 1; % Remember that shortest signal was sig1 and longest was sig2
        shortSig = sig1;
        longSig  = sig2;
    end
    nMin = size(shortSig,1);
    nMax = size(longSig,1);
    % We first assume we are in the first configuration (see function description).
    [correlCoef,offset,nShift] = getCorrelLoop(shortSig,longSig,isBoolean);
   
    if correlCoef(1,2)>correlThreshold % The 2 signals match
        correlFound = true;
            
        beginLongSig    = offset;
        endLongSig      = offset + nMin;

        beginShortSig   = 1;
        endShortSig      = nMin-1;
    elseif abs(offset-nShift)<10 % The short signal may have stopped too late
        
        firstHalfShortSig = shortSig(1:round(end/2)); % We extract the first half of the short signal

        % Let's test the second configuration
        [correlCoefNew,offset,nShiftNew] = getCorrelLoop(firstHalfShortSig,longSig,isBoolean);

        if correlCoefNew(1,2)>correlThreshold % The 2 signals match !
            correlFound = true;
            
            beginLongSig    = offset;
            endLongSig      = nMax-1;

            beginShortSig   = 1;
            endShortSig      = nMax-offset;
        end
    elseif offset<10 % The short signal may have began to early
        nHaflShortSig = round(size(secondHalfShortSig,1)/2);
        secondHalfShortSig = shortSig(nHaflShortSig:end); % We extract the second half of the short signal

        % Let's test the third configuration
        [correlCoefNew,offset,nShiftNew] = getCorrelLoop(secondHalfShortSig,longSig,isBoolean)

        if correlCoefNew(1,2)>correlThreshold
            correlFound = true;
            
            beginLongSig    = 1;
            endLongSig      = nMin - nHaflShortSig + offset - 1;

            beginShortSig   = nHaflShortSig - offset +1;
            endShortSig      = nMin-1;
        end
    end
    
    if correlFound
        if offsetSign>0 % shortest signal was sig1 and longest was sig2
            beginSig1   = ceil(  beginShortSig * f1 / max(f1,f2));
            endSig1     = floor( endShortSig   * f1 / max(f1,f2));
            
            beginSig2   = ceil(  beginLongSig  * f2 / max(f1,f2));
            endSig2     = floor( endLongSig    * f2 / max(f1,f2));
        else            % shortest signal was sig2 and longest was sig1
            beginSig2   = ceil(  beginShortSig * f2 / max(f1,f2));
            endSig2     = floor( endShortSig   * f2 / max(f1,f2));
            
            beginSig1   = ceil(  beginLongSig  * f1 / max(f1,f2));
            endSig1     = floor( endLongSig    * f1 / max(f1,f2));
        end
    else % No Match found
            beginSig2   = 0;
            endSig2     = 0;
            
            beginSig1   = 0;
            endSig1     = 0;
        
    end
end
%% FUNCTIONS
function sNorm = normalizeSig(s)
    s = s-nanmean(s);
    sNorm = s/nanmean(abs(s));
end

function [correlCoef,offset,nShift] = getCorrelLoop(shortSig,longSig,isBoolean)
    nMin = size(shortSig,1);
    nMax = size(longSig,1);
    nShift = nMax-nMin;
    corrArray = zeros(nShift,1);
    s2          = shortSig;
    if ~isBoolean
        s2Norm = normalizeSig(s2);
    else
        s2Norm = s2;
    end
    
    for i=1:nShift+1
        s1 = longSig(i:end-(nShift-i)-1);
        if ~isBoolean
            s1Norm = normalizeSig(s1);
        else
            s1Norm = s1;
        end
        corrArray(i) = sqrt(nansum((s1Norm-s2Norm).^2,1));
    end
    [minCorr offset] = min(corrArray);
    s1Offsetted = longSig(offset:end-(nShift-offset)-1);
    if ~isBoolean
        s1Norm = normalizeSig(s1Offsetted);
    else
        s1Norm = s1Offsetted;
    end
    
    indGood = find(~isnan(s1Norm) & ~isnan(s2Norm));
    
    correlCoef = corrcoef(s1Norm(indGood),s2Norm(indGood));
end