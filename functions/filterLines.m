function [yLeftIntFilt,yLeftExtFilt,yRightIntFilt,yRightExtFilt] = filterLines(yLeftInt,yLeftExt,yRightInt,yRightExt,yRefreshedLeft,yRefreshedRight)

    nFrames = size(yRefreshedLeft,1);
    fRefreshLeft = zeros(nFrames,1);
    fRefreshRight = zeros(nFrames,1);
    
    for i = 2:nFrames
        fRefreshLeft(i) = fRefreshLeft(i-1)*0.95 + yRefreshedLeft(i)*0.05;
        fRefreshRight(i) = fRefreshRight(i-1)*0.95 + yRefreshedRight(i)*0.05;
    end
    
    conditionLeft = fRefreshLeft > 0.05;
    conditionRight= fRefreshRight > 0.05;

    conditionBoth = conditionLeft & conditionRight;

    lineWidthLeft   = yLeftExt-yLeftInt;
    centerLeft      = (yLeftExt + yLeftInt)/2;
    lineWidthRight  = yRightInt-yRightExt;
    centerRight     = (yRightExt+yRightInt)/2;
    laneWidth       = centerLeft - centerRight;

    t = [1:length(conditionLeft)]';

    laneWidthInterp = interp1(t(conditionBoth),laneWidth(conditionBoth),t,'previous');
    lineWidthLeftInterp = interp1(t(conditionLeft),lineWidthLeft(conditionLeft),t,'previous');
    lineWidthRightInterp = interp1(t(conditionRight),lineWidthRight(conditionRight),t,'previous');

    centerLeft2Right = centerLeft - laneWidthInterp;
    centerRight2Left = centerRight + laneWidthInterp;

    conditionCopyLeft= ~conditionLeft & conditionRight ;%& conditionRight;
    conditionCopyRight = ~conditionRight & conditionLeft;% & conditionLeft;

    centerLeftNew = centerLeft.*~conditionCopyLeft + centerRight2Left.*conditionCopyLeft;
    centerRightNew= centerRight.*~conditionCopyRight + centerLeft2Right.*conditionCopyRight;

    yLineLeftIntNew = centerLeftNew - lineWidthLeft/2;
    yLineLeftExtNew = centerLeftNew + lineWidthLeft/2;

    yLineRightIntNew = centerRightNew - lineWidthRight/2;
    yLineRightExtNew = centerRightNew + lineWidthRight/2;

     figure;
    hold on
    % plot(YLineLeftInt)
    % plot(YLineLeftExt)
    % plot(YLineRightExt)
    % plot(YLineRightInt)
    % 
    % 
    % plot(yLineLeftIntNew)
    % plot(yLineLeftExtNew)
    % plot(yLineRightExtNew)
    % plot(yLineRightIntNew)

    yLeftIntFilt = neighboorFilt(yLineLeftIntNew,10);
    yLeftExtFilt = neighboorFilt(yLineLeftExtNew,10);
    yRightIntFilt= neighboorFilt(yLineRightExtNew,10);
    yRightExtFilt= neighboorFilt(yLineRightIntNew,10);
    
    plot(yLeftIntFilt);
    plot(yLeftExtFilt);
    plot(yRightIntFilt);
    plot(yRightExtFilt);
end