%testing

%noisy model
Hn = eye(3);
Hn(1:2,3) = [2,30];
im1 = video(:,:,1);
im2 = warp(im1,Hn);

% actual movie model
Hs = eye(3);
Hs(1:2,3) = [20,10];
im3 = warp(im1,Hs);

%warp noisy one to smooth one
Hest = fitTranslation(im1,im2,'ransac');
im4 = warp(im2,Hs*inv(Hest));

figure
subplot(2,2,1)
imshow(im1)
title('initial frame')

subplot(2,2,2)
imshow(im3)
title('actual next frame')

subplot(2,2,3)
imshow(im2)
title('noisy next frame')

subplot(2,2,4)
imshow(im4)
title('restored next frame')
