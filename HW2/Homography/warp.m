function [ B ] = warp( A , H)
%% warp(A, H) warps image A using homography model H
% uses reverse warping 

B = zeros(size(A),'uint8');
Hinv = inv(H);


i = 1:size(B,1);
j = 1:size(B,2);
ij = combvec(i,j);
ij(3,:) = ones(1,size(ij,2));
Rij = Hinv*ij;
Rij = Rij./repmat(Rij(3,:),3,1);
Rij = round(Rij(1:2,:));
Rij = Rij';

for k = 1:numel(B)
        if Rij(k,:) > [0 0] 
            if Rij(k,:) <= size(B) 
                B(k) = A(Rij(k,1),Rij(k,2));
            end
        end
end

end

