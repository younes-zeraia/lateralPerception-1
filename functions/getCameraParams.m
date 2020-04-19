function [cameraParams R t] = getCameraParams(calibrationFramesFolder,CamName,nImagRef,squareSize)
    initPath = pwd;
    cd(calibrationFramesFolder);
    imageFiles = dir('*.jpg');
    for i=1:length(imageFiles)
        imageFileNames{i} = imageFiles(i).name;
    end

    % Detect checkerboards in images
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
    imageFileNames = imageFileNames(imagesUsed);

    % Read the first image to obtain image size
    originalImage = imread(imageFileNames{1});
    [mrows, ncols, ~] = size(originalImage);

    % Generate world coordinates of the corners of the squares
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);

    % Calibrate the camera
    [cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
        'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
        'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
        'ImageSize', [mrows, ncols]);
    imOrig = imread(imageFileNames{nImagRef});
    [imUndistorted newOrigins] = undistortImage(imOrig,cameraParams);
    
%     [imagePoints, boardSize] = detectCheckerboardPoints(imUndistorted);
%     imagePoints = imagePoints + newOrigins;
    intrinsincts = cameraParams.Intrinsics;
    [R t]       = extrinsics(imagePoints,worldPoints,intrinsincts);
    cd([calibrationFramesFolder '\..\..']);
    if ~exist('camParams','dir')
        mkdir('camParams');
    end
    cd([calibrationFramesFolder '\..\..\camParams']);
    save(CamName,'cameraParams','R','t');
    cd(initPath);
end
