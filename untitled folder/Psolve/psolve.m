% Authors : Pulkit Agarwal, Ishaan Deshpande, Nehal Bhandari

clear; close all; clc;

image1 = 'writing.jpeg';
image2 = 'wood.jpeg';
F_source = double(imread(image1));
F_dest = imread(image2);

% Extract information of the patch
% from image1 to be pasted in image2
[O, A, b, xc, yc] = patchExtract(image1, image2);

N = length(A); % number of interior points
M = length(O) - N; % number of boundary points


tx = xc;
ty = yc;
% maxit = 1000; 
% h = 1/ceil(sqrt(N));
h = 0.75;
epsilon = 10;
it = 0;

% Solution array for R,G & B
ur = zeros(N+M,1);
ug = zeros(N+M,1);
ub = zeros(N+M,1);
ur_old = ones(N+M,1);
ug_old = ones(N+M,1);
ub_old = ones(N+M,1);


%% Setting Dirichlet boundary condition
for i = N+1:N+M
    xx = O(i,1) + tx;
    yy = O(i,2) + ty;
    ur(i) = F_dest(xx,yy,1);
    ug(i) = F_dest(xx,yy,2);
    ub(i) = F_dest(xx,yy,3);
end

%% Mixing Gradients
dP = [-1 0;0 -1;1 0;0 1];
b = zeros(N,3);
g = zeros(3,1); % source gradient
f = zeros(3,1); % destination gradient

for i = 1:N
    for k =1:4
        ps = O(i,:)+dP(k,:);
        g(:,1) = F_source(O(i,1),O(i,2),:)-F_source(ps(1),ps(2),:);
        f(:,1) = double(F_dest(O(i,1)+tx,O(i,2)+ty,:))-double(F_dest(ps(1)+tx,ps(2)+ty,:));
        if(abs(f(1,1))>abs(g(1,1))||abs(f(2,1))>abs(g(2,1))||abs(f(3,1))>abs(g(3,1))) 
            b(i,:) = b(i,:) + f(:,1)';      
        else
            b(i,:) = b(i,:) + g(:,1)';
        end
    end    
end

%% SOR Iterations
Error = sqrt((ur-ur_old).^2 + (ug-ug_old).^2 + (ub-ub_old).^2);
while(sum(abs(ur-ur_old))>epsilon)
% for it = 1:maxit
    ur_old = ur;
    ug_old = ug;
    ub_old = ub;
    ur = SOR( b(:,1), ur, h, A );
    ug = SOR( b(:,2), ug, h, A );
    ub = SOR( b(:,3), ub, h, A );
%     DISPLAY
%     it= it+1
%     sum(abs(ur-ur_old))
end

%% Creating final image
for i = 1:N
    xf = O(i,1) + tx;
    yf = O(i,2) + ty;
    F_dest(xf,yf,1) = uint8(ur(i));
    F_dest(xf,yf,2) = uint8(ug(i));
    F_dest(xf,yf,3) = uint8(ub(i));
end

figure, imshow(F_dest);


