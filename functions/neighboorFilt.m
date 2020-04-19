function yFilt = neighboorFilt(y,nNeighboor)
%     if nNeighboor*2+1>size(y)
%         error('Signal too short given the neighboor number specified');
%     end
    
    n = size(y,1);
    yFilt = zeros(n,1);
    for i=1:n
        nPrevious   = i-1;
        nNext       = n-i;
        if nPrevious > nNeighboor
            nPrevious = nNeighboor;
        end
        if nNext > nNeighboor
            nNext = nNeighboor;
        end
        nNeigh = min(nPrevious,nNext);
        yFilt(i) = sum(y(i-nNeigh:i+nNeigh),1)/(nNeigh*2+1);
    end
end