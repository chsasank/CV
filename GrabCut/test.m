%% Read image and take input
clc;clear; addpath('GCMex')
im = im2double(imread('rose.jpg'));
rect = rectInput(im); % Take input
sz = size(im);
sz = sz(1:2);

%% Intialization - fit GMM to background and foreground
K_num = 4; %GMM components


crop = ones(size(im));
crop(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4),:) = 2;
N_tu = (1+rect(3))*(1+rect(4));
N_tb = prod(sz) - N_tu;
N = prod(sz);

foreColors = reshape(im(crop == 2),[N_tu 3]);
backColors = reshape(im(crop == 1),[N_tb 3]);
Z = reshape(im,[prod(sz) 3]);

options = statset('Display','final','MaxIter',200);
gmmBack = fitgmdist(backColors,K_num,'Options',options);
gmmFore = fitgmdist(foreColors,K_num,'Options',options);

%% Extract GMM parameters and initilisation
% matlab indices 1 - background, 2 - foreground

p = [gmmBack.PComponents; gmmFore.PComponents]'; %P(k,alpha)
mu = cat(3,gmmBack.mu', gmmFore.mu'); % mu(:,k,alpha)
Sigma = cat(4,gmmBack.Sigma, gmmFore.Sigma); %sigma(:,:,k,alpha)

alpha = 2*ones(N_tu,1);
Z = reshape(im,[N 3]);
Z_tu = reshape(im(rect(1):rect(1)+rect(3),rect(2):rect(2)+rect(4)),[N 3]);
%% Iterations

% Step 1: find k_n
K = zeros(N,1);
K(alpha == 1) = cluster(gmmBack,Z(alpha == 1,:));
K(alpha == 2) = cluster(gmmFore,Z(alpha == 2,:));

% Step 2: Learn GMM paramets
for k = 1:K_num
    for a = 1:2
        data = Z((K==k) & (alpha == a),:);
        mu(:,k,a) = mean(data)';
        Sigma(:,:,k,a) = cov(data);
        p(k,a) = size(data,1)/sum(alpha == a);
    end
end

% Step 3: Estimate segmentation
class = alpha';
unary = zeros(2,N);
for a = 1:2
    for n = 1:N
        unary(a,n) = -log(p(k(n),a)) + 1/2*log(det(:,:,k(n)))
    end
end

