clc;clear;close all;
%% Load Dataset
[X,Y,X_test,Y_test] = loadDataset('a',true);


%% Adaboost
numIter = 40;
W = ones(size(Y))/size(Y,1);

i_best = zeros(numIter,1);
theta_best = zeros(numIter,1);
p_best = zeros(numIter,1);
alpha = zeros(numIter,1);

train_error = zeros(numIter,1); test_error = zeros(numIter,1);

for t = 1:numIter
    %% Find best classifier with current weights
    bestError = 1;
    for i = 1:size(X,2)
        for theta = X(:,i)'
            p = 1;
            misclassified = ( Y ~= sign( X(:,i) - theta) ) ;
            error = sum(W(misclassified));
            
            if error > 0.5
                error = 1 - error;
                p = -1;
            end
            
            if error <= bestError
                bestError = error;
                i_best(t) = i;
                theta_best(t) = theta;
                p_best(t) = p;
            end
        end
    end
    
    %% Update weights/distribution
    alpha(t) = log((1-bestError)/bestError)/2;
    misclassified = ( Y ~= sign(p_best(t)*(X(:,i_best(t)) - theta_best(t))) );
    
    W(misclassified) = W(misclassified)*exp(alpha(t));
    W(~misclassified) = W(~misclassified)*exp(-alpha(t));
    
    W = W/sum(W);
    
%     % scatter plot with weights for visualization
%     S = 25*1000*W;
%     plus = X(Y == 1,:);
%     minus = X(Y == -1,:);
%     scatter(plus(:,1),plus(:,2),S(Y == 1),'filled')
%     hold on
%     scatter(minus(:,1),minus(:,2),S(Y == -1),'r','filled')
%     hold off
    
    %% classify using strong classifier
    
    % Training error
    Y_strong = adaboostClassify(X, i_best(1:t), theta_best(1:t), p_best(1:t), alpha(1:t));
    train_error(t) = sum(Y_strong ~= Y)/numel(Y);
    
    % Test error
    Y_strong_test = adaboostClassify(X_test, i_best(1:t), theta_best(1:t), p_best(1:t), alpha(1:t));
    test_error(t) = sum(Y_strong_test ~= Y_test)/numel(Y_test);
    
end

figure
plot(train_error)
hold on
plot(test_error,'r')
legend('training error','test error')
