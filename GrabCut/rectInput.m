function [ rect ] = rectInput( im,verbose,type)
%rectInput Asks user to draw a rectangle bounding box around foreground


if(nargin <2)
    verbose = true;
end

if(nargin<3)
    type = 'rect';
end

if strcrmp(type,'rect')
    imshow(im);
    % title('Draw a bounding box around foreground')
    sz = size(im);
    user_input = 1;
    while user_input == 1
        
        rect = getrect;
        rect = [rect(2) rect(1) rect(4) rect(3) ];
        
        %fix any problems
        rect = fix(rect);
        if rect(1) <= 0
            rect(1) = 1;
        end
        if rect(2) <= 0
            rect(2) = 1;
        end
        if rect(3)+rect(1)>= sz(1)
            rect(3) = sz(1) - rect(1);
        end
        if rect(4)+rect(2)>= sz(2)
            rect(4) = sz(2) - rect(2);
        end
        
        
        rectangle('position',[rect(2) rect(1) rect(4) rect(3) ]);
        if(verbose)
            button = questdlg('This is what you wanted to select?');
            if strcmp(button,'Yes')
                user_input = 0;
            elseif strcmp(button,'No')
                user_input = 1;
            else
                close all
                
                error('User canceled')
            end
        else
            user_input = 0;
        end
    end
    close all
else %free hand
    figure, imshow(im);
    h = imfreehand(gca);
    maskSource = createMask(h);
    
    SF = size(Isource);
    S = SF(1:2);
    mask = maskSource(1:size(Isource,1),1:size(Isource,2));
    boundary = bwperim(mask);
    mask_boundary = mask;
    mask_boundary(boundary) = 0;
end

