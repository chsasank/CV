%% OMP algorithm

clc;clear;close all; tic; rng(0)
I = imread('barbara256.png');
patchSize = 8;

patches = zeros((256-patchSize+1)^2,patchSize^2);

i = 1;
for c = 1:256-patchSize+1
    for r = 1:256-patchSize+1
        p = I(c:c+patchSize-1,r:r+patchSize-1);
        patches(i,:) = p(:);
        i = i +1;
    end
end

%% display images after decoding
n = patchSize^2;
m_range = ceil([0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.05] *n);

for l = 1:size(m_range,2)
    %% Compressed measurements
    m = m_range(l);
    
    phi = randn(64,64);
    phi_m = phi(1:m,:);
    
    X = patches';
    Y = phi_m*X;
    sigma = 0.05*mean(abs(Y(:)));
    Y = Y + sigma*randn(size(Y));
    
    U = kron(dctmtx(patchSize)',dctmtx(patchSize)'); %dct matrix
    A = phi_m*U;
    
    %% OMP
    
    S0 = OMP(Y,A,sigma);
    X0 = U*S0;
    patches0 = X0';
    
    %% Combine recovered images
    I_out =  patchCombine(patches0,patchSize,size(I));
    figure
    imshow(I_out)
    title(['m = ',num2str(m)])
    
    %% Compute errors
    MSPE(l) = mean(mean((patches0' - patches').^2));
    MSIE(l) = mean(mean((I_out-I).^2));
end
%% Display Errors
figure
plot(m_range, MSPE)
title('MSPE vs m')
xlabel('m')
ylabel('MSPE')

figure
plot(m_range, MSIE)
title('MSIE vs m')
xlabel('m')
ylabel('MSIE')
toc