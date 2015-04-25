function I = cutImage(im,labels,l)

labels = reshape(labels,[size(im,1) size(im,2)]);
labels = repmat(labels, [1 1 size(im,3)]);

I = im;

I(labels ~= l) = 0;

end