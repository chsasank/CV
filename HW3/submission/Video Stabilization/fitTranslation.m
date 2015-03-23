function [ Hest ] = fitTranslation( imfile1,imfile2,algorithm )
%fitHomography fits a homography between im1 and im2 using algoritm specified
%   algorithm can be 'ransac' or 'leastsquares'

if(nargin == 2)
    algorithm = 'ransac';
end

if ischar(imfile1) ~= 1
    imwrite(imfile1,'temp1.jpg');
    imfile1 = 'temp1.jpg';
end
if ischar(imfile2) ~= 1
    imwrite(imfile2,'temp2.jpg');
    imfile2 = 'temp2.jpg';
end
im1 = imread(imfile1);
im2 = imread(imfile2);

%% Estimate homography between two images
[p1,p2] = match(imfile1,imfile2);
close all
if strcmp(algorithm, 'leastsquares')
    t = mean(p2-p1,2);
    Hest = eye(3);
    Hest(1,3) = t(1);
    Hest(2,3) = t(2);
else
    Hest = ransacfittranslation(p1,p2,0.005);
end

Hest = Hest/Hest(3,3);

end
