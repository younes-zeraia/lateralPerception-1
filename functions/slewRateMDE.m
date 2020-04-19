function y = slewRateMDE(y,SL)
    for i = 2:length(y)
        if y(i) > y(i-1)+SL
            y(i) = y(i-1)+SL;
        elseif y(i) < y(i-1)-SL
            y(i) = y(i-1)-SL;
        end
    end
end