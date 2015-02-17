clc; clear; close all

im1 = imread('test1.jpg');
im2 = imread('test_scaled.jpg');

[p1,p2] = match('test1.jpg','test_scaled.jpg');
Hest = ransacfithomography(p1,p2,0.005);
Hest = Hest/Hest(3,3);


im1 = imread('test1.jpg');
im2 = imread('test_scaled.jpg');
im3 = warp(im1,Hest);
imwrite(im3,'test1_H.jpg');

figure
subplot(1,3,1) 
imshow(im1)
subplot(1,3,2)
imshow(im2)
subplot(1,3,3)
imshow(im3)

%% Test warp
im1 = imread('test1.jpg');
im2 = imread('test_scaled.jpg');

A = im1;
m = size(A,1);
n = size(A,2);
Hinv = inv(Hest);

%% Compute corners of 1st image in 2nd image cordinate system
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

%%
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

h = waitbar(0,'please wait...');
for i = 1:size(imnew,1)
    for j = 1:size(imnew,2)
        x = i - x_newfirstpixel;
        y = j - y_newfirstpixel;
        if  (x<1) || (x>m) || (y<1) || (y>m) 
            R = Hinv*[x;y;1];
            R = round(R(1:2)/R(3))';
            if R > [0 0] 
                if R <= size(im2) 
                    imnew(i,j) = A(R(1),R(2)); %bilinear interpolation
                end
            end
        else
            imnew(i,j) = im2(x,y);
        end
    end
    waitbar(i/size(imnew,1))
end
close(h)

imwrite(imnew,'test_result.jpg');