function  [TestPath filesList] = getLogs()
    TestPath =  uigetdir ('C:\Users\a029799\Desktop\Perception_Laterale\2_Essais', 'Records directory selection') ;
    if (TestPath == 0)
        msgbox('Resim process cancelled', 'Escape', 'error', 'modal') ;
        return
    end ;
    InputFiles =  uigetfile(fullfile(TestPath,'*.avi;*.mp4'), 'Selection des fichiers video d''acquisitions', 'MultiSelect', 'on', TestPath) ;
    if isempty(InputFiles);
        msgbox('Resim process cancelled', 'Escape', 'error', 'modal') ;
        return
    end ;
    if iscell(InputFiles)==1;
        filesList = cell2struct(InputFiles, 'name', 1);
    else
        filesList = struct('name', InputFiles);
    end
end