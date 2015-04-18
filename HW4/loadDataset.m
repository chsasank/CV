function [X_train,Y_train,X_test,Y_test] = loadDataset(part,isPlot)
% Loads/creates datasets for the problems a,b,c,d,e

% rng(1);
N = 2000;

if(strcmp(part,'a'))
    X = rand(N,2);
    Y = -1*ones(N,1);
    Y(X(:,1)>=0.3 & X(:,1)<=0.7 & X(:,2)>=0.3 & X(:,2)<=0.7) = 1;
    
elseif(strcmp(part,'b'))
    X =  rand(N,2);
    Y = -1*ones(N,1);
    
    Y(X(:,1)>=0.3 & X(:,1)<=0.7 & X(:,2)>=0.3 & X(:,2)<=0.7) = 1;
    
    Y(X(:,1)>=0.15 & X(:,1)<=0.25) = 1;
    Y(X(:,1)>=0.75 & X(:,1)<=0.85) = 1;
    
    Y(X(:,2)>=0.15 & X(:,2)<=0.25) = 1;
    Y(X(:,2)>=0.75 & X(:,2)<=0.85) = 1;
    
elseif(strcmp(part,'c'))
    X = 2*randn(N,2);
    Y = -1*ones(N,1);
    
    distance = sqrt(X(:,1).^2 + X(:,2).^2);
    
    Y(distance <= 2) = 1;
    
elseif(strcmp(part,'d'))
    X = 2*randn(N,2);
    Y = -1*ones(N,1);
    
    distance = sqrt(X(:,1).^2 + X(:,2).^2);
    
    Y(distance <= 2) = 1;
    Y(distance >= 2.5 & distance <= 3) = 1;
elseif(strcmp(part,'e'))
    d = 2;
    X_test = dlmread('images_testing.txt');
    X_test = reshape(X_test,169,numel(X_test)/169)';
    
    Y_test = dlmread('labels_testing.txt');
    digit_2 = (Y_test == d);
    Y_test(digit_2) = 1;
    Y_test(~digit_2) = -1;
    
    X_train = dlmread('images_training.txt');
    X_train = reshape(X_train,169,numel(X_train)/169)';
    
    Y_train = dlmread('labels_training.txt');
    digit_2 = (Y_train == d);
    Y_train(digit_2) = 1;
    Y_train(~digit_2) = -1;
end




if(~strcmp(part,'e'))
    if(isPlot)
        %scatter plot
        figure
        plus = X(Y == 1,:);
        minus = X(Y == -1,:);
        scatter(plus(:,1),plus(:,2))
        hold on
        scatter(minus(:,1),minus(:,2),'r')
        legend('+1','-1')
        axis equal
    end
    
    % divide into two parts
    num_points = size(X,1);
    split_point = round(num_points*0.5);
    seq = randperm(num_points);
    X_train = X(seq(1:split_point),:);
    Y_train = Y(seq(1:split_point));
    X_test = X(seq(split_point+1:end),:);
    Y_test = Y(seq(split_point+1:end));
end