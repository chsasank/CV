function [ jEntr ] = jointEntropy2( im1,im2,nBins )

jHist=zeros(nBins,nBins);

% tic
% for i=0:nBins-1
%     for j=0:nBins-1
%        %jHist(i+1,j+1)=sum(sum((im1==i)&(im2==j)));
%        jHist(i+1,j+1)=sum(sum(((i*(255/nBins)<=im1)&((i+1)*(255/nBins)>im1))&((j*(255/nBins)<=im2)&((j+1)*(255/nBins)>im2))));
%     end
% end
% toc
tic
grid=zeros(size(im2,1),size(im2,2),nBins);
for j=0:nBins-1
    grid(:,:,j+1)=(j*(255/nBins)<=im2)&((j+1)*(255/nBins)>im2);
end
toc

tic
for i=0:nBins-1
         mat=(i*(255/nBins)<=im1)&((i+1)*(255/nBins)>im1);
         for j=0:nBins-1
             %mat2=(j*(255/nBins)<=im2)&((j+1)*(255/nBins)>im2);
             %jHist(i+1,j+1)=sum(sum(mat & grid(:,:,j+1)));
            
             mat2= mat & grid(:,:,j+1);
             
             jHist(i+1,j+1)=sum(mat2(:));
         end       
    
end
toc


%jEntr=log(256*256)-((sum(sum(jHist.*log(jHist+eps))))/(256*256));
%jEntr=log(nBins*nBins)-(sum(sum(jHist.*log(jHist+eps))))/(nBins*nBins);
tic
jEntr=log(size(im1,1)*size(im1,2))-((sum(sum(jHist.*log(jHist+eps))))/(size(im1,1)*size(im1,2)));
toc
end

