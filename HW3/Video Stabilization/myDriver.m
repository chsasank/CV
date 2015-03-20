clc;clear;close all
addpath(genpath('MatlabFns'))
im1 = rgb2gray(imread('yosemite1.jpg'));
im2 = rgb2gray(imread('yosemite2.jpg'));
im3 = rgb2gray(imread('yosemite3.jpg'));
im4 = rgb2gray(imread('yosemite4.jpg'));

imtemp = mosaic(im1,im2);
imtemp = mosaic(imtemp,im3);
imtemp = mosaic(imtemp,im4);
imshow(imtemp); 
imwrite(imtemp,'yosemite_stiched.jpg')