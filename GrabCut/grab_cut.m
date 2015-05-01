%% Read image and take input; initialize
% for color images; GMM
clc;clear; close all; addpath('gco-v3.0/matlab')
verbose = true;

im_clr = imread('siddhu.jpg');
im = im_clr;
mask = rectInput(im_clr,false,'freehand'); % Take input
sz = size(im);
sz = sz(1:2);

N = sz(1)*sz(2);
Z = double(reshape(im,N,3));

% alpha = ones(sz(1),sz(2));
% alpha(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4)) = 2;
alpha = mask(:);

%% Pairwise
gamma = 50; %for smoothening
c = 1; %for edge contrast; more c - less contrast considered as edges 
beta = c*0.5/mean(sum((Z - circshift(Z,1)).^2,2)); 
k = 4; %number of components in gmm
maxIter = 3;

pairwise = assmeblePairwise(im,gamma,beta,verbose);
%% Iterations
for i = 1:maxIter 
    %% Unary
    tic
    gmm_back = gmdistribution.fit(Z(alpha == 1,:),k,'Regularize',1e-4);
    gmm_fore = gmdistribution.fit(Z(alpha == 2,:),k,'Regularize',1e-4);
    
    epsl = exp(-50);
    pdf_back = -log(pdf(gmm_back,Z)+epsl);
    pdf_fore = -log(pdf(gmm_fore,Z)+epsl);
    unary = [pdf_back, pdf_fore]';
    t = toc;
    if(verbose) disp([num2str(t),' seconds for finding unary matrix']); end
    %% GCO
    gc_obj = GCO_Create(N,2);
    GCO_SetDataCost(gc_obj,int32(unary))
    GCO_SetNeighbors(gc_obj,pairwise)
    GCO_Expansion(gc_obj);
    labels = GCO_GetLabeling(gc_obj);
    GCO_Delete(gc_obj)
    alpha = labels;
end
%% Do some cleanup
% like removing holes and specks
BW = logical(reshape(double(labels-1),sz));

BW2 = imfill(BW,'holes'); %fill holes
BW3 = bwareaopen(BW2,100); % remove specks containing < 100 pixels

labels_new = reshape(BW3,size(labels))+1;

%% Results
figure
imshow(cutImage(im_clr,labels_new,2))

