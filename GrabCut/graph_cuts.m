%% Read image and take input; initialize
% Works on gray image rather than using color data
clc;clear; close all; addpath('gco-v3.0/matlab')
verbose = true;

im_clr = imread('varun.jpg');
im = rgb2gray(im_clr);
rect = rectInput(im_clr,verbose); % Take input
sz = size(im);
sz = sz(1:2);

Z = double(im(:));
N = numel(Z);

alpha = ones(size(im));
alpha(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4)) = 2;
alpha = alpha(:);

%% Unary and Pairwise
gamma = 50;
beta = 0.25/mean(sum((Z - circshift(Z,1)).^2,2));

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

%% Results
figure
imshow(cutImage(im_clr,labels,2))
title(num2str(beta))

figure
subplot(1,2,1)
imshow(cutImage(im_clr,labels,2))
subplot(1,2,2)
imshow(reshape(double(labels-1),sz))