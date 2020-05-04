function varargout = mainV4(varargin)
% MAINV4 MATLAB code for mainV4.fig
%      MAINV4, by itself, creates a new MAINV4 or raises the existing
%      singleton*.
%
%      H = MAINV4 returns the handle to a new MAINV4 or the handle to
%      the existing singleton*.
%
%      MAINV4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINV4.M with the given input arguments.
%
%      MAINV4('Property','Value',...) creates a new MAINV4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainV4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainV4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainV4

% Last Modified by GUIDE v2.5 30-Apr-2020 09:30:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainV4_OpeningFcn, ...
                   'gui_OutputFcn',  @mainV4_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainV4 is made visible.
function mainV4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainV4 (see VARARGIN)
% Define global variables
global currLineMarkingLeft
global currLineMarkingRight
global currRoadEvents
global currLineColorLeft
global currLineColorRight
global lineMarkingLeftSignal
global lineMarkingRightSignal
global roadEventsSignal
global lineColorLeftSignal
global lineColorRightSignal
global currSignal
global currFrame
global currTime
global pushbutton2beReset
global RoadEvents2beReset
global markerPlot

global logSaved
% Display companies Logos
[renaultLogo, map, alphachannel]= imread('Renault.png');
image(renaultLogo, 'AlphaData', alphachannel,'Parent',handles.Renault_Picture);
axis(handles.Renault_Picture,'image','off');
[utacLogo, map, alphachannel]= imread('UTAC.png');
image(utacLogo,'Parent',handles.UTAC_Picture);
axis(handles.UTAC_Picture,'image','off');

% Get log input lists
handles.logCAN = varargin{1};
handles.logVContext=varargin{2};
handles.canapeTaggingPath = varargin{3};

% Capsule handles parameters
handles.NumCapsule      = 1;
handles.restoreCapsule  = 0;
logSaved        = 1;

% init graph axes
hold(handles.Graph,'on');
set(handles.Graph,'XColor',[1,1,1]);
set(handles.Graph,'YColor',[1,1,1]);
set(handles.Graph,'Color',[0.2 0.2 0.2]);
% datacursormode('mainV4.fig');
handles.linePlot = plot(NaN,NaN,'LineStyle','-','Color',[0,1,1],'LineWidth',1,'Parent',handles.Graph,'HitTest','off');
handles.markerPlot= plot(NaN,NaN,'LineStyle','None','Marker','o',...
                                    'MarkerEdgeColor',[1,0,0],'MarkerSize',8,'Parent',handles.Graph);
handles.cursorMarker = plot(NaN,NaN,'LineStyle','None','Marker','o',...
                                    'MarkerEdgeColor',[1,1,0],'MarkerSize',8,'Parent',handles.Graph);
grid(handles.Graph,'minor');
% pointerBehavior.enterFcn =@enterPlotFcn;
% pointerBehavior.traverseFcn = @enterPlotFcn;
% pointerBehavior.exitFcn = [];
% iptSetPointerBehavior(handles.linePlot, pointerBehavior);
% iptPointerManager(handles.figure1, 'enable');
% Liste Capsule de l'es sai
handles.listCapsules = {handles.logCAN.time}';
set(handles.popupmenu_capsules, 'string', handles.listCapsules);

% Update the signal list
handles = switchCapsule(handles);

% Update the contextual video
handles = switchContext(handles);

% Refresh tagging buttons (according to loaded Log)
handles = refreshButtons(handles);

% Update the lateral videos
% handles = switchLateral(handles);

handles.output = hObject;

set(handles.figure1,'Units','Normalized','Position',[0 0 1 1]);
% 
% Update handles structure
guidata(hObject, handles);
% 

% 





% Choose default command line output for mainV4





% UIWAIT makes mainV4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Affichage 1ère frame de la video contextuelle :
% guidir=pwd;
% cd(logVContext(NumCapsule).folder);
% logVContext
% logVContext(NumCapsule).name
% [logVContext(NumCapsule).hvid] = VideoReader(logVContext(NumCapsule).name);
% % cd(guidir);
% L
% handles.L=L;


% --- Outputs from this function are returned to the command line.
function varargout = mainV4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes_video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_video

% --- Executes on selection change in popupmenu_capsules.
function popupmenu_capsules_Callback(hObject, eventdata, handles)
global logSaved
newNumCapsule = get(hObject,'Value');

% Check if the current log has been saved
if logSaved == 0 % The log hasn't been saved
    userChoice = questdlg('Save changes ?','Save Question','Save', 'Don"t Save', 'Cancel','Save')
    switch userChoice
        case 'Save'
            handles = saveCapsule(handles);
        case 'Cancel'
            return; % The user choosed to cancel the "switch capsule" operation
    end
end
handles.NumCapsule = newNumCapsule;
% Switch the current capsule
handles = switchCapsule(handles);
logSaved = 0;
% Update the contextual video
handles = switchContext(handles);
% Update the Buttons colors
handles = refreshButtons(handles);
% Update the Graph
handles = refreshGraph(handles);
guidata(hObject, handles);

% handles.output = hObject;


% --- Executes during object creation, after setting all properties.
function popupmenu_capsules_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_capsules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% for n=1:length(handles.logCAN)
%     eval(['[ListCaps(n).name]=handles.logCAN(n).date;'])
% end
% ListCaps=ListCaps';
% handles.ListCaps=ListCaps;
% handles.ListCapsName=ListCaps.name
% 
% % handles.ListCapsName=get(handles.ListCapsName,'string');
% set(hObject, 'String', {handles.ListCapsName});

% --- Executes on selection change in listsignaux.
function listsignaux_Callback(hObject, eventdata, handles)
global currSignal
currSignalNames = get(hObject,'String');
currSignalIndex = get(hObject,'Value');
currSignal = currSignalNames{currSignalIndex};
handles = refreshGraph(handles)
drawnow;

function listsignaux_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listsignaux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.

% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% NumCapsule1=str2num(get(handles.NumCapsule,'string'))
% Signaux1=load(fullfile(handles.logCAN(NumCapsule1).folder,handles.logCAN(NumCapsule1).name));
% handles.SignauxName=fieldnames(Signaux1);
% set(hObject, 'String', {handles.SignauxName});

% --- Executes on slider movement.
function slider_video_Callback(hObject, eventdata, handles)
newFrame = round(get(hObject, 'Value'));

if newFrame>=1 && newFrame<handles.vCont.nbFrames
    newTime  = interp1([1 handles.vCont.nbFrames],[handles.vCont.t0 handles.hvidCont.Duration],newFrame);
    handles = refresh_guiV4(hObject, eventdata, handles, newTime);
    handles = refreshButtons(handles)
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_video_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', 1);


% --- Executes on button press in togglebutton_play.
function togglebutton_play_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currTime
flag_btn_pushed = get(hObject, 'Value');

if flag_btn_pushed == 1
    new_state = 'PLAY';
elseif flag_btn_pushed == 0
    new_state = 'PAUSE';
else
    error('Play/Pause button has an undefined state.');
end

if strcmp(new_state, 'PLAY')
    handles.playbtnState = 'PLAY';
    set(hObject, 'String', 'PAUSE');
    set(hObject, 'BackgroundColor', [0.15 0.15 0.15]);
    set(hObject, 'ForegroundColor', [1    0    0]);
    set(handles.text_dynamic_gui_state,'String','PAUSED');
elseif strcmp(new_state, 'PAUSE')
    handles.playbtnState = 'PAUSE';
    set(hObject, 'String', 'PLAY');
    set(hObject, 'BackgroundColor', [0.15 0.15 0.15]);
    set(hObject, 'ForegroundColor', [0    1    0]);
    set(handles.text_dynamic_gui_state,'String','PLAY');
else
    error('uicontrol play button error : undefined state');
end
% Lancement de la vidéo :
if strcmp(handles.playbtnState, 'PLAY')
   set(handles.markerPlot,'XData',NaN,'YData',NaN);
   while currTime < handles.hvidCont.Duration-1/handles.vCont.frameRate &&...
           get(handles.togglebutton_play, 'Value')==flag_btn_pushed
       handles = refresh_guiV4(hObject, eventdata, handles);
       drawnow();
       handles = updateLog(handles);
       handles = refreshButtons(handles);
%        if mod(currFrame,round(handles.vCont.frameRate))==0
%         handles = refreshGraph(handles,1);
%        end
%        pause(0.01/handles.vCont.frameRate);
       pause(eps);
       guidata(hObject, handles);
   end
   % Une fois arrivé à la fin de la vidéo, on remet la GUI en pause :
   GUI.uicontrols.playbtn.state = 'PAUSE';
   set(hObject, 'String', 'PLAY');
   set(hObject, 'BackgroundColor', [0.15 0.15 0.15]);
   set(hObject, 'ForegroundColor', [0    1    0]); 
   set(handles.text_dynamic_gui_state,'String','PAUSED');
   set(hObject, 'Value', 0);
   
   handles = refreshGraph(handles,1);
   guidata(hObject, handles);
end
   % Hint: get(hObject,'Value') returns toggle state of togglebutton_play
% --- Executes during object creation, after setting all properties.
function togglebutton_play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.playbtnState = 'PAUSE';
set(hObject, 'String', 'PLAY');

% --- Executes on button press in pushbutton_previous_frame.
function pushbutton_previous_frame_Callback(hObject, eventdata, handles)
global currTime
if currTime >= handles.vCont.t0+1/handles.vCont.frameRate
    handles = refresh_guiV4(hObject, eventdata, handles, currTime-1/handles.vCont.frameRate);
    handles = refreshButtons(handles);
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_next_frame.
function pushbutton_next_frame_Callback(hObject, eventdata, handles)
global currTime
if currTime < handles.hvidCont.Duration-1/handles.vCont.frameRate % Seulement si il existe des frames suivantes
    handles = refresh_guiV4(hObject, eventdata, handles);
    handles = refreshButtons(handles);
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_previous_speed_frame.
function pushbutton_previous_speed_frame_Callback(hObject, eventdata, handles)
global currTime
if currTime >= handles.vCont.t0+10
    handles = refresh_guiV4(hObject, eventdata, handles, currTime-10);
    handles = refreshButtons(handles);
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_speed_next_frame.
function pushbutton_speed_next_frame_Callback(hObject, eventdata, handles)
global currTime
if currTime <= handles.hvidCont.Duration-10
    handles = refresh_guiV4(hObject, eventdata, handles, currTime+10);
    handles = refreshButtons(handles);
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)




function edit_jump2Frame_Callback(hObject, eventdata, handles)
newFrame =  str2num(get(hObject,'String'));

if newFrame>=1 && newFrame<handles.vCont.nbFrames
    newTime  = interp1([1 handles.vCont.nbFrames],[handles.vCont.t0 handles.hvidCont.Duration],newFrame);
    handles = refresh_guiV4(hObject, eventdata, handles, newTime);
    handles = refreshButtons(handles);
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_jump2Frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_jump2Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%% LINE MARKING RIGHT  %%%%

% --- Executes on button press in pushbutton_undecided_right.
function pushbutton_undecided_right_Callback(hObject, eventdata, handles)
global currLineMarkingRight
currLineMarkingRight = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_solid_right.
function pushbutton_solid_right_Callback(hObject, eventdata, handles)
global currLineMarkingRight
currLineMarkingRight = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_roadEdge_right.
function pushbutton_roadEdge_right_Callback(hObject, eventdata, handles)
global currLineMarkingRight
currLineMarkingRight = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_dashed_right.
function pushbutton_dashed_right_Callback(hObject, eventdata, handles)
global currLineMarkingRight
currLineMarkingRight = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_doubleLine_right.
function pushbutton_doubleLine_right_Callback(hObject, eventdata, handles)
global currLineMarkingRight
currLineMarkingRight = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_barrier_right.
function pushbutton_barrier_right_Callback(hObject, eventdata, handles)
global currLineMarkingRight
currLineMarkingRight = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

%%%% LINE MARKING LEFT %%%%
% --- Executes on button press in pushbutton_undecided_left.
function pushbutton_undecided_left_Callback(hObject, eventdata, handles)
global currLineMarkingLeft
currLineMarkingLeft = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_solid_left.
function pushbutton_solid_left_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_solid_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currLineMarkingLeft
currLineMarkingLeft = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_dashed_left.
function pushbutton_dashed_left_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dashed_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currLineMarkingLeft
currLineMarkingLeft = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_roadEdge_left.
function pushbutton_roadEdge_left_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_roadEdge_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global currLineMarkingLeft
currLineMarkingLeft = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_doubleLine_left.
function pushbutton_doubleLine_left_Callback(hObject, eventdata, handles)
global currLineMarkingLeft
currLineMarkingLeft = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_barrier_left.
function pushbutton_barrier_left_Callback(hObject, eventdata, handles)
global currLineMarkingLeft
currLineMarkingLeft = switchLineMarking(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function axes_videoRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_videoRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_videoRight


% --- Executes during object creation, after setting all properties.
function axes_videoLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_videoLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uibuttongroup3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_dynamic_nb_frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_nb_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject, 'String', num2str(handles.VContNb_frames));


% --- Executes during object creation, after setting all properties.
function text_dynamic_nb_frames_Vbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_nb_frames_Vbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject, 'String', num2str(handles.VboxNb_frames));


% --- Executes during object creation, after setting all properties.
function text_dynamic_video_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_video_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function VideoContextDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoContextDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_dynamic_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_dynamic_frame_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_frame_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function pushbutton_speed_next_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_speed_next_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.Backgroundvalue=get(hObject,'BackgroundColor');
handles.Foregroundvalue=get(hObject,'ForegroundColor');


% --- Executes on key press with focus on togglebutton_play and none of its controls.
function togglebutton_play_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton_play (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function searchSignal_Callback(hObject, eventdata, handles)
% hObject    handle to searchSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchSignal as text
%        str2double(get(hObject,'String')) returns contents of searchSignal as a double
searchStr = get(hObject,'String');
Index = find(contains(handles.SignauxName,searchStr,'IgnoreCase',true));
newSignals = handles.SignauxName(Index);
set(handles.listsignaux,'Value',1);
set(handles.listsignaux,'String',sort(newSignals));

% --- Executes during object creation, after setting all properties.
function searchSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_LM.
function pushbutton_LM_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_LS.
function pushbutton_LS_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_HwER.
function pushbutton_HwER_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_HwEL.
function pushbutton_HwEL_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_arrow.
function pushbutton_arrow_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_cones.
function pushbutton_cones_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_zebra.
function pushbutton_zebra_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_barrier.
function pushbutton_barrier_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in togglebutton_tunnel.
function togglebutton_tunnel_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in togglebutton_lineUsed.
function togglebutton_lineUsed_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in togglebutton_yellowLine.
function togglebutton_yellowLine_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in togglebutton_tarSeam.
function togglebutton_tarSeam_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_clearRoadEvents.
function pushbutton_clearRoadEvents_Callback(hObject, eventdata, handles)
global currRoadEvents
currRoadEvents = switchRoadEvents(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_saveCapsule.
function pushbutton_saveCapsule_Callback(hObject, eventdata, handles)
handles = saveCapsule(handles);
handles = refreshButtons(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_restoreCapsule.
function pushbutton_restoreCapsule_Callback(hObject, eventdata, handles)
handles.restoreCapsule = 1; % We want to load the raw file
handles = switchCapsule(handles);
handles = switchContext(handles);
handles = refreshButtons(handles);
guidata(hObject,handles);


% Line Color

% --- Executes on button press in pushbutton_white_left.
function pushbutton_white_left_Callback(hObject, eventdata, handles)
global currLineColorLeft
currLineColorLeft = switchLineColor(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);

% --- Executes on button press in pushbutton_yellow_left.
function pushbutton_yellow_left_Callback(hObject, eventdata, handles)
global currLineColorLeft
currLineColorLeft = switchLineColor(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_blue_left.
function pushbutton_blue_left_Callback(hObject, eventdata, handles)
global currLineColorLeft
currLineColorLeft = switchLineColor(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_white_right.
function pushbutton_white_right_Callback(hObject, eventdata, handles)
global currLineColorRight
currLineColorRight = switchLineColor(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_yellow_right.
function pushbutton_yellow_right_Callback(hObject, eventdata, handles)
global currLineColorRight
currLineColorRight = switchLineColor(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_blue_right.
function pushbutton_blue_right_Callback(hObject, eventdata, handles)
global currLineColorRight
currLineColorRight = switchLineColor(eventdata);
handles = updateLog(handles);
handles = refreshButtons(handles);
handles = refreshGraph(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_googleEarth.
function pushbutton_googleEarth_Callback(hObject, eventdata, handles)
openGoogle(handles,eventdata)
guidata(hObject,handles);

% --- Executes on button press in pushbutton_streetView.
function pushbutton_streetView_Callback(hObject, eventdata, handles)
openGoogle(handles,eventdata)
guidata(hObject,handles);


% --- Executes on mouse press over axes background.
function Graph_ButtonDownFcn(hObject, eventdata, handles)
global currSignal
YData = getfield(handles.loadedLog,currSignal);
XData = handles.loadedLog.t;
mousePoint = eventdata.IntersectionPoint(1:2);
linePoints = [XData YData];
distances  = sqrt(sum(((linePoints-mousePoint)./handles.Graph.Position(3:4)).^2,2));
[minDist indClosest] = min(distances);
newTime = handles.loadedLog.t(indClosest);
if newTime>=handles.vCont.t0 && newTime<=handles.hvidCont.Duration-handles.vCont.t0
    handles = refresh_guiV4(hObject, eventdata, handles, newTime);
    initCurrTagging(handles)
    handles = refreshButtons(handles)
    handles = refreshGraph(handles,1);
end
guidata(hObject, handles);
