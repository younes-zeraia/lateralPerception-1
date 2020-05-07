function varargout = plotLogs(varargin)
% PLOTLOGS MATLAB code for plotLogs.fig
%      PLOTLOGS, by itself, creates a new PLOTLOGS or raises the existing
%      singleton*.
%
%      H = PLOTLOGS returns the handle to a new PLOTLOGS or the handle to
%      the existing singleton*.
%
%      PLOTLOGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTLOGS.M with the given input arguments.
%
%      PLOTLOGS('Property','Value',...) creates a new PLOTLOGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotLogs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotLogs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotLogs

% Last Modified by GUIDE v2.5 19-Mar-2020 14:33:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotLogs_OpeningFcn, ...
                   'gui_OutputFcn',  @plotLogs_OutputFcn, ...
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


% --- Executes just before plotLogs is made visible.
function plotLogs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotLogs (see VARARGIN)

% Choose default command line output for plotLogs
% DisplayDefault('DefScenario_SS10_TargetLoss1.m',1);
handles.output      = hObject;
if nargin==1

    handles.logPath     = varargin{:}; % Load the specified logs path
    handles.logFiles    = filesearch(handles.logPath,'mat',0);

    % Set the log path object
    set(handles.pathTextBox,'string',handles.logPath);

    % Set the list of logs found in 'logs list object'
    str = {};
    for l = 1:length(handles.logFiles)
        str{l} = handles.logFiles(l).name;
    end

    set(handles.logsPopUpMenu,'string',str);
end

% Deactivate "edit plot" button, which be reactivated after plotting the
% figure
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes plotLogs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotLogs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
    str = get(hObject, 'String');
    val = get(hObject,'Value');
    switch str{val}
        case 'Default'
            DisplayDefault(handles.selectedScenario,1);
        case 'StandStill'
            DisplayStandstill(handles.selectedScenario,1);
        case 'Coasting'
            DisplayCoasting(handles.selectedScenario,1);
        case 'MRM'
            DisplayMRM(handles.selectedScenario,1);
    end


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    str = {'Default','StandStill','Coasting','MRM'};
    set(hObject,'string',str);


% --- Executes on selection change in logsPopUpMenu.
function handles = logsPopUpMenu_Callback(hObject, eventdata, handles)
    str = get(hObject,'String');
    val = get(hObject,'Value');
    handles.selectedLog = str{val};
    handles.logData     = load(fullfile(handles.logPath,handles.selectedLog));
    
    
    handles.variables = fieldnames(handles.logData);
    var = 1;
    while var <= length(handles.variables)
        if var == 215
            1+2;
        end
        variable2BePlot = isequal(class(getfield(handles.logData,handles.variables{var})),'double');
        if variable2BePlot == 0
            handles.variables(var) = [];
        else
            var = var+1;
        end
    end
    
    set(handles.VarList,'String',handles.variables);
    
    
    % Set time objects
    handles.time = handles.logData.t;
    lT   = length(handles.time);
    handles.iT = handles.time(1);
    handles.fT = handles.time(end);
    set(handles.InitTime,'String',num2str(handles.iT));
    set(handles.FinalTime,'String',num2str(handles.fT));
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function logsPopUpMenu_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)



function InitTime_Callback(hObject, eventdata, handles)
    handles.iT = uint8(str2num(get(hObject,'String')));
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function InitTime_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String','0');



function FinalTime_Callback(hObject, eventdata, handles)
    handles.fT = uint8(str2num(get(hObject,'String')));
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function FinalTime_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String','100');


% --- Executes on selection change in VarList.
function VarList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function VarList_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'max',100,'min',0);
    set(hObject,'Value',[]);


% --- Executes on button press in AddVar.
function AddVar_Callback(hObject, eventdata, handles)
    
    % Get the list of the selected signals to be added
    SelectedVar = get(handles.VarList,'Value');
    VarList     = get(handles.VarList,'String');

    % Record the previous signal list to be plot
    PreviousData = get(handles.VarTab,'data');
    NbData  = size(PreviousData,1);
    if NbData(1)>0
        PreviousList = PreviousData(:,1);
        LastVarFig   = cell2mat(PreviousData(NbData(1),2));
        LastVarPos   = cell2mat(PreviousData(NbData(1),3));
    else
        PreviousList = [];
        LastVarFig   = 1;
        LastVarPos   = 1;
    end
    NewVars = {VarList{SelectedVar,:}};
    DiffVars = setdiff(NewVars',PreviousList);
    DiffData = [];
    for i=1:length(DiffVars)
        DiffData{i,1} = DiffVars{i};
        DiffData{i,2} = LastVarFig;
        DiffData{i,3} = LastVarPos;
    end

    if  NbData<1
        NewTab = DiffData;
    else
        NewTab = [PreviousData
                  DiffData];
    end
    set(handles.VarTab,'data',sortrows(NewTab,[2 3]));


% --- Executes on button press in DeleteVar.
function DeleteVar_Callback(hObject, eventdata, handles)

    % Get the list of variables selected in the "variables to be plot" list
    SelectedVar             = handles.SelectedCell(:,1);
    
    % Get all variables in the "variables to be plot" list
    PreviousData            = get(handles.VarTab,'data');
    NewData                 = PreviousData;
    % Delete all selected variables
    NewData(SelectedVar,:)  = [];
    set(handles.VarTab,'data',NewData);

% --- Executes on selection change in SelectedVar.
function SelectedVar_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SelectedVar_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'max',100,'min',0);
    set(hObject,'Value',[]);


% --- Executes during object creation, after setting all properties.
function VarTab_CreateFcn(hObject, eventdata, handles)
    ColumnName = {'Variable Name','Figure','Position'};
    set(hObject,'ColumnName',ColumnName,'ColumnEditable',[false true true],...
        'ColumnWidth',{200 50 50});
    set(hObject,'data',[]);


% --- Executes when entered data in editable cell(s) in VarTab.
function VarTab_CellEditCallback(hObject, eventdata, handles)



% --- Executes when selected cell(s) is changed in VarTab.
function VarTab_CellSelectionCallback(hObject, eventdata, handles)
    handles.SelectedCell = eventdata.Indices;
    guidata(hObject,handles);


% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
    logData = handles.logData;
    
    receivedData = get(handles.VarTab,'data');
    Data     = sortrows(receivedData,[2 3]);
    
    % initialize de figures
    figSwitchIndexes    = find(diff([0;[Data{:,2}]'])==1);
    figIndexes          = [Data{figSwitchIndexes,2}];
    if isfield(handles,'figStruct')
        for f = 1:length(handles.figStruct)
            try
                close(handles.figStruct(f).figHandle);
            end
        end
            handles = rmfield(handles,'figStruct');
    end
    handles.figStruct           = struct();
    for f=figIndexes
        handles.figStruct(f).positions = unique([Data{find([Data{:,2}]==f),3}]);
        handles.figStruct(f).figHandle = figure(f)
        
        for p = handles.figStruct(f).positions
            ax = axes('Parent',handles.figStruct(f).figHandle);
            handles.figStruct(f).axHandle(p) = subplot(handles.figStruct(f).positions(end),1,p,ax);
%             handles.figStruct(f).legend(p)   = Data(find([Data{:,2}]==f & [Data{:,3}]==p),1)';
            handles.figStruct(f).title                = 'Title';
%             handles.figStruct(f).yLabel(p)   = 'YLabel';
            
            grid(handles.figStruct(f).axHandle(p),'minor');
            hold(handles.figStruct(f).axHandle(p),'on');
            set(handles.figStruct(f).axHandle(p),'xtick',[]);
            set(handles.figStruct(f).axHandle(p),'xticklabel',[]);
        end
        linkaxes(handles.figStruct(f).axHandle,'x');
        xticks(handles.figStruct(f).axHandle(end),'auto');
        xticklabels(handles.figStruct(f).axHandle(end),'auto');
        xlabel(handles.figStruct(f).axHandle(end),'Time (s)');
        xlim(handles.figStruct(f).axHandle(end), [handles.iT,handles.fT]);
    end
        
    for i=1:size(Data,1)
        plot(handles.figStruct(Data{i,2}).axHandle(Data{i,3}),... % Axe handle
             handles.time,getfield(handles.logData,Data{i,1}),...
                          'LineWidth',handles.LW);
    end
    
    for f=figIndexes
        for p = handles.figStruct(f).positions
            legend(handles.figStruct(f).axHandle(p),Data(find([Data{:,2}]==f & [Data{:,3}]==p),1)',...
                   'Interpreter', 'none');
        end
    end
    
    guidata(hObject,handles); % Save handles

% --- Executes on button press in Sort.
function Sort_Callback(hObject, eventdata, handles)
    PreviousTab = get(handles.VarTab,'data');
    NewTab      = sortrows(PreviousTab,[2 3]);
    
%     receivedData = get(handles.VarTab,'data');
%     Data     = sortrows(receivedData,[2 3]);
%     
%     % Avoid jumps in figure/position indexes (ex : [1 1 3 4] -> [1 1 2 3])
% 
%     
%     figJumpDiff      = diff([0;[Data{:,2}]']);
%     posJumpDiff      = diff([0;[Data{:,3}]']);
%     
%     for f = find(figJumpDiff>0)'
%         Data{f,3}      = 1;
%     end
%     
%     for f1 = find(figJumpDiff>1)'
%         for f2 = [f1:size(Data(:,2))]
%             Data{f2,2} = Data{f2,2} - figJumpDiff(f1);
%         end
%     end
%     
%     for p1 = find(posJumpDiff>1)'
%         for p2 = [p1:size(Data(:,3),1)]
%             Data{p2,3} = Data{p2,3} - posJumpDiff(p1)+1;
%         end
%     end
    
    set(handles.VarTab,'data',NewTab);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Sort.
function Sort_ButtonDownFcn(hObject, eventdata, handles)



function LineWidth_Callback(hObject, eventdata, handles)
    handles.LW = uint8(str2num(get(hObject,'String')));
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function LineWidth_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String','1');
    handles.LW = 1;
    guidata(hObject,handles);



function Search_Callback(hObject, eventdata, handles)
    Search = get(hObject,'String');
    Index = find(contains(handles.variables,Search,'IgnoreCase',true));
    newVariables = handles.variables(Index);
    set(handles.VarList,'Value',1);
    set(handles.VarList,'String',sort(newVariables));



% --- Executes during object creation, after setting all properties.
function Search_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'String',[]);


% --- Executes on button press in NextPos.
function NextPos_Callback(hObject, eventdata, handles)
    SelectedVar = get(handles.VarList,'Value');
    VarList     = get(handles.VarList,'String');

    PreviousData = get(handles.VarTab,'data');
    NbCell  = size(PreviousData);
    NbData = NbCell(1);
    if NbData(1)>0
        PreviousList = PreviousData(:,1);
        LastVarFig   = cell2mat(PreviousData(NbData(1),2));
        LastVarPos   = cell2mat(PreviousData(NbData(1),3));
    else
        PreviousList = [];
        LastVarFig   = 1;
        LastVarPos   = 1;
    end
    NewVars = {VarList{SelectedVar,:}};
    DiffVars = setdiff(NewVars',PreviousList);
    DiffData = [];
    for i=1:length(DiffVars)
        DiffData{i,1} = DiffVars{i};
        DiffData{i,2} = LastVarFig;
        DiffData{i,3} = LastVarPos+1;
    end

    if length(PreviousData)<1
        NewTab = DiffData;
    else
        NewTab = [PreviousData
                  DiffData];
    end
    set(handles.VarTab,'data',sortrows(NewTab,[2 3]));

% --- Executes on button press in NextFig.
function NextFig_Callback(hObject, eventdata, handles)
    SelectedVar = get(handles.VarList,'Value');
    VarList     = get(handles.VarList,'String');

    PreviousData = get(handles.VarTab,'data');
    NbCell  = size(PreviousData);
    NbData = NbCell(1);
    if NbData(1)>0
        PreviousList = PreviousData(:,1);
        LastVarFig   = cell2mat(PreviousData(NbData(1),2));
        LastVarPos   = cell2mat(PreviousData(NbData(1),3));
    else
        PreviousList = [];
        LastVarFig   = 1;
        LastVarPos   = 1;
    end
    NewVars = {VarList{SelectedVar,:}};
    DiffVars = setdiff(NewVars',PreviousList);
    DiffData = [];
    for i=1:length(DiffVars)
        DiffData{i,1} = DiffVars{i};
        DiffData{i,2} = LastVarFig+1;
        DiffData{i,3} = 1;
    end

    if length(PreviousData)<1
        NewTab = DiffData;
    else
        NewTab = [PreviousData
                  DiffData];
    end
    set(handles.VarTab,'data',sortrows(NewTab,[2 3]));


% --- Executes on selection change in Preset.
function Preset_Callback(hObject, eventdata, handles)
    val = get(hObject,'Value');
    str = get(hObject,'String');
    EnvTestDirectory = evalin('base','currentEnvTestDirectory');
    try
        cd([EnvTestDirectory '\GUI']);
        load VariablesSets;
        cd(EnvTestDirectory);
        nbSets = length(VariablesSets);
        data = [];
        for i=1:nbSets
            if isequal(cell2mat(str(val)),VariablesSets(i).name)
                data = VariablesSets(i).data;
            end
        end
        set(handles.VarTab,'data',data);
    end


% --- Executes during object creation, after setting all properties.
function Preset_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
%     EnvTestDirectory = evalin('base','currentEnvTestDirectory');
%     try
%         cd([EnvTestDirectory '\GUI']);
%         load VariablesSets;
%         cd(EnvTestDirectory);
%         nbSets = length(VariablesSets);
%         str = {};
%         for i=1:nbSets
%             str{i} = VariablesSets(i).name;
%         end
%         set(hObject,'string',str);
%     end

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
    handles.VariableSetName = VariableSetSave;
    EnvTestDirectory = evalin('base','currentEnvTestDirectory');
    try
        cd([EnvTestDirectory '\GUI']);
        load VariablesSets
        last = length(VariablesSets);
    catch
        last = 0;
    end
    VariablesSets(last+1).name = handles.VariableSetName;
    VariablesSets(last+1).data = get(handles.VarTab,'data');
    save('VariablesSets','VariablesSets');
    cd(EnvTestDirectory);
    Preset_CreateFcn(handles.Preset, eventdata, handles);


% --- Executes on button press in DeletePreset.
function DeletePreset_Callback(hObject, eventdata, handles)
    confirm = DeleteSet_gui;
    EnvTestDirectory = evalin('base','currentEnvTestDirectory');
    if isequal(confirm,'Yes')
        val = get(handles.Preset,'Value');
        str = get(handles.Preset,'String');
        newStr = {};
        try
            cd([EnvTestDirectory '\GUI']);
            load VariablesSets
            cd(EnvTestDirectory);
            VariablesSets(val) = [];
            str{val} = [];
            set(handles.Preset,'Value',1);
            set(handles.Preset,'String',str);
            save('VariablesSets','VariablesSets');
        end
    end

% --- Executes on button press in Add2Plot.
function Add2Plot_Callback(hObject, eventdata, handles)

% --- Executes on selection change in LogsList.
function LogsList_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function LogsList_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    set(hObject,'max',100,'min',0);
    set(hObject,'Value',[]);

% --- Executes on button press in browseButton.
function browseButton_Callback(hObject, eventdata, handles)
scriptPath = pwd;
run('initParams');
handles.logPath = getTestPath(initPath);
set(handles.pathTextBox,'string',handles.logPath);

% update logs pop up menu
handles.logFiles    = filesearch(handles.logPath,'mat',0);
str = {};
for l = 1:length(handles.logFiles)
    str{l} = handles.logFiles(l).name;
end
set(handles.logsPopUpMenu,'value',1);
set(handles.logsPopUpMenu,'string',str);


guidata(hObject,handles);
% hObject    handle to browseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function pathTextBox_Callback(hObject, eventdata, handles)
% hObject    handle to pathTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathTextBox as text
%        str2double(get(hObject,'String')) returns contents of pathTextBox as a double


% --- Executes during object creation, after setting all properties.
function pathTextBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathTextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in editPlot.
function editPlot_Callback(hObject, eventdata, handles)
% hObject    handle to editPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'figStruct')
    for f=1:length(handles.figStruct)
        questions           = {};
        defaultNames        = {};
        titleQuestinon      = sprintf('Title of the figure %d',f);
        questions{1}        = titleQuestinon;
        defaultNames{1}     = sprintf('Title %d',f);
        for p=handles.figStruct(f).positions
            questions{p+1}      = sprintf('Y-label of Axe %d',p);
            defaultNames{p+1}     = sprintf('Y%d',p);
        end
        inPutUser = inputdlg(questions,'Edit Plot',[1 100],defaultNames);
        title(handles.figStruct(f).axHandle(1),inPutUser(1));
        for p=handles.figStruct(f).positions
            ylabel(handles.figStruct(f).axHandle(p),inPutUser(p+1));
        end
    end
end