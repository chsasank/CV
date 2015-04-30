%% Read image and take input; initialize
% Works on gray image rather than using color data
clc;clear; close all; addpath('gco-v3.0/matlab')
verbose = true;

im_clr = imread('me2_small.jpg');

im = rgb2gray(im_clr);
im = histeq(im);
rect = rectInput(im_clr,verbose); % Take input
sz = size(im);
sz = sz(1:2);

Z = double(im(:));
N = numel(Z);

alpha = ones(size(im));
alpha(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4)) = 2;
alpha = alpha(:);

%% Unary and Pairwise
gamma = 100; %for smoothening
c = 4; %for edge contrast; more beta - less contrast considered as edges 
beta = c*0.5/mean(sum((Z - circshift(Z,1)).^2,2)); 

h = [imhist(uint8(Z(alpha == 1))) imhist(uint8(Z(alpha == 2)))];
h = h./repmat(sum(h),256,1);
h = h';
epsl = exp(-50);
unary = -10*log(h(:,Z+1)+epsl);

pairwise = assmeblePairwise(im,gamma,beta,verbose);

%% GCO
gc_obj = GCO_Create(N,2);
GCO_SetDataCost(gc_obj,int32(unary))
%GCO_SetSmoothCost(gc_obj,ones(2)-eye(2))
GCO_SetNeighbors(gc_obj,pairwise)
GCO_Expansion(gc_obj);
labels = GCO_GetLabeling(gc_obj);
GCO_Delete(gc_obj)

%% Do some cleanup
% like removing holes and specks
BW = logical(reshape(double(labels-1),sz));

BW2 = imfill(BW,'holes'); %fill holes
BW3 = bwareaopen(BW2, 50); % remove specks containing < 50 pixels

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

