clc; clear;
load('Features2D_dataset2.mat')
load('Features3D_dataset2.mat')
disp('dataset 2: ')

%% solve for M
% X*m11 + 0*m21 - X*x*m31 + Y*m12 + 0*m22 -Y*x*m32 + Z*m13 + 0*m23 -
% Z*x*m33 + 1*m14 + 0*m24 -x*m34 = 0

% 0*m11 + X*m21 - X*y*m31 + 0*m12 + Y*m22 -Y*y*m32 + 0*m13 + Z*m23 -
% Z*y*m33 + 0*m14 + 1*m24 -y*m34 = 0

N = size(f2D,2);
A = zeros(2*N,12);

for i = 1:N
    X = f3D(1,i); Y = f3D(2,i); Z = f3D(3,i);
    x = f2D(1,i); y = f2D(2,i);
    A(2*i-1,:) = [X, 0, -X*x, Y, 0, -Y*x, Z, 0, -Z*x, 1, 0, -x];
    A(2*i,:)   = [0, X, -X*y, 0, Y, -Y*y, 0, Z, -Z*y, 0, 1, -y];
end

[~,S,V] = svd(A);
m = V(:,12);
disp(['smallest singular value for A = ', num2str(S(12,12))])
M = reshape(m,3,4) %required matrix

%% reconstruct 2d cordinates
h3D = M*f3D;
rf2D = h3D./repmat(h3D(3,:),3,1); %because homogoneous cordinates
maxerror = max(max(rf2D-f2D)) %maximum reconstruction error
