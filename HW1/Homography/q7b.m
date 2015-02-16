clc; clear; close all

Hest = homography('goi1_downsampled.jpg','goi2_downsampled.jpg')

im3 = warp(imread('goi1_downsampled.jpg'),Hest);
imwrite(im3,'goi2_dowmsampled_H_est.jpg');

figure
subplot(1,3,1) 
imshow('goi1_downsampled.jpg')
subplot(1,3,2) 
imshow('goi2_downsampled.jpg')
subplot(1,3,3)
imshow(im3)