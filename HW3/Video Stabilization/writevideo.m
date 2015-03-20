function writevideo (filename, vid, framerate)

[H,W,NF] = size(vid);
ff = VideoWriter(filename);
ff.FrameRate = framerate;

open (ff);
for i=1:NF
    writeVideo(ff,vid(:,:,i));
end
close (ff);