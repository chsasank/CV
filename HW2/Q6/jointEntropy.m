function [ jEntr ] = jointEntropy( im1,im2,nBins )

jHist=zeros(nBins,nBins);

im1=floor((nBins/255)*im1);% quantizing images to bins
im2=floor((nBins/255)*im2);


grid2=zeros(size(im2,1),size(im2,2),nBins);

for j=0:nBins-1  %Finding corresponding pixels for each bin for image 2     
    grid2(:,:,j+1)=(im2==j);
end


for i=0:nBins-1         
         mat=(im1==i); %Finding corresponding pixels for ith bin for image 1
         for j=0:nBins-1 
             
             mat2= mat & grid2(:,:,j+1);  
                          
             jHist(i+1,j+1)=sum(mat2(:));
             
         end       
    
end



jEntr=log(size(im1,1)*size(im1,2))-((sum(sum(jHist.*log(jHist+eps))))/(size(im1,1)*size(im1,2)));

end

