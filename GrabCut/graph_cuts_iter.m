%% Read image and take input; initialize
% Iterative version of graph_cuts
clc;clear; close all;
addpath('gco-v3.0/matlab');
verbose = true;

im_clr = imread('varun.jpg');
im = rgb2gray(im_clr);
im = histeq(im);
rect = rectInput(im_clr); % Take input
sz = size(im);
sz = sz(1:2);

Z = double(im(:));
N = numel(Z);

alpha = ones(size(im));
alpha(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4)) = 2;
alpha = alpha(:);

%% Pairwise
gamma = 100; %for smoothening
c = 4; %for edge contrast; more beta - less contrast considered as edges
beta = c*0.5/mean(sum((Z - circshift(Z,1)).^2,2));
maxIter = 3;


pairwise = assmeblePairwise(im,gamma,beta,verbose);
%% Iterations
for i = 1:maxIter
    %% Unary
    h = [imhist(uint8(Z(alpha == 1))) imhist(uint8(Z(alpha == 2)))];
    h = h./repmat(sum(h),256,1);
    h = h';
    eps = exp(-50);
    unary = -10*log(h(:,Z+1)+eps);
    
    %% GCO
    gc_obj = GCO_Create(N,2);
    GCO_SetDataCost(gc_obj,int32(unary))
    %GCO_SetSmoothCost(gc_obj,ones(2)-eye(2))
    GCO_SetNeighbors(gc_obj,pairwise)
    GCO_Expansion(gc_obj);
    labels = GCO_GetLabeling(gc_obj);
    GCO_Delete(gc_obj)
    alpha = labels;
    
end
%% Do some cleanup
% like removing holes and specks
BW = logical(reshape(double(labels-1),sz));
BW2 = imfill(BW,'holes'); %fill holes
BW3 = bwareaopen(BW2,100); % remove specks containing < 100 pixels

labels_new = reshape(BW3,size(labels))+1;

%% Results
figure
imshow(cutImage(im_clr,labels_new,2))
title(num2str(beta))

figure
subplot(1,2,1)
imshow(cutImage(im_clr,labels_new,2))
subplot(1,2,2)
imshow(BW3)

%% Matting
alpha_matted = double(BW3);

% simplify boundary to some  points

B = bwboundaries(BW3,'noholes');
p = B{1};
ps = p(1:10:end,:);


% dilate image
w = 6;
se = strel('diamond', w);
BW4 = imdilate(bwmorph(BW3,'remove'),se);

% find indices and values of pixels around borders
lid = find(BW4);
z_border = double(im(lid));
labels_border = labels_new(lid);
alpha_border = alpha_matted(lid);

[r,c] = ind2sub_fast(sz,lid);
border_indices = [r,c];

% assign closest point in ps to each point in ps
idx = knnsearch(ps,border_indices);


for i = 1:size(ps,1)
    % fit gaussian to each of background and foreground around border
    z_fore = z_border(idx>= i-1 & idx <= i+1 & labels_border == 1);
    z_back = z_border(idx>= i-1 & idx <= i+1 & labels_border == 2);
    
    if numel(z_fore) <= 1
        alpha_border(idx == i) = 0; % assign all to background
    elseif numel(z_back) <= 1
        alpha_border(idx == i) = 1; % assign all to foreground
    else
        pd_fore = fitdist(z_fore,'Normal');
        pd_back = fitdist(z_back,'Normal');
        
        alpha_border(idx == i) = pdf(pd_fore,z_border(idx==i))./( pdf(pd_fore,z_border(idx==i)) +  pdf(pd_back,z_border(idx==i)));
        
    end
end

alpha_matted(lid) = alpha_border;
alpha_matted = reshape(alpha_matted,sz);
disp('done')