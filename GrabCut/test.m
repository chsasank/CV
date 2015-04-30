im_new = zeros(size(im));
im_new(lid(idx==i)) = alpha_border(idx == i);
imshowpair(im_new,bwmorph(BW3,'remove'))
pause(0.01)
hold on