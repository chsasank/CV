function [ outputIm ] = translateX( inputIm,offset )

outputIm=zeros(size(inputIm));

if(offset>0)    
    outputIm(:,offset+1:size(inputIm,2))=inputIm(:,1:size(inputIm,2)-offset);
else
    outputIm(:,1:size(inputIm,2)+offset)=inputIm(:,1-offset:size(inputIm,2)); 
end

end

