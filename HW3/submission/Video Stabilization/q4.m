clc;clear;
addpath(genpath('MatlabFns'))

%% Read Video
videoStruct = mmread('gbus_shaky_affine.avi');
nFrames = size(videoStruct.frames,2);

video = zeros( videoStruct.height, videoStruct.width, nFrames,'uint8');
for i  = 1:size(videoStruct.frames,2)
    video(:,:,i) = videoStruct.frames(i).cdata(:,:,1);
end

%% Estimate motion model
motionModel = zeros(3,3,nFrames-1);
h = waitbar(0,'Estimating Homographies. Please wait...');
for i = 1:nFrames-1
    motionModel(:,:,i) = fitHomography(video(:,:,i),video(:,:,i+1),'ransac');
    waitbar(0.7*1*i/nFrames,h)
end
%% Smooth the motion model
smoothMotionModel = zeros(3,3,nFrames-1);

filerWidth = 10;
w=gausswin(filerWidth);
w = w/sum(w);

for t = 1:nFrames-1
    for i = 1:3
        for j = 1:3
            smoothMotionModel(i,j,:) = conv(squeeze(motionModel(i,j,:)), w/sum(w),'same');
            if t <= filerWidth/2
                smoothMotionModel(i,j,t) = mean(motionModel(i,j,1:t+filerWidth/2),3);
            elseif t > nFrames - 1 - filerWidth/2
                smoothMotionModel(i,j,t) = mean(motionModel(i,j,t-filerWidth/2:nFrames - 1),3);
%             else
%                 smoothMotionModel(i,j,t) = mean(motionModel(i,j,t-filerWidth/2:t+filerWidth/2),3);
            end
        end
    end
end
figure
plot(squeeze(motionModel(1,3,:)))
hold on
plot(squeeze(smoothMotionModel(1,3,:)),'r')
title('tx')
figure
plot(squeeze(motionModel(2,3,:)))
hold on
plot(squeeze(smoothMotionModel(2,3,:)),'r')
title('ty')
%% Rewarp using warp
smoothVideo = video;

cummMotion = eye(3);
cummSmooth = eye(3);

for i = 2:nFrames
    waitbar(0.7+ 0.3*i/nFrames,h,'warping');
    cummMotion = motionModel(:,:,i-1)*cummMotion;
    cummSmooth = smoothMotionModel(:,:,i-1)*cummSmooth;
    
    smoothVideo(:,:,i) = warp(video(:,:,i),cummSmooth/cummMotion);
end
close(h)
%% 
vid = [video;smoothVideo];
filename = 'gbus_rigid_result.avi';
writevideo(filename,vid,videoStruct.rate);
%% 
croopedVideo = smoothVideo(5:videoStruct.height-10,5:videoStruct.width-10,:);
filename = 'gbus_rigid_smoothened.avi';
writevideo(filename,croopedVideo,videoStruct.rate);
disp('done')
beep;