% imageCalibRightName = 'VBOXHD_Right_0224.jpg';
%% variable parameters
% Choose which side of the lines should be "numerized"
% LineSide = 0 : Interior edge / LineSide = 1 : line middle / LineSide = 2 : Exterior edge
lineSide = 0;

%% paths
currScriptPath = pwd;
functionPath = fullfile(scriptPath,'..','functions');
addpath(functionPath);
run('initParams');
testPath = getTestPath(initPath);
imProcessPath = fullfile(testPath,logsConvFolderName,imProcessFolderName);
canapePath = fullfile(testPath,logsConvFolderName,canapeFolderName);
%% load files
lineDataFiles = filesearch(imProcessPath,'mat',0);
canapeFiles  = filesearch(canapePath,'mat',0);

%% Loop
for f = 1:length(lineDataFiles)
    fileName = lineDataFiles(f).name;
    lineData = load(fullfile(imProcessPath,fileName));
    canape   = load(fullfile(canapePath,fileName));
    
    %% Find out if RT Lat/Lon/Heading are available
    %% First, try PPK "Combined" results
    fprintf('\n ... Processing %s ... \n',fileName(1:end-4));
    
    rtGPSFound          = false;
    rtGPSCombinedFound  = false;
    rtGPSSimulatedFound = false;
    
    rtCombinedLatFound = isfield(canape,'PosLatCOMBINED');
    rtCombinedLonFound = isfield(canape,'PosLonCOMBINED');
    rtCombinedHeadingFound = isfield(canape,'AngleHeadingCOMBINED');
    
    rtSimulatedLatFound = isfield(canape,'PosLatSIMULATED');
    rtSimulatedLonFound = isfield(canape,'PosLonSIMULATED');
    rtSimulatedHeadingFound = isfield(canape,'AngleHeadingSIMULATED');
    
    rtLatFound = isfield(canape,'PosLat');
    rtLonFound = isfield(canape,'PosLon');
    rtHeadingFound = isfield(canape,'AngleHeading');
    
    if rtCombinedLatFound && rtCombinedLonFound && rtCombinedHeadingFound
        rtGPSCombinedFound = true;
        fprintf('\n \t *** \t Combined PPK RT GPS results found ! \t *** \n');
    else
        fprintf('\n \t *** \t No Combined PPK RT GPS results found ! \t *** \n');
    end
    
    if rtSimulatedLatFound && rtSimulatedLonFound && rtSimulatedHeadingFound
        rtGPSSimulatedFound = true;
        fprintf('\n \t *** \t Simulated PPK RT GPS results found ! \t *** \n');
    else
        fprintf('\n \t *** \t No Simulated PPK RT GPS results found ! \t *** \n');
    end
    
    if rtLatFound && rtLonFound && rtHeadingFound
        rtGPSFound = true;
        fprintf('\n \t *** \t RT GPS signals found ! \t *** \n');
    else
        fprintf('\n \t *** \t NO RT GPS signals found ! \t *** \n');
    end
    
    %% Vid/Can synchronisation
    tCan = canape.t;
    tVbo = [0:1/fVbo:length(tCan)/fCan]';
    nVid = size(lineData.yLeftInt,1);
    tVid = [0:1/fVid:(nVid-1)/fVid]';

    tMin = min(tCan(end),tVid(end));

    indCan = find(tCan<=tMin);
    indVid = find(tVid<=tMin);
    
    if ~rtGPSFound && ~rtGPSCombinedFound && ~rtGPSSimulatedFound
        fprintf('\n \t *** \t Use VBO Lat/Lon/Heading for lines coordinates computation \t *** \n');
        
        latVbo = interp1(tCan,canape.Latitude,tVbo);
        lonVbo = interp1(tCan,canape.Longitude,tVbo);
        yawVbo = interp1(tCan,canape.Heading,tVbo);

        latVid = interp1(tVbo,latVbo,tVid);
        lonVid = interp1(tVbo,lonVbo,tVid);
        yawVid = interp1(tVbo,yawVbo,tVid);

        lat = latVid(indVid)./60;
        lon = lonVid(indVid)./(-60);
        yaw = -yawVid(indVid)./180*pi+1.55;
    else
        if ~rtGPSCombinedFound && ~rtGPSSimulatedFound
            fprintf('\n \t *** \t Use Raw RT Lat/Lon/Heading for lines coordinates computation \t *** \n');

            isNotNAN = find(~isnan(canape.PosLat) & ~isnan(canape.PosLon) & ~isnan(canape.AngleHeading));
            
            tMin = min(tCan(isNotNAN(end)),tVid(end));

            indCan = find(tCan(isNotNAN)<=tMin);
            indVid = find(tVid<=tMin);
            
            tCanInterp = [tVid(1);tCan(isNotNAN);tVid(end)];
            latInterp = [canape.PosLat(isNotNAN(1));canape.PosLat(isNotNAN);canape.PosLat(isNotNAN(end))];
            lonInterp = [canape.PosLon(isNotNAN(1));canape.PosLon(isNotNAN);canape.PosLon(isNotNAN(end))];
            yawInterp = [canape.AngleHeading(isNotNAN(1));canape.AngleHeading(isNotNAN);canape.AngleHeading(isNotNAN(end))];
            
            [tCanInterpUnique indUnique] = unique(tCanInterp);
            
            latVid = interp1(tCanInterpUnique,latInterp(indUnique),tVid);
            lonVid = interp1(tCanInterpUnique,lonInterp(indUnique),tVid);
            yawVid = interp1(tCanInterpUnique,yawInterp(indUnique),tVid);
            
        elseif ~rtGPSSimulatedFound
            fprintf('\n \t *** \t Use Combined PPK RT Lat/Lon/Heading for lines coordinates computation \t *** \n');
            
            isNotNAN = find(~isnan(canape.PosLatCOMBINED) & ~isnan(canape.PosLonCOMBINED) & ~isnan(canape.AngleHeadingCOMBINED));
            
            tMin = min(tCan(isNotNAN(end)),tVid(end));

            indCan = find(tCan(isNotNAN)<=tMin);
            indVid = find(tVid<=tMin);
            
            latVid = interp1(tCan(isNotNAN),canape.PosLatCOMBINED(isNotNAN),tVid);
            lonVid = interp1(tCan(isNotNAN),canape.PosLonCOMBINED(isNotNAN),tVid);
            yawVid = interp1(tCan(isNotNAN),canape.AngleHeadingCOMBINED(isNotNAN),tVid);
            
        else
            fprintf('\n \t *** \t Use Simulated PPK RT Lat/Lon/Heading for lines coordinates computation \t *** \n');

            isNotNAN = find(~isnan(canape.PosLatSIMULATED) & ~isnan(canape.PosLonSIMULATED) & ~isnan(canape.AngleHeadingSIMULATED));
            
            tMin = min(tCan(isNotNAN(end)),tVid(end));

            indCan = find(tCan(isNotNAN)<=tMin);
            indVid = find(tVid<=tMin);
            
            latVid = interp1(tCan(isNotNAN),canape.PosLatSIMULATED(isNotNAN),tVid);
            lonVid = interp1(tCan(isNotNAN),canape.PosLonSIMULATED(isNotNAN),tVid);
            yawVid = interp1(tCan(isNotNAN),canape.AngleHeadingSIMULATED(isNotNAN),tVid);
        end
        
        lat = latVid(indVid);
        lon = lonVid(indVid);
        yaw = -yawVid(indVid)./180*pi+pi/2;
    end
%% GPS antenna position (World reference) (meters)
    isNotNan = find(~isnan(lat) & ~isnan(lon) & ~isnan(yaw));
    [xGPS yGPS utZone] = deg2utm(lat(isNotNan),lon(isNotNan));
    yaw                 = yaw(isNotNan);
    % Xgps_m = Xgps_m+0.2516; % Offset gps error
    % Ygps_m = Ygps_m-0.5960; % Offset gps error
%     yaw = estimateHeading(xGPS,yGPS);
    for i=1:length(yaw)
        if yaw(i)>pi
            yaw(i) = yaw(i)-2*pi;
        elseif yaw(i)<-pi
            yaw(i) = yaw(i)+2*pi;
        end
    end
    if rtGPSFound
        yaw = estimateHeading(xGPS,yGPS);
    else
        estimatedYaw = estimateHeading(xGPS,yGPS);
        yaw          = yaw - mean(yaw(100:end-99)) + mean(estimatedYaw(100:end-99));
    end
    
    lineData.yLeftInt = interp1(tVid(indVid),lineData.yLeftInt(indVid),tVid(indVid));
    lineData.yRightInt = interp1(tVid(indVid),lineData.yRightInt(indVid),tVid(indVid));
    lineData.yLeftExt = interp1(tVid(indVid),lineData.yLeftExt(indVid),tVid(indVid));
    lineData.yRightExt = interp1(tVid(indVid),lineData.yRightExt(indVid),tVid(indVid));
%% Wheels position compared to gps antenna (Vehicle reference) (meters)
    if rtGPSFound
        xWhL_m = xWhL_RT_m;
        xWhR_m = xWhR_RT_m;

        yWhL_m = yWhL_RT_m;
        yWhR_m = yWhR_RT_m;
    else
        xWhL_m = xWhL_VBO_m;
        xWhR_m = xWhR_VBO_m;

        yWhL_m = yWhL_VBO_m;
        yWhR_m = yWhR_VBO_m;
    end
    %% Lines positions compared to wheels (Vehicle reference) (meters)
    lines.offsetLineLeft  = lineData.yLeftInt./1000+VehWidth/2;
    lines.offsetLineRight = lineData.yRightInt./1000-VehWidth/2;
    lines.lineWidthLeft   = abs(lineData.yLeftExt-lineData.yLeftInt)./1000;
    lines.lineWidthRight  = abs(lineData.yRightExt-lineData.yRightInt)./1000;
    
    switch lineSide
        case 0
            yLineL2W_m = lineData.yLeftInt./1000;
            yLineR2W_m = lineData.yRightInt./1000;
        case 1
            yLineL2W_m = (lineData.yLeftInt+lineData.yLeftExt)./2000;
            yLineR2W_m = (lineData.yRightInt+lineData.yRightExt)./2000;
        case 2
            yLineL2W_m = lineData.yLeftExt./1000;
            yLineR2W_m = lineData.yRightExt./1000;
    end

    xLineL2W_m = 0;
    xLineR2W_m = 0;

    %% Lines positions compared to GPS antenna (Vehicle reference) (meters)
    yLinesL_m = yWhL_m + yLineL2W_m;
    yLinesR_m = yWhR_m + yLineR2W_m;

    xLinesL_m = yLinesL_m.*0+xWhL_m;
    xLinesR_m = yLinesR_m.*0+xWhR_m;

    yFrCam_m  = yLinesL_m.*0 + VehWidth/2 + yWhR_m;
    xFrCam_m  = xLinesL_m.*0 + xWhL_m+1;
    %% Lines Positions compared to GPS antenna (World reference) (meters)
    XLinesL_m = xLinesL_m.*cos(yaw)-yLinesL_m.*sin(yaw);
    YLinesL_m = xLinesL_m.*sin(yaw)+yLinesL_m.*cos(yaw);

    XLinesR_m = xLinesR_m.*cos(yaw)-yLinesR_m.*sin(yaw);
    YLinesR_m = xLinesR_m.*sin(yaw)+yLinesR_m.*cos(yaw);
    
    XVeh_m    = xFrCam_m.*cos(yaw)-yFrCam_m.*sin(yaw);
    YVeh_m    = xFrCam_m.*sin(yaw)+yFrCam_m.*cos(yaw);

    %% Lines Positions (World reference) (meters)
    lines.xLineLeft      = XLinesL_m + xGPS;
    lines.yLineLeft      = YLinesL_m + yGPS;

    lines.xLineRight      = XLinesR_m + xGPS;
    lines.yLineRight      = YLinesR_m + yGPS;
    
    lines.xVehicle            = XVeh_m + xGPS;
    lines.yVehicle            = YVeh_m + yGPS;
    
    lines.vehHeading          = yaw;
    lines.leftLineType        = lineData.leftLineType(indVid);
    lines.rightLineType       = lineData.rightLineType(indVid);
    
    %% Saves Vehicle and lines coordinates
    if ~exist(fullfile(imProcessPath,lineXYCoordFolderName),'dir');
        mkdir(fullfile(imProcessPath,lineXYCoordFolderName));
    end
    cd(fullfile(imProcessPath,lineXYCoordFolderName));
    save(fileName,'-struct','lines');
    cd(currScriptPath);
    clear lines
end
