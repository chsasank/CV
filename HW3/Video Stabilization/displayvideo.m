function displayvideo (vid,pausetime)

T = size(vid,3);

for i=1:T
   imshow(vid(:,:,i));
   pause(pausetime);
end

