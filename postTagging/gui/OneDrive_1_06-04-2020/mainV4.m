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

% Last Modified by GUIDE v2.5 05-Apr-2020 21:24:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
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

logCAN=varargin{1};
handles.logCAN=logCAN;

logVContext=varargin{2};
handles.logVContext=logVContext;

logVvbox=varargin{3};
handles.logVvbox=logVvbox;

NumCapsule=1;
handles.NumCapsule=NumCapsule;

% Liste Capsule de l'essai
for n=1:length(handles.logCAN)
    eval(['[ListCaps(n).name]=handles.logCAN(n).date;'])
end
ListCaps=ListCaps';
handles.ListCaps=ListCaps;
ListCapsName={ListCaps.name};
handles.ListCapsName=ListCapsName;
set(handles.ListCapsuleTest, 'string', handles.ListCapsName);

% Liste signaux Capsule
handles.Signaux=load(fullfile(handles.logCAN(NumCapsule).folder,handles.logCAN(NumCapsule).name));
handles.SignauxName=fieldnames(handles.Signaux);
set(handles.listsignaux, 'string', handles.SignauxName);

for m=1:length(handles.ListCaps)
    handles.SignauxCurrent=load(fullfile(handles.logCAN(m).folder,handles.logCAN(m).name));
    for n=1:length(handles.Signaux.Line_Marking_Right)
    handles.SignauxCurrent.Line_Marking_Left(n)= 2;    
    handles.SignauxCurrent.Line_Marking_Right(n)= 3;
    end
end

%1er Image video context
[cheminVideoContext]=fullfile([logVContext(NumCapsule).folder],[logVContext(NumCapsule).name]);
hvidCont= VideoReader(cheminVideoContext);
handles.hvidCont=hvidCont;
imCont=read(handles.hvidCont,1);

%1er Image video vbox
[cheminVideoVbox]=fullfile([logVvbox(NumCapsule).folder],[logVvbox(NumCapsule).name]);
hvidVbox= VideoReader(cheminVideoVbox);
handles.hvidVbox=hvidVbox;
imVbox=read(hvidVbox,1);
imcLeft=imcrop(imVbox,[4 545 951 531]);
imcLeft=imrotate(imcLeft, 90);
imcRight=imcrop(imVbox,[964 544 951 531]);
imcRight=imrotate(imcRight, -90);

% Affichage du t0 :
hvidCont.FrameRate;
handles.VContFrameRate=hvidCont.FrameRate;
hvidCont.Duration;
handles.VContDuration=hvidCont.Duration;
handles.VContNb_frames = handles.VContDuration * handles.VContFrameRate;
handles.VContTime = [0:1/handles.VContFrameRate:handles.VContDuration]';  
frame_ID_init=get(handles.slider_video, 'Value');
% frame_ID_init=1;
frameCurrent = frame_ID_init;
handles.frameCurrent =frameCurrent;

handles.TimeCurrent = (frame_ID_init - 1) * (1/handles.VContFrameRate);
set(handles.text_dynamic_time, 'String', num2str(handles.TimeCurrent));

% % Initialisation de l'état lecture/pause de l'IHM :
handles.playbtnState = 'PAUSE';

% % Initialisation du Max slider :
set(handles.slider_video, 'Max', handles.VContNb_frames);

% Initialisation du 1er signal à afficher :
handles.current_signal = handles.Signaux.Line_Marking_Left;

%
handles.LengthSignalValue=length(handles.Signaux.Line_Marking_Left);
handles.CurrentValue=1;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Affichage 1er image Contextuelle
axes(handles.axes_video)
imshow(imCont);
axis off

%Affichage 1er image roue gauche
axes(handles.axes_videoLeft)
imshow(imcLeft);
axis off

axes(handles.axes_videoRight)
imshow(imcRight);
axis off

axes(handles.Graph)
imshow(handles.current_signal);
axis off




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

% --- Executes on selection change in ListCapsuleTest.
function ListCapsuleTest_Callback(hObject, eventdata, handles)
% hObject    handle to ListCapsuleTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ListCapsuleTest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ListCapsuleTest
contents = cellstr(get(hObject,'String'));          % Liste des signaux
selected_capsule = contents{get(hObject,'Value')};   % Signal sélectionné
handles.NumCapsule = find(contains({handles.ListCaps.name},selected_capsule,'IgnoreCase',true));

%Signaux Capsule
Signaux=load(fullfile(handles.logCAN(handles.NumCapsule).folder,handles.logCAN(handles.NumCapsule).name));
handles.SignauxName=fieldnames(Signaux);
set(handles.listsignaux, 'String', handles.SignauxName);

%1er Image video context
[cheminVideoContext]=fullfile([handles.logVContext(handles.NumCapsule).folder],[handles.logVContext(handles.NumCapsule).name]);
hvidCont= VideoReader(cheminVideoContext);
handles.hvidCont=hvidCont;
imCont=read(handles.hvidCont,1);

%1er Image video vbox
[cheminVideoVbox]=fullfile([handles.logVvbox(handles.NumCapsule).folder],[handles.logVvbox(handles.NumCapsule).name]);
hvidVbox= VideoReader(cheminVideoVbox);
handles.hvidVbox=hvidVbox;
imVbox=read(handles.hvidVbox,1);
imcLeft=imcrop(imVbox,[4 545 951 531]);
imcLeft=imrotate(imcLeft, 90);
imcRight=imcrop(imVbox,[964 544 951 531]);
imcRight=imrotate(imcRight, -90);
% handles.logVContext.hvid

% handles.output = hObject;

%% Chargement du fichier vidéo Contextuelle :
hvidVbox.FrameRate;
handles.VboxFrameRate=hvidVbox.FrameRate;
hvidVbox.Duration;
handles.VboxDuration=hvidVbox.Duration;
handles.VboxNb_frames = handles.VboxDuration * handles.VboxFrameRate;
handles.VboxTime = [0:1/handles.VboxFrameRate:handles.VboxDuration]';      % Vecteur temps de la vidéo contextuelle
set(handles.text_dynamic_nb_frames_Vbox, 'String', num2str(handles.VboxNb_frames));
set(handles.VideoVboxDuration, 'String', num2str(handles.VboxDuration));

%% Chargement du fichier vidéo Contextuelle :
hvidCont.FrameRate;
handles.VContFrameRate=hvidCont.FrameRate;
hvidCont.Duration;
handles.VContDuration=hvidCont.Duration;
handles.VContNb_frames = handles.VContDuration * handles.VContFrameRate;
handles.VContTime = [0:1/handles.VContFrameRate:handles.VContDuration]';      % Vecteur temps de la vidéo contextuelle
set(handles.text_dynamic_nb_frames_Contexte, 'String', num2str(handles.VContNb_frames));
set(handles.VideoContextDuration, 'String', num2str(handles.VContDuration));

% % Initialisation du slider à 1er frame :
handles.frameCurrent=1;
set(handles.slider_video, 'Value', 1);
% % Initialisation du Max slider :
set(handles.slider_video, 'Max', handles.VContNb_frames);

% % Initialisation valeur courante et la dimension des signaux 
handles.LengthSignalValue=length(handles.Signaux.Line_Marking_Left);
handles.CurrentValue=1;

% Update handles structure
guidata(hObject, handles);

%Affichage 1er image Contextuelle
axes(handles.axes_video)
imshow(imCont);
axis off

%Affichage 1er image roue gauche
axes(handles.axes_videoLeft)
imshow(imcLeft);
axis off

axes(handles.axes_videoRight)
imshow(imcRight);
axis off
% guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ListCapsuleTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ListCapsuleTest (see GCBO)
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
% hObject    handle to listsignaux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listsignaux contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listsignaux
contents = cellstr(get(hObject,'String'));          % Liste des signaux
selected_signals = contents{get(hObject,'Value')};

current_frame = str2num(get(handles.text_dynamic_fram_ID, 'String'));       % Prévoir plutot de récupérer la frame courante avec l'objet GUI

handles.current_signal = selected_signals;
refresh_guiV4(hObject, eventdata, handles, current_frame);
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.

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
% hObject    handle to slider_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
new_frame = floor(get(hObject, 'Value'));
handles.frameCurrent=new_frame;
refresh_guiV4(hObject, eventdata, handles, new_frame);
guidata(hObject, handles);
% handles.CurrentValue

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
    set(hObject, 'BackgroundColor', [0.5 0.5 0.5]);
    set(hObject, 'ForegroundColor', [1 1 1]);
elseif strcmp(new_state, 'PAUSE')
    handles.playbtnState = 'PAUSE';
    set(hObject, 'String', 'PLAY');
    set(hObject, 'BackgroundColor', [0 1 0]);
    set(hObject, 'ForegroundColor', [0 0 0]);
else
    error('uicontrol play button error : undefined state');
end
% handles.frameCurrent =frameCurrent;
% current_frame = handles.frameCurrent;
% Lancement de la vidéo :
if strcmp(handles.playbtnState, 'PLAY')
   handles.current_frame = handles.frameCurrent;
   
   while handles.current_frame <= handles.VContNb_frames
       % disp(num2str(current_frame));
       
       refresh_guiV4(hObject, eventdata, handles, handles.current_frame);
       drawnow();
%        pause(1/(handles.VContFrameRate*1000));
       
       % Critère d'arrêt de la boucle :
       loop_break_flag = get(handles.togglebutton_play, 'Value');
       if loop_break_flag ~= flag_btn_pushed
           handles.playbtnstate = 'PAUSE';
           handles.frameCurrent= handles.current_frame;
           refresh_guiV4(hObject, eventdata, handles, handles.current_frame);
           guidata(hObject, handles);
%            handles.CurrentValue
           break;
       end
       handles.current_frame = handles.current_frame + 5;
       handles.frameCurrent= handles.current_frame;
   end
%     % Une fois arrivé à la fin de la vidéo, on remet la GUI en pause :
%    GUI.uicontrols.playbtn.state = 'PAUSE';
%    refresh_guiV4(hObject, eventdata, handles, current_frame - 1);
%    set(hObject, 'String', 'PLAY');
%    set(hObject, 'BackgroundColor', [0 1 0]);
%    set(hObject, 'ForegroundColor', [0 0 0]); 
end
guidata(hObject, handles);
   % Hint: get(hObject,'Value') returns toggle state of togglebutton_play
% --- Executes during object creation, after setting all properties.
function togglebutton_play_CreateFcn(hObject, eventdata, handles)
% hObject    handle to togglebutton_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.playbtnState = 'PAUSE';
set(hObject, 'String', 'PLAY');

% --- Executes on button press in pushbutton_preview_frame.
function pushbutton_preview_frame_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preview_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.frameCurrent >= 1 %* (1/handles.VContFrameRate))     % Seulement si il existe des frames suivantes
    
    handles.frameCurrent = floor(get(handles.slider_video, 'Value'));
    new_frame = handles.frameCurrent -1;
    refresh_guiV4(hObject, eventdata, handles, new_frame);
    handles.frameCurrent=new_frame;
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_next_frame.
function pushbutton_next_frame_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_next_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.frameCurrent <= ((handles.VContNb_frames - 2)) %* (1/handles.VContFrameRate))     % Seulement si il existe des frames suivantes
    
    handles.frameCurrent = floor(get(handles.slider_video, 'Value'));
    new_frame = handles.frameCurrent + 1;
    refresh_guiV4(hObject, eventdata, handles, new_frame);
    handles.frameCurrent=new_frame;
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_return_frame.
function pushbutton_return_frame_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_return_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag_btn_pushed = get(hObject, 'Value');
backgroundcolor= get(hObject, 'BackgroundColor');
if flag_btn_pushed == 1
    new_state = 'PLAY';
elseif flag_btn_pushed == 0
    new_state = 'PAUSE';
else
    error('Play/Pause button has an undefined state.');
end
% 
if strcmp(new_state, 'PLAY')
    handles.ReturnbtnState = 'PLAY';
% %     set(hObject, 'String', 'PAUSE');
    set(hObject, 'BackgroundColor', [0 0 1]);
%     set(hObject, 'ForegroundColor', [0 0 0]);
elseif strcmp(new_state, 'PAUSE')
    handles.ReturnbtnState = 'PAUSE';
%     set(hObject, 'BackgroundColor', [0 0 1]);
%     set(hObject, 'ForegroundColor', handles.Foregroundvalue);
else
    error('uicontrol play button error : undefined state');
end
if strcmp(handles.ReturnbtnState, 'PLAY')
   handles.current_frame = handles.frameCurrent;
    while handles.frameCurrent >= 1 % * (1/handles.VContFrameRate))     % Seulement si il existe des frames suivantes

    %     handles.frameCurrent = floor(get(handles.slider_video, 'Value'));
        refresh_guiV4(hObject, eventdata, handles, handles.current_frame);
        handles.frameCurrent=handles.current_frame;
      % Critère d'arrêt de la boucle :
       loop_break_flag = get(handles.pushbutton_return_frame, 'Value');
       if loop_break_flag ~= flag_btn_pushed
               handles.ReturnbtnState = 'PAUSE';
               set(hObject, 'BackgroundColor', backgroundcolor);
               refresh_guiV4(hObject, eventdata, handles, handles.current_frame);
               handles.frameCurrent= handles.current_frame;
               guidata(hObject, handles);
            break;
       end  
         handles.current_frame = handles.current_frame - 20;
         handles.frameCurrent= handles.current_frame;
    end
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_speed_frame.
function pushbutton_speed_frame_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_speed_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag_btn_pushed = get(hObject, 'Value');
background=get(hObject,'background');
if flag_btn_pushed == 1
    new_state = 'PLAY';
elseif flag_btn_pushed == 0
    new_state = 'PAUSE';
else
    error('Play/Pause button has an undefined state.');
end
% 
if strcmp(new_state, 'PLAY')
    handles.SpeedupbtnState = 'PLAY';
% %     set(hObject, 'String', 'PAUSE');
    set(hObject, 'BackgroundColor', [0 0 1]);
%     set(hObject, 'ForegroundColor', [0 0 0]);
elseif strcmp(new_state, 'PAUSE')
    handles.SpeedupbtnState = 'PAUSE';
%     set(hObject, 'BackgroundColor', handles.Backgroundvalue);
%     set(hObject, 'ForegroundColor', handles.Foregroundvalue);
else
    error('uicontrol play button error : undefined state');
end
if strcmp(handles.SpeedupbtnState, 'PLAY')
   handles.current_frame = handles.frameCurrent;
    while handles.frameCurrent <= ((handles.VContNb_frames - 2)) % * (1/handles.VContFrameRate))     % Seulement si il existe des frames suivantes

    %     handles.frameCurrent = floor(get(handles.slider_video, 'Value'));
        refresh_guiV4(hObject, eventdata, handles, handles.current_frame);
        handles.frameCurrent=handles.current_frame;
      % Critère d'arrêt de la boucle :
       loop_break_flag = get(handles.pushbutton_speed_frame, 'Value');
       if loop_break_flag ~= flag_btn_pushed
               handles.SpeedupbtnState = 'PAUSE';
               set(hObject, 'BackgroundColor', background);
               refresh_guiV4(hObject, eventdata, handles, handles.current_frame);
               handles.frameCurrent= handles.current_frame;
               guidata(hObject, handles);
            break;
       end  
         handles.current_frame = handles.current_frame + 20;
         handles.frameCurrent= handles.current_frame;
    end
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RoadEdge_button.
function RoadEdge_button_Callback(hObject, eventdata, handles)
% hObject    handle to RoadEdge_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% g=handles.Signaux.Line_Marking_Left
for n=handles.CurrentValue:handles.LengthSignalValue
    handles.Signaux.Line_Marking_Left(n)=1;
end
guidata(hObject, handles);
new_frame=handles.frameCurrent;
refresh_guiV4(hObject, eventdata, handles, new_frame);
guidata(hObject, handles);
g=unique(handles.Signaux.Line_Marking_Left);
% plot([1:handles.LengthSignalValue],handles.Signaux.Line_Marking_Left)

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

% Hint: place code in OpeningFcn to populate axes_videoLeft


% --- Executes during object creation, after setting all properties.
function uibuttongroup3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_dynamic_nb_frames_Contexte_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_nb_frames_Contexte (see GCBO)
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
function VideoVboxDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoVboxDuration (see GCBO)
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
function text_dynamic_fram_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_dynamic_fram_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function pushbutton_speed_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_speed_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.Backgroundvalue=get(hObject,'BackgroundColor');
handles.Foregroundvalue=get(hObject,'ForegroundColor');


% --- Executes during object creation, after setting all properties.
function Graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Graph
