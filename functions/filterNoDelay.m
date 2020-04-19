function [yFiltUnDelaid,delay] = filterNoDelay(y,window)
    nElem = size(y,1);
    kernel = ones(window,1) / window;
    yFilt  = filter(kernel, 1, y);
    delay = ceil(mean(grpdelay(kernel)));
    yFiltUnDelaid = yFilt(delay:nElem);
end
    