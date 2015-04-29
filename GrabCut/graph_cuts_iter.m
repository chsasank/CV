%% Read image and take input; initialize
clc;clear; close all; addpath('gco-v3.0/matlab')
im_clr = imread('rose_small.jpg');
im = rgb2gray(im_clr);
rect = rectInput(im_clr); % Take input
sz = size(im);
sz = sz(1:2);

Z = double(im(:));
N = numel(Z);

alpha = ones(size(im));
alpha(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4)) = 2;
alpha = alpha(:);

%% Pairwise
gamma = 50; %for smoothening
beta = 1e-2*0.5/mean((Z - circshift(Z,1)).^2); %for smoothening contrast

pairwise = assmeblePairwise(im,gamma,beta);

maxIter = 3;
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
%% Results
figure
imshow(cutImage(im_clr,labels,2))
title(num2str(beta))

figure
subplot(1,2,1)
imshow(cutImage(im_clr,labels,2))
subplot(1,2,2)
imshow(reshape(double(labels-1),sz))