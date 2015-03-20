clear;

a = mmread('E:\VideoStab\Stable\fountain_dyntex.avi');
framerate = a.rate;
vid = zeros(a.height,a.width,a.nrFramesTotal);

for i=1:a.nrFramesTotal 
    b = rgb2gray(a.frames(i).cdata); 
    [H,W] = size(b);
    if i > 1, tx = round(rand(1)*3); else tx = 0; end;
    if i > 1, ty = round(rand(1)*3); else ty = 0; end;
    if i > 1,theta(i) = randn(1)*2;else theta(i) = 0; end;
           
    c = imrotate(b,theta(i),'bilinear','crop');    
    d = c; d(:,:) = 0;
    d(ty+1:H,tx+1:W) = c(1:H-ty,1:W-tx);
        
    vid(:,:,i) = d;
end
  
filename = 'shaky_fountain_dyntex.avi';
writevideo(filename,vid/max(vid(:)),framerate);
    