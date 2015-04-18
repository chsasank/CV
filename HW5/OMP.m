function [ S0 ] = OMP( Y,A,sigma )
%OMP runs orthoganal matching pursuit algorithm

epsilon = 2*sigma^2*size(A,1);
S0 = zeros(size(A,2),size(Y,2));
col_norms =  sqrt(sum(abs(A.^2)));
 
for i = 1: size(Y,2)
    T = zeros(64,1); %support set
    r = Y(:,i); y = Y(:,i);
    s = zeros(64,1);
    
    while(norm(r)^2 > epsilon)
        [~,j] = max( abs(r'*A)./col_norms );
        T(j) = T(j) + 1;
        A_t = A(:,T>0);
        s(T>0) = A_t\y;
        r = y - A_t*s(T>0);
    end  
    S0(:,i) = s;
end

end

