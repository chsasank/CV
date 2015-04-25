function [ rect ] = rectInput( im )
%rectInput Asks user to draw a rectangle bounding box around foreground
imshow(im)
title('Draw a bounding box around foreground')
sz = size(im);

user_input = 1;
while user_input == 1
    
    rect = getrect;
    rect = [rect(2) rect(1) rect(4) rect(3) ];
    
    %fix any problems
    rect = fix(rect);
    if rect(3)+rect(1)>= sz(1)
        rect(3) = sz(1) - rect(1);
    end
    if rect(4)+rect(2)>= sz(2)
        rect(4) = sz(2) - rect(2);
    end
    
    rectangle('position',[rect(2) rect(1) rect(4) rect(3) ]);
    button = questdlg('This is what you wanted to select?');
    if strcmp(button,'Yes')
        user_input = 0;
    elseif strcmp(button,'No')
        user_input = 1;
    else
        close all

        error('User canceled')
    end
end
close all
end

