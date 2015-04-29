function pairwise = assmeblePairwise(im,gamma,beta,verbose)
%% assmeblePairwise assembles pairwise matrix for im_crop
% Need to be modified for color images

if(nargin <4)
    verbose = false;
end

sz = size(im);
sz = sz(1:2);
N = sz(1)*sz(2);
c = size(im,3);
Z = double(reshape(im,N,c));


r = zeros(N*8,1);
c = zeros(N*8,1);
s = zeros(N*8,1);
if(verbose) disp('Assembling pairwise matrix'); end
j = 1;
for i = 1:N
    [x,y] = ind2sub_fast(sz,i);
    
    %8 connectivty
    
    m = sub2ind_fast(sz,min(x+1,sz(1)),y);
    s(j) = gamma*1*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    m = sub2ind_fast(sz,max(x-1,1),y);
    s(j) = gamma*1*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    m = sub2ind_fast(sz,x,min(y+1,sz(2)));
    s(j) = gamma*1*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    m = sub2ind_fast(sz,x,max(y-1,1));
    s(j) = gamma*1*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    
    
    m = sub2ind_fast(sz,min(x+1,sz(1)),min(y+1,sz(2)));
    s(j) = gamma*1/sqrt(2)*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    m = sub2ind_fast(sz,max(x-1,1),max(y-1,1));
    s(j) = gamma*1/sqrt(2)*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    m = sub2ind_fast(sz,max(x-1,1),min(y+1,sz(2)));
    s(j) = gamma*1/sqrt(2)*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
    m = sub2ind_fast(sz,min(x+1,sz(1)),max(y-1,1));
    s(j) = gamma*1/sqrt(2)*(m ~= i)*exp(-beta*norm(Z(m,:)-Z(i,:))^2);
    c(j) = m; r(j) = i;j=j+1;
    
end
pairwise = sparse(r,c,fix(s),N,N);
if(verbose) disp('done'); end

end