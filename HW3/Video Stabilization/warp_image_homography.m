function newim = warp_image_homo (im, H)

[W1,W2] = size(im);
newim  =zeros(W1,W2);
H = inv(H);

for i=1:W1
    for j=1:W2
        xy = H*[j i 1]';
        xy(1:2) = xy(1:2)./xy(3);
        xy = round(xy);
        x = xy(1);
        y = xy(2);
        if x > 0 && x <= W2 && y > 0 && y <= W1
            newim(i,j) = im(y,x);
        end
    end
end