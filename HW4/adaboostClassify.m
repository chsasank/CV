function [ Y ] = adaboostClassify( X, i_best, theta_best,p_best, alpha)


Y = zeros(size(X,1),1);
for j = 1:size(i_best)
    Y = Y + alpha(j)*sign(p_best(j)*(X(:,i_best(j)) - theta_best(j)));
end
Y = sign(Y);
end

