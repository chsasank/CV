function [ Hest ] = fitHomography( imfile1,imfile2,algorithm )
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
[T,p1,p2] = evalc('match(imfile1,imfile2);');
close all
if strcmp(algorithm, 'leastsquares')
    Hest =  leastSquaresHomography( p1, p2 );
else
    Hest = ransacfithomography(p1,p2,0.005);
end

Hest = Hest/Hest(3,3);

end
