% This function is intended to rewrite the contextual videos with the
% fusion Time stamp

function addTimeStamp(listVContextFile,newContextPath,listCanFile,signalName)

    % Load Files
    wb = waitbar(0,'Starting...','Name','Add Fusion Time Stamp');
    set(findall(wb),'Units', 'normalized');
    % Change the size of the figure
    set(wb,'Position', [0.35 0.46 0.3 0.08]);
    wb.Children.Title.Interpreter = 'none';
    for i = 1:length(listVContextFile)
        video = VideoReader(fullfile(listVContextFile(i).path,listVContextFile(i).name));
        newVideo = VideoWriter(fullfile(newContextPath,listVContextFile(i).name));
        waitbar((i-1)/length(listVContextFile),wb,listVContextFile(i).name);
        newVideo.FrameRate = video.FrameRate;
        open(newVideo);
        log   = load(fullfile(listCanFile(i).path,listCanFile(i).name));
        tVid  = [0:1/video.FrameRate:video.Duration]';
        timeStamp = getfield(log,signalName);
        timeStampVideo = interp1(log.t,timeStamp,tVid);
        k = 1;
        positionTime = [video.Width/2-125,video.Height-65];
        while video.hasFrame
            currIm = readFrame(video);
            if ~isnan(timeStampVideo(k))
                currImTime = insertText(currIm,positionTime,round(timeStampVideo(k)),'Fontsize',40,'BoxOpacity',0.8,'Font','LucidaSansRegular');
                writeVideo(newVideo,currImTime);
            end
            k = k+1;
            if mod(k,round(video.FrameRate))==0
                fprintf('*** %2.2f s elapsed out of %2.2f s. ***\n',k/round(video.FrameRate),video.Duration);
            end
        end
        close(newVideo);
    end
    
    close(wb);
end