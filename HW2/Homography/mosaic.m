function [ imnew ] = mosaic( imfile1,imfile2 )
%% mosaic( imfile1,imfile2 ) creates mosaic of image imfile1 and image imfile2
%   imfile1 & imfile2 are image file names. Uses imfile 2 as base and 
%   warps imfile 1 to fit around it.
%

%% Estimate homography between two images
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

h = waitbar(0,'Matching images. Please wait...');
[p1,p2] = match(imfile1,imfile2);
close all
Hest = ransacfithomography(p1,p2,0.005);
Hest = Hest/Hest(3,3);

%% Compute corners of 1st image in 2nd image cordinate system
m = size(im2,1);
n = size(im2,2);
Hinv = inv(Hest);

ij = [[1;1],[1;n],[m;1],[m;n]];
ij(3,:) = ones(1,size(ij,2));
Cij = Hest*ij;
Cij = Cij./repmat(Cij(3,:),3,1);
Cij = Cij(1:2,:);
Cij = round(Cij);

x_maxcorner = max(Cij(1,:));
x_mincorner = min(Cij(1,:));
y_maxcorner = max(Cij(2,:));
y_mincorner = min(Cij(2,:));

%% Create new blank image using corner information
x_min = min(1,x_mincorner);
x_max = max(m,x_maxcorner);
y_min = min(1,y_mincorner);
y_max = max(n,y_maxcorner);


if x_mincorner < 1
    x_newfirstpixel = -x_mincorner+1;
else
    x_newfirstpixel = 0;
end

if y_mincorner < 1
    y_newfirstpixel = -y_mincorner+1;
else
    y_newfirstpixel = 0;
end

imnew = zeros(x_max-x_min,y_max-y_min,'uint8');
%% Start mosaicing
waitbar(0.2,h,'Mosaicing. Please wait...');
for i = 1:size(imnew,1)
    for j = 1:size(imnew,2)
        x = i - x_newfirstpixel;
        y = j - y_newfirstpixel;
        
        % if current x,y is out of bounds of second image, just ignore it.
        if  (x<1) || (x>size(im2,1)) || (y<1) || (y>size(im2,2))
            R = Hinv*[x;y;1];
            R = round(R(1:2)/R(3))';
            if R > [0 0] 
                if R <= size(im1) 
                    imnew(i,j) = im1(R(1),R(2)); %bilinear interpolation
                end
            end
            
        % otherwise, i.e (x,y) is in bounds of second image
        else
            % just use second image data if no corresponding first image
            % data is available
            imnew(i,j) = im2(x,y);
            
%             % if available, do weighted averaging so as to look smooth
%             R = Hinv*[x;y;1];
%             R = round(R(1:2)/R(3))';
%             if R > [0 0] 
%                 if R <= size(im2) 
%                     imnew(i,j) = 0.8*im2(x,y)+0.2*im1(R(1),R(2)); %bilinear interpolation
%                 end
%             end
        end
    end
    waitbar(0.2+0.8*i/size(imnew,1),h)
end
%% Cleanup
close(h)
if ischar(imfile1) ~= 0
    evalc('delete temp1.jpg');
end
if ischar(imfile2) ~= 0
    evalc('delete temp2.jpg');
end

end

