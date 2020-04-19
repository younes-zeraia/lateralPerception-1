function [DTLE_detected LineWidth_detected] = detectLineTopView(videosFolder,videoName,cropWindow,pointWheel_px,camParams,RotMatrix,TransMatrix,ThresholdCoef,resizeWindow)
    % This script intends to detect lines from "Top wheels" Point of view
    Ry180       = [-1 0 0; 0 1 0;0 0 -1];
    Rzminus90   = [ 0 1 0;-1 0 0;0 0  1];
    RotMat     = Rzminus90'*Ry180*RotMatrix;
    TransMat   = TransMatrix;
    pointWheel_mm = pointsToWorld(camParams,RotMat,TransMat,[pointWheel_px(1) pointWheel_px(2)]);
    %% Path
    initPath     = pwd;
    functionPath = [initPath '\functions'];
    addpath(functionPath);
   
    %%
    cd(videosFolder);
    video = VideoReader(videoName);
    cd(initPath);
    % 
    % ax1 = subplot(2,2,1);
    % ax2 = subplot(2,2,2);
    % ax3 = subplot(2,2,3);
    % ax4 = subplot(2,2,4);
    l = 1;
    alpha = 0.9999;
    tic
    threshWhite = [255 255 255];
    LineWidth_detected  = zeros(video.NumFrames,1);
    DTLE_detected       = zeros(video.NumFrames,1);
    level = 0.6735;
    dtle = 0;
    lineWidth = 0;
    
    
    windowSize = 10;
    kernel = ones(windowSize) / windowSize ^ 2;
    while video.hasFrame
        I1 = readFrame(video);
        I2 = imcrop(I1,cropWindow);
        I3 = imresize(I2,resizeWindow);
        I4 = undistortImage(I3,camParams);

        I5 = (I4(:,:,1)>(threshWhite(1)*level*ThresholdCoef) |...
              I4(:,:,2)>(threshWhite(2)*level*ThresholdCoef) |...
              I4(:,:,3)>(threshWhite(3)*level*ThresholdCoef));
        
        
        I6 = imerode(I5,strel('rectangle',[1 10]));
        I7 = bwareaopen(I6,1000);
        I8 = imdilate(I7,strel('rectangle',[1 10]));
        I9 = conv2(single(I8), kernel, 'same') > 0.5; % Rethreshold
        I10 = edge(I9,'canny');
%         I11 = imdilate(I10,strel('disk',3));
%         I12 = bwmorph(I11,'thin',inf);
        I13 = imerode(I10,strel('line',3,0));
        I14 = imdilate(I13,strel('line',10,0));
        I15 = bwareaopen(I14,40);
        I16 = imdilate(I15,strel('disk',1));
        I17 = bwmorph(I16,'thin',inf);
        I18 = bwareafilt(I17,2);
        I19 = bwlabel(I18);
        if l==1
            figure;
        end
        imshow(I18);hold on
        [H,T,R] = hough(I18,'Theta',[[-90:0.1:-60] [60 : 0.1 : 89.9]]);
        P = houghpeaks(H,20,'threshold',0.3*max(H(:)));
        lines = houghlines(I18,T,R,P);
        if size(P,1)>1
    %     lines = houghlines(I6,T,R,P);
            rhos    = R(P(:,1))';
            thetas  = T(P(:,2))';

            [rhosSortedabs indSorted] = sort(abs(rhos));

            [maxDiffRhos indMaxDiff] = max(diff(rhosSortedabs));

            thetasSorted = thetas(indSorted);
            rhosSorted   = rhos(indSorted);

            rhos1    = rhosSorted(1:indMaxDiff);
            rhos2    = rhosSorted(indMaxDiff+1:end);
            thetas1  = thetasSorted(1:indMaxDiff);
            thetas2  = thetasSorted(indMaxDiff+1:end);
            signRhos1= sign(mean(rhos1));
            signRhos2= sign(mean(rhos2));
%             signThet1= sign(mean(thetas1));
%             signThet2= sign(mean(thetas2));
            signThet1 = signRhos1;
            signThet2 = signRhos2;
            
            rhos     = [signRhos1*mean(abs(rhos1));    signRhos2*mean(abs(rhos2))];
            thetas   = [signThet1*mean(abs(thetas1));  signThet2*mean(abs(thetas2))];
            
            s_theta = sind(thetas);
            c_theta = cosd(thetas);

            % Lines coordinates in pixels
            x0 = ones(2,1).*1;
            xn = ones(2,1).*size(I4,2);

            y0 = rhos./s_theta;
            yn = y0-(xn-x0).*c_theta.*[signThet1;signThet2];
            pointsLine1_px = [x0(1) y0(1)
                              xn(1) yn(1)];
            pointsLine2_px = [x0(2) y0(2)
                              xn(2) yn(2)];
            pointsLines_mm = pointsToWorld(camParams,RotMat,TransMat,...    
                                           [pointsLine1_px;pointsLine2_px]);
            pointsLines_mm = pointsLines_mm-pointWheel_mm;

            beta   = atan2(pointsLines_mm([2 4],2)-pointsLines_mm([1 3],2),...
                        pointsLines_mm([2 4],1)-pointsLines_mm([1 3],1));
            c_beta = cos(beta);
            s_beta = sin(beta);
            ypp     = pointsLines_mm([1 3],2)-(s_beta./c_beta).*pointsLines_mm([1 3],1);
            xp      = -ypp.*c_beta.*s_beta;
            yp      = ypp.*(ones(2,1)-s_beta.^2);
            dist2Wheel    = ypp./c_beta;
            [dtle indMin] = min(dist2Wheel);
            lineWidth    = dist2Wheel(3-indMin)-dist2Wheel(indMin);
%             plot(pointsLine1_px(:,1),pointsLine1_px(:,2),'LineWidth',2,'color','green');
%             plot(pointsLine2_px(:,1),pointsLine2_px(:,2),'LineWidth',2,'color','green');
        end
        if l>1 && (lineWidth < 100 || lineWidth > 400) %no good detection
            DTLE_detected(l) = DTLE_detected(l-1);
            LineWidth_detected(l)   = LineWidth_detected(l-1);
        else
            DTLE_detected(l) = dtle;
            LineWidth_detected(l)   = lineWidth;
        end
%         if l>1
%             delete(h);
%         end
%         h(1) = plot(0, 0,'+r','LineWidth',2);
%         hold on
%         h(2) = plot(pointsLines_mm(1:2,1),pointsLines_mm(1:2,2),'LineWidth',2,'Color','black');
%         h(3) = plot(pointsLines_mm(3:4,1),pointsLines_mm(3:4,2),'LineWidth',2,'Color','black');
%         h(4) = plot([0;0],ypp,'+b','LineWidth',2);
%         h(5) = plot(xp,yp,'+g','LineWidth',2);
%         ylim([0 1000]);
%         xlim([-700 700]);
%         
%         
%         
%         
        pause(1/video.FrameRate);
        if rem(l,250)==0
            elapsedTime = toc;
            disp(sprintf('%d frames of the video processed in %4.2f sec',l,elapsedTime));
        end
        l = l+1;
    end
end