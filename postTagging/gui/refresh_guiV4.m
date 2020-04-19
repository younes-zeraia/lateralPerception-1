function handles = refresh_gui(hObject, eventdata, handles, new_frame)
global currFrame

%% Update GUI state string :
set(handles.text_dynamic_gui_state, 'String', handles.playbtnState);

%% Update frame contextual video :
handles = updateContext(handles,new_frame);

%% Update frame lateral videos :
% handles = updateLateral(handles);


%% Update slider :
set(handles.slider_video, 'Value', currFrame);

%% Update current frame ID :
set(handles.text_dynamic_frame_ID,'String',num2str(currFrame));

%% Update current time display :
set(handles.text_dynamic_time,'String',sprintf('%.2f',handles.hvidCont.CurrentTime));

%% Update Plot

% %% Update plot left :
% plot_width = GUI.plot.left.width;
% signals=load(logCAN(NumCapsule).name);
% 
% tmin = new_current_time - plot_width/2;
% tmax = new_current_time + plot_width/2;
% 
% disp(['Size signals.Time : ', num2str(size(logCAN(NumCapsule).Time))]);
% disp(['Size current_signal : ', num2str(size(signals.(GUI.plot.left.current_signal)))]);
% disp(['GUI.offset : ', num2str(GUI.offset)]);
% 
% time_chunk = signals.Time(signals.Time >= tmin & signals.Time <= tmax);
% signal_chunk = signals.(GUI.plot.left.current_signal)(signals.Time >= (tmin + GUI.offset) & signals.Time <= (tmax + GUI.offset));   % Attention ne fonctionne que si Time existe !
% try
%     % Find closest value to new_current_time in data vector :
%     [foo, index_current_value] = min(abs(signals.Time - (new_current_time + GUI.offset)));
%     current_value = signals.(GUI.plot.left.current_signal)(index_current_value);
% catch
%     current_value = NaN;
% end
% 
% if (tmax + GUI.offset > signals.Time(end))
%     padding = zeros((tmax + GUI.offset - signals.Time(end))/(signals.Time(2)-signals.Time(1)), 1);
%     signal_chunk = signals.(GUI.plot.left.current_signal)(signals.Time >= (tmin + GUI.offset) & signals.Time <= tmax);   % Attention ne fonctionne que si Time existe !
%     signal_chunk = [signal_chunk; padding];
% end
% if (tmin + GUI.offset < signals.Time(1))
%     padding = zeros((signals.Time(1) - tmin - GUI.offset)/(signals.Time(2)-signals.Time(1)), 1);
%     signal_chunk = signals.(GUI.plot.left.current_signal)(signals.Time >= tmin & signals.Time <= (tmax + GUI.offset));   % Attention ne fonctionne que si Time existe !
%     signal_chunk = [padding; signal_chunk];
% end
% 
% signal_min = min(signal_chunk);
% signal_max = max(signal_chunk);
% delta = signal_max - signal_min + eps;
% 
% % if (delta == 0)
% %     delta = 10;
% % end
% 
% ymin = signal_min - 0.1 * delta;
% ymax = signal_max + 0.1 * delta;
% 
% axes(handles.axes_plot_left);
% cla;
% 
% % Affichage du signal :
% disp(['Size time_chunk : ', num2str(size(time_chunk))]);
% disp(['Size signal_chunk : ', num2str(size(signal_chunk))]);
% if length(time_chunk) == length(signal_chunk) + 1
%     plot(time_chunk(1:end-1), signal_chunk);
%     hold on;
%     plot(time_chunk(1:end-1), signal_chunk, 'o');
% elseif length(signal_chunk) == length(time_chunk) + 1
%     plot(time_chunk, signal_chunk(1:end-1));
%     hold on;
%     plot(time_chunk, signal_chunk(1:end-1), 'o');
% else
%     plot(time_chunk, signal_chunk);
%     hold on;
%     plot(time_chunk, signal_chunk, 'o');
% end
% 
% 
% % Format ordonnées :
% % ytickformat('%.6f');
% 
% % Affichage du trait rouge représentant l'instant courant :
% hold on;
% grid on;
% line([new_current_time, new_current_time], [ymin - 0.5*delta, ymax + 0.5*delta], 'Color', 'r', 'LineWidth', 2);
% text(double(new_current_time), double(ymin + (0.025 * delta)), ['Current time : ', num2str(round(new_current_time, 4))], 'Color', 'w', 'BackgroundColor', 'r', 'FontWeight', 'bold');
% 
% if (ymin == 0 && ymax == 0)
%     ymin = -1;
%     ymax = 1;
% end
% 
% if (ymin == ymax)
%     ymin = ymin - 1;
%     ymax = ymax + 1;
% end
% 
% disp('LEFT PLOT :');
% disp(['tmin : ', num2str(tmin)]);
% disp(['tmax : ', num2str(tmax)]);
% disp(['ymin : ', num2str(ymin)]);
% disp(['ymax : ', num2str(ymax)]);
% 
% axis([tmin, tmax, ymin, ymax]);
% 
% title(stringBeautify(GUI.plot.left.current_signal));
% 
% % Mise à jour de l'objet GUI :
% GUI.plot.left.limits = [tmin, tmax, ymin, ymax];
% 
% % Mise à jour de la valeur numérique :
% set(handles.text_dynamic_left_value, 'String', num2str(current_value));
% 
% %% Update plot right :
% plot_width = GUI.plot.right.width;
% 
% tmin = new_current_time - plot_width/2;
% tmax = new_current_time + plot_width/2;
% 
% offset = round(GUI.offset, 2);
% 
% time_chunk = signals.Time(signals.Time >= tmin & signals.Time <= tmax);
% signal_chunk = signals.(GUI.plot.right.current_signal)(signals.Time >= (tmin + offset) & signals.Time <= (tmax + offset));   % Attention ne fonctionne que si Time existe !
% 
% try
%     % Find closest value to new_current_time in data vector :
%     [foo, index_current_value] = min(abs(signals.Time - (new_current_time + offset)));
%     current_value = signals.(GUI.plot.right.current_signal)(index_current_value);
% catch
%     current_value = NaN;
% end
% 
% if (tmax + GUI.offset > signals.Time(end))
%     padding = zeros((tmax + GUI.offset - signals.Time(end))/(signals.Time(2)-signals.Time(1)), 1);
%     signal_chunk = signals.(GUI.plot.right.current_signal)(signals.Time >= (tmin + GUI.offset) & signals.Time <= tmax);   % Attention ne fonctionne que si Time existe !
%     signal_chunk = [signal_chunk; padding];
% end
% if (tmin + GUI.offset < signals.Time(1))
%     padding = zeros((signals.Time(1) - tmin - GUI.offset)/(signals.Time(2)-signals.Time(1)), 1);
%     signal_chunk = signals.(GUI.plot.right.current_signal)(signals.Time >= tmin & signals.Time <= (tmax + GUI.offset));   % Attention ne fonctionne que si Time existe !
%     signal_chunk = [padding; signal_chunk];
% end
% 
% signal_min = min(signal_chunk);
% signal_max = max(signal_chunk);
% delta = signal_max - signal_min + eps;
% 
% ymin = signal_min - 0.1*delta;
% ymax = signal_max + 0.1*delta;
% 
% axes(handles.axes_plot_right);
% cla;
% 
% % Affichage du signal :
% if length(time_chunk) == length(signal_chunk) + 1
%     plot(time_chunk(1:end-1), signal_chunk);
%     hold on;
%     plot(time_chunk(1:end-1), signal_chunk, 'o');
% elseif length(signal_chunk) == length(time_chunk) + 1
%     plot(time_chunk, signal_chunk(1:end-1));
%     hold on;
%     plot(time_chunk, signal_chunk(1:end-1), 'o');
% else
%     plot(time_chunk, signal_chunk);
%     hold on;
%     plot(time_chunk, signal_chunk, 'o');
% end
% 
% % Format ordonnées :
% % ytickformat('%.4f');
% 
% % Affichage du trait rouge représentant l'instant courant :
% hold on;
% grid on;
% line([new_current_time, new_current_time], [ymin-0.5*delta, ymax+0.5*delta], 'Color', 'r', 'LineWidth', 2);
% text(double(new_current_time), double(ymin + (0.025 * delta)), ['Current time : ', num2str(round(new_current_time, 4))], 'Color', 'w', 'BackgroundColor', 'r', 'FontWeight', 'bold');
% 
% if (ymin == 0 && ymax == 0)
%     ymin = -1;
%     ymax = 1;
% end
% 
% if (ymin == ymax)
%     ymin = ymin - 1;
%     ymax = ymax + 1;
% end
% 
% disp('RIGHT PLOT :');
% disp(['tmin : ', num2str(tmin)]);
% disp(['tmax : ', num2str(tmax)]);
% disp(['ymin : ', num2str(ymin)]);
% disp(['ymax : ', num2str(ymax)]);
% 
% axis([tmin, tmax, ymin, ymax]);
% 
% title(stringBeautify(GUI.plot.right.current_signal));
% 
% % Mise à jour de l'objet GUI :
% GUI.plot.right.limits = [tmin, tmax, ymin, ymax];
% 
% % Mise à jour de la valeur numérique :
% set(handles.text_dynamic_right_value, 'String', num2str(current_value));
% 
% %%
% drawnow;

end

function handles = updateContext(handles,new_frame)
    global currFrame
    if new_frame-currFrame~=1
        handles.hvidCont.CurrentTime = min(handles.hvidCont.CurrentTime + (new_frame-currFrame)/handles.vCont.frameRate,handles.hvidCont.Duration-1/handles.vCont.frameRate);
    end
    currFrame      = new_frame;
    handles.currTime             = new_frame/handles.vCont.frameRate;
    % Display next Frame of Contextual video
    image(readFrame(handles.hvidCont),'parent',handles.axes_video);
end

function handles = updateLateral(handles);
%     run('initParams');
%     handles.vVbox.currFrame = round(interp1([1 handles.vCont.nbFrames],[handles.loadedLog.vboxVideoFrameBegin handles.loadedLog.vboxVideoFrameEnd],handles.vCont.currFrame));
%     handles.hvidVbox.CurrentTime = handles.vVbox.currFrame/handles.hvidVbox.FrameRate;
    
    imVbox=readFrame(handles.hvidVbox);
    
    % Display next Frame of Lateral videos
    % Left
    image(imrotate(imcrop(imVbox,[4 545 951 531]), 90),'parent',handles.axes_videoLeft);
    % Right
    image(imrotate(imcrop(imVbox,[964 544 951 531]), -90),'parent',handles.axes_videoRight);
end