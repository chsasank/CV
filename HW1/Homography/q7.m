clc; clear
load('Hmodel.mat')
% Hmodel

%% Reverse warping
A = imread('goi1_downsampled.jpg');
B = warp(A,Hmodel);

figure
subplot(1,2,1) 
imshow(A)
subplot(1,2,2) 
imshow(B)

