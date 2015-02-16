clc; clear; close all
load('Hmodel.mat')
Hmodel

im1 = imread('goi1_downsampled.jpg');

im2 = warp(im1,Hmodel);
imwrite(im2,'goi1_downsampled_H.jpg');

Hest = homography('goi1_downsampled.jpg','goi1_downsampled_H.jpg')

im3 = warp(im1,Hest);
imwrite(im3,'goi1_dowmsampled_H_est.jpg');

figure
subplot(1,3,1) 
imshow(im1)
subplot(1,3,2) 
imshow(im2)
subplot(1,3,3)
imshow(im3)