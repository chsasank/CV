function [P,A,b,tx,ty] = patchExtract(img1,img2)
% Authors : Pulkit Agarwal, Ishaan Deshpande, Nehal Bhandari

Isource = imread(img1);
Idest = imread(img2);
Iextract = cat(2,Isource,Idest);

figure, imshow(Iextract);
h = imfreehand(gca);
maskSource = createMask(h);

SF = size(Isource);
S = SF(1:2);
mask = maskSource(1:size(Isource,1),1:size(Isource,2));
boundary = bwperim(mask);
mask_boundary = mask;
mask_boundary(boundary) = 0;



dP = [-1 0;0 -1;1 0;0 1];

%% Compute P

[R,C] = ind2sub(S,find(mask_boundary));
[R1,C1] = ind2sub(S,find(boundary));
Nb = length(R1);
N = length(R);
P = zeros(N+Nb,2);
P(1:N,1) = R;
P(1:N,2) = C;
P(N+1:N+Nb,1) = R1;
P(N+1:N+Nb,2) = C1;


%% Compute A and b

A = zeros(N,4);
b = zeros(N,3);
l = [0 1 0; 1 -4 1; 0 1 0];
I1 = -conv2(l,double(Isource(:,:,1)));
I2 = -conv2(l,double(Isource(:,:,2)));
I3 = -conv2(l,double(Isource(:,:,3)));
h = waitbar(0,'Please Wait')
for i=1:N
    p = P(i,:);
    for k = 1:4
        ps = p+dP(k,:);
        T = P-ones(N+Nb,1)*ps;
        T = sum(abs(T),2);
        A(i,k) = find(T==0);       
    end
    b(i,1) = I1(p(1),p(2));
    b(i,2) = I2(p(1),p(2));
    b(i,3) = I3(p(1),p(2)); 
    waitbar(i/N,h);
end
close(h)

        

%% Compute xc and yc

xc = floor((sum(R)+sum(R1))/(N+Nb));
yc = floor((sum(C)+sum(C1))/(N+Nb));
text = 'Move to new position'
pause

fcn = getPositionConstraintFcn(h);
setPositionConstraintFcn(h,fcn);
newMask = createMask(h);

SF1 = size(Iextract);
S1 = SF1(1:2);

[R2,C2] = ind2sub(S1,find(newMask));
Nnew = length(R2);

xc1 = floor(sum(R2)/Nnew);
yc1 = floor(sum(C2)/Nnew);

tx = xc1-xc;
ty = yc1-yc-size(Isource,2);
