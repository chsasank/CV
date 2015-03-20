function [ Hest ] = leastSquaresHomography( p1, p2 )
%% homography Estimates histography between points p1 and p2


%% homography2 from p1 and p2
% x1*h11 + 0*h21 - x1*x2*h31 + y1*h12 + 0*h22 -y1*x2*h32 + 1*h13 + 0*h23 -
% 1*x2*h33 = 0

% 0*h11 + x1*h21 - x1*y2*h31 + 0*h12 + y1*h22 -y1*y2*h32 + 0*h13 + 1*h23 -
% 1*y2*h33 = 0

N = size(p1,2);
A = zeros(2*N,9);

for i = 1:N
    x1 = p1(1,i); y1 = p1(2,i);
    x2 = p2(1,i); y2 = p2(2,i);
    A(2*i-1,:) = [x1, 0, -x1*x2, y1, 0, -y1*x2, 1, 0, -x2];
    A(2*i,:)   = [0, x1, -x1*y2, 0, y1, -y1*y2, 0, 1, -y2];
end

[~,S,V] = svd(A);
h = V(:,9);
disp(['smallest singular value for A = ', num2str(S(9,9))])
Hest = reshape(h,3,3); %required matrix
Hest = Hest/Hest(3,3);

end

