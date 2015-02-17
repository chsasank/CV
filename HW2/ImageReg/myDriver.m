
imNoFlash=imread('cave01_01_noflash.jpg');
imNoFlashDown=imNoFlash(1:2:end,1:2:end,:);% Downsampling

imFlash=imread('cave01_00_flash.jpg');
imFlashDown=imFlash(1:2:end,1:2:end,:);
imFlashDown=rgb2gray(imFlashDown);% color to grayscale


imNoFlashDown=rgb2gray(imNoFlashDown);
imNoFlashDown=imrotate(imNoFlashDown,28.5,'nearest','crop');

nBins=10;% no. of bins for histogram calculation

[m,n]=size(imNoFlashDown);


imMisAlign=translateX(imNoFlashDown,-6);% translating by -6 in X direction
imMisAlign=imMisAlign+5*randn(m,n);



tx=-12:1:12;
theta=-60:1:60;
jEntr=zeros(length(tx),length(theta));

for i=1:length(tx)
    for j=1:length(theta)
        imTest=imrotate(imMisAlign,theta(j),'nearest','crop');
        imTest=translateX(imTest,tx(i));
        
        jEntr(i,j)=jointEntropy(imFlashDown,uint8(imTest),nBins);
        
    end
end

[X,Y]=meshgrid(-60:1:60,-12:1:12);
surf(X,Y,jEntr)

[r,c]=find(jEntr==min(min(jEntr)));

sprintf('Estimated Re-aligning translation=%d',tx(r))
sprintf('Estimated Re-aligning rotation=%d',theta(c))

sprintf('Actual translation=%d',-6)
sprintf('Actual Rotation=%d',28.5)

sprintf('Notice that the estimated values are very close to actual values and inverted to compensate for misalignment')
%% Re-Aligning the image

imRecovered=imrotate(translateX(imMisAlign,tx(r)),theta(c),'nearest','crop');
figure,imshow(imFlashDown)% Original Image
figure,imshow(uint8(imMisAlign))% Mis-aligned Image
figure,imshow(uint8(imRecovered))% Recovered Image

