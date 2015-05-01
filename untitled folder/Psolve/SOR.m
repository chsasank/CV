function u = SOR( b, u, h, A )
% SOR  Does one sweep of SOR relaxation for the Poisson problem
%
% Usage:  u = sor( f, u, h )
%
% Input
%    f    right-hand side
%    u    current approximation
%    h    mesh spacing
%    A    adjacency matrix
%
% Returns
%    u    updated
% Authors : Pulkit Agarwal, Ishaan Deshpande, Nehal Bhandari


% set the relaxation parameter (optimal)

% omega = 1;
omega = 2/(1 + sin(pi*h));
N = size(b);
h2 = h*h;

for i = 1:N
    u(i) = (1-omega)*u(i) ...
           + omega*(u(A(i,1)) + u(A(i,2)) + u(A(i,3)) + u(A(i,4)) + h2*b(i))/4;
end
