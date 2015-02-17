
imNoFlash=imread('C:\Users\Tharun\Desktop\Acads\Lectures\4-2\CS 763\Assignments\CV\HW2\ImageReg\cave01_01_noflash.jpg');
imNoFlashDown=imNoFlash(1:4:end,1:4:end,:);% Downsampling

imFlash=imread('C:\Users\Tharun\Desktop\Acads\Lectures\4-2\CS 763\Assignments\CV\HW2\ImageReg\cave01_00_flash.jpg');
imFlashDown=imFlash(1:4:end,1:4:end,:);
imFlashDown=rgb2gray(imFlashDown);
%figure,imshow(imFlash)

imNoFlashDown=rgb2gray(imNoFlashDown);
imNoFlashDown=imrotate(imNoFlashDown,28.5,'nearest','crop');% rotation by 28.5 degrees

nBins=10;% no. of bins for histogram calculation

[m,n]=size(imNoFlashDown);


imMisAlign=translateX(imNoFlashDown,-100);% translating by -100 in X direction
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

sprintf('Re-aligning translation=%d',tx(r))
sprintf('Re-aligning angle=%d',theta(c))

sprintf('Actual translation=%d',-100)
sprintf('Actual rotation=%d',28.5)

sprintf('Notice that the estimated values are very far off from actual values')