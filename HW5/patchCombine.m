function [ image_out ] = patchCombine( patches,patchSize, sizes)

a = sizes(1);
b = sizes(2);
image_out = zeros(a,b);
times = zeros(a,b);

i = 1;
for c = 1:a-patchSize+1
    for r = 1:b-patchSize+1
        p = reshape(patches(i,:),[patchSize patchSize]);
        
        image_out(c:c+patchSize-1,r:r+patchSize-1) = image_out(c:c+patchSize-1,r:r+patchSize-1) + p;
        times(c:c+patchSize-1,r:r+patchSize-1) = times(c:c+patchSize-1,r:r+patchSize-1) + 1;
        
        i = i+1;
    end
end

image_out = uint8(image_out./times);

end

