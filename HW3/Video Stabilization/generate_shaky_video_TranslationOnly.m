clear;

a = mmread('gbus.avi');
framerate = a.rate;
vid = zeros(a.height,a.width,a.nrFramesTotal);

for i=1:a.nrFramesTotal 
    b = rgb2gray(a.frames(i).cdata); 
    [H,W] = size(b);
    if i > 1, tx = round(rand(1)*10); else tx = 0; end;
    if i > 1, ty = round(rand(1)*10); else ty = 0; end;

    d = b; d(:,:) = 0;
    d(ty+1:H,tx+1:W) = b(1:H-ty,1:W-tx);
        
    vid(:,:,i) = d;
end
  
filename = 'gbus_shaky.avi';
writevideo(filename,vid/max(vid(:)),framerate);
    