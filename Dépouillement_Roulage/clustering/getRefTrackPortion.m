% This function is intended to find the specific portion of a reference
% track on which the current capsule has been recorded
% It take account of the first and last gps position of the capsule.

% If both positions are in the same portion, the portion name is returned
% Else it returns the original track name (e.g : HOD).

function trackPortion = getRefTrackPortion(posLat,posLon,trackName)
    isNotNan = find(~isnan(posLat) & ~isnan(posLon));
    trackPortion = trackName;
    if size(isNotNan,1)>1 % hopefully we found more than 2 gps positions
        
        switch trackName
            case 'HOD'
                trackDB = load('gpsHOD.mat');
            otherwise
                error(sprintf('Unknown track : "%s" !',trackName));
        end
        [xLog,yLog,utmZone] = deg2utm(posLat(isNotNan([1 end])),posLon(isNotNan([1 end])));
        
        iGPS = coordMatching(xLog,yLog,trackDB.xGPS,trackDB.yGPS);
        
        if trackDB.indexes(iGPS(1)) == trackDB.indexes(iGPS(2)) % the beginning and the end of the capsule are in the same portion (same index)
            if mod(trackDB.indexes(iGPS(1)),1)==0
                trackPortion = trackDB.parts{trackDB.indexes(iGPS(1))};
            end
        end
        
    else
        fprintf('\n No reliable gps positions : Can"t determine the track portion ! \n');
    end