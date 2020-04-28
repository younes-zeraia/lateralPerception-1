% This function is intended to save a loaded capsule (whether it has been
% modified or not).
function handles = saveCapsule(handles)
    global logSaved
    
    savingMsgBox = msgbox('Saving...');
    capsulePath = handles.canapeTaggingPath;
    capsuleName = handles.logCAN(handles.NumCapsule).name;
    if isfield(handles,'loadedLog') % Save the loaded log if it has already been modified
        loadedLog = handles.loadedLog;
        if ~exist(capsulePath,'dir')
            mkdir(capsulePath);
        end
        save(fullfile(capsulePath,capsuleName),'-struct','loadedLog');
    end
    logSaved = 1; % Indicates that the current log has been saved
    
    try
        delete(savingMsgBox);
    end
end