% This function is intended to modify the groundTruth quality
% The quality can have 2 values :
% 1: Relevant -> Will be used in the performance scripts
% 0: Not Relevant -> Will not taken in account
function [referenceoffsetNew referenceYawNew referenceCurvatureNew referenceQuality referenceProjPositionNew] = getGTQuality(measureOffset,measureYaw,measureCurvature,referenceOffset,referenceYaw,referenceCurvature,t,referenceProjPosition);
%     curvatureDiffThrsh= 2*10^-4;
%     yawAngleDiffThrsh = 2*10^-4;
%     projPosDiffThrsh  = 3*10^-2;
%     curvatureDiffFilt = neighboorFilt(abs(diff(referenceCurvature)),40);
%     yawAngleDiffFilt   = neighboorFilt(abs(diff(referenceYaw)),40);
%     projPosDiffFilt   = neighboorFilt(abs(diff(referenceProjPosition)),40);
%     referenceQuality  = [curvatureDiffFilt<curvatureDiffThrsh & yawAngleDiffFilt<yawAngleDiffThrsh & projPosDiffFilt<projPosDiffThrsh;0] & ~isnan(referenceOffset);
%     
    referenceQuality = t*0+1;
    qualityBrkptsRaw = t(find(diff(referenceQuality)~=0));
    [qualityBrkpts qualityValues] = refreshQuality(qualityBrkptsRaw,t);
    fig = figure('units','normalized','outerposition',[0 0 1 1]);
    ax(1) = subplot(4,1,1);
    ax(2) = subplot(4,1,2);
    ax(3)= subplot(4,1,3);
    ax(4)  = subplot(4,1,4);
    % Plot
    % Offset
    hold(ax(1),'on');
    grid(ax(1),'minor');
    plot(ax(1),t,measureOffset,'LineWidth',1);
    plot(ax(1),t,referenceOffset,'LineWidth',1);
%     
    legend(ax(1),'Measure','GroundTruth');
    xlim(ax(1),[t(1),t(end)]);
    title(ax(1),'Offset (m)');
    % yaw Angle
    hold(ax(2),'on');
    grid(ax(2),'minor');
    plot(ax(2),t,measureYaw,'LineWidth',1);
    plot(ax(2),t,referenceYaw,'LineWidth',1);
%     
    legend(ax(2),'Measure','GroundTruth');
    xlim(ax(2),[t(1),t(end)]);
    title(ax(2),'Yaw Angle (m)');
    % curvature
    hold(ax(3),'on');
    grid(ax(3),'minor');
    plot(ax(3),t,measureCurvature,'LineWidth',1);
    plot(ax(3),t,referenceCurvature,'LineWidth',1);
%     
    legend(ax(3),'Measure','GroundTruth');
    xlim(ax(3),[t(1),t(end)]);
    title(ax(3),'Curvature (C2)');

    % Quality
    grid(ax(4),'on');
    plot(ax(4),qualityBrkpts,qualityValues,'o-','Color',[80, 127, 199]/255,'MarkerEdgeColor',[242, 93, 0]/255,'LineWidth',1);
    xlim(ax(4),[t(1),t(end)]);
    ylim(ax(4),[-0.1 1.1]);
    title(ax(4),'Ground Truth quality (1 : Relevant / 0 : Not Relevant)');
    linkaxes(ax,'x');
    
    qualityBrkptsOk = false;
    qualityUserConfirmation = false;
    
    datacursormode on
    dcm_obj = datacursormode(fig);
    % Set update function
    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    while qualityUserConfirmation == false
        % Wait while the user to click
        msgbox('Click line to display a data tip, then press "Return"', 'GT Quality');
        while qualityBrkptsOk==false
            pause;
            % Export cursor to workspace
            info_struct = getCursorInfo(dcm_obj);
            if isfield(info_struct, 'Position')
                if mod(length(info_struct),2)==0 % nb of Brkpts is even
                  qualityBrkptsRaw = zeros(length(info_struct),1);
                  for i=1:length(info_struct)
                      qualityBrkptsRaw(i) = info_struct(i).Position(1)
                  end
                  [qualityBrkpts qualityValues] = refreshQuality(sort(qualityBrkptsRaw),t);
                  plot(ax(4),qualityBrkpts,qualityValues,'o-','Color',[80, 127, 199]/255,'MarkerEdgeColor',[242, 93, 0]/255,'LineWidth',1);
                  figure(fig);
                  qualityBrkptsOk = true;
                else
                     msgbox('The number of data cursor must be even !!', 'WRONG');
                end
            else
                qualityBrkptsOk = true; % No Brkpts, but its ok
            end
            
        end
        userAnswer = questdlg('Confirm Quality definition ?');
        if isequal(userAnswer,'Cancel')
            error('Process interrupted');
        end

        if isequal(userAnswer,'Yes')
            qualityUserConfirmation = true;
        else
            qualityUserConfirmation = false;
        end
        pause;
    end
    referenceQuality = interp1(qualityBrkpts,qualityValues,t);
    indNew = find(referenceQuality == 0 | isnan(referenceOffset));
    referenceoffsetNew      = interp1(t(indNew),referenceOffset(indNew),t);
    referenceYawNew         = interp1(t(indNew),referenceYaw(indNew),t);
    referenceCurvatureNew   = interp1(t(indNew),referenceCurvature(indNew),t);
    referenceProjPositionNew   = interp1(t(indNew),referenceProjPosition(indNew),t);
    
    referenceoffsetNew          = referenceOffset;
    referenceYawNew             = referenceYaw;
    referenceCurvatureNew       = referenceCurvature;
    referenceProjPositionNew    = referenceProjPosition;
    
    referenceoffsetNew(indNew)      = NaN;
    referenceYawNew(indNew)         = NaN;
    referenceCurvatureNew(indNew)   = NaN;
    referenceProjPositionNew(indNew)= NaN;
    
    close(fig);
    
end
function [qualityBrkpts qualityValues] = refreshQuality(qualityBrkptsRaw,t)
    qualityBrkpts = unique(sort([t(1);qualityBrkptsRaw;qualityBrkptsRaw+0.01;t(end)],'ascend'));
    qualityValues = qualityBrkpts*0;
    k = 0;
    currVal = 1;
    for i=1:length(qualityBrkpts)
        if k==2
            currVal = (1-currVal);
            k = 0;
        end
        qualityValues(i) = currVal;
        k = k+1;
    end
end
function output_txt = myupdatefcn(~,event_obj)
  % ~            Currently not used (empty)
  % event_obj    Object containing event data structure
  % output_txt   Data cursor text
  pos = get(event_obj, 'Position');
  output_txt = {['x: ' num2str(pos(1))], ['y: ' num2str(pos(2))]};
end
