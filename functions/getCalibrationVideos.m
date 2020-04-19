function  [TestPath leftVideo rightVideo] = getLogs()
    TestPath =  uigetdir ('C:\Users\a029799\Desktop\Perception_Laterale\2_Essais', 'Records directory selection') ;
    if (TestPath == 0)
        msgbox('Resim process cancelled', 'Escape', 'error', 'modal') ;
        return
    end ;
    leftVideo =  uigetfile(fullfile(TestPath,'*.avi;*.mp4'), 'Selection de la vidéo de calibration gauche', 'MultiSelect', 'off', TestPath) ;
    if isempty(leftVideo);
        msgbox('Calibration process cancelled', 'Escape', 'error', 'modal') ;
        return
    end ;
    
    rightVideo =  uigetfile(fullfile(TestPath,'*.avi;*.mp4'), 'Selection de la vidéo de calibration droite', 'MultiSelect', 'off', TestPath) ;
    if isempty(rightVideo);
        msgbox('Calibration process cancelled', 'Escape', 'error', 'modal') ;
        return
    end ;
end