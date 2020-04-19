function  [LogsPath] = getTestPath(testPath)
    LogsPath =  uigetdir (testPath, 'Records directory selection') ;
    if (LogsPath == 0)
        msgbox('Classification process cancelled', 'Escape', 'error', 'modal') ;
        return
    end ;
end

