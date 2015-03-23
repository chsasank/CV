%testing

%noisy model
Hn = eye(3);
Hn(1:2,3) = [2,30];
im1 = video(:,:,1);
im2 = warp(im1,Hn);

Hest = fitTranslation(im1,im2,'ransac');
im3 = warp(im2,inv(Hest));

figure
subplot(2,2,1)
imshow(im1)
title('im1')

subplot(2,2,2)
imshow(im2)
title('im2')

subplot(2,2,3)
imshow(im3)
title('im2 warped to match im1')


subplot(2,2,4)
imshowpair(im3,im1)
title('comparision on im1 and im2 warped to match im1')
