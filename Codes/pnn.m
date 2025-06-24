clc;
clear all;
data=dlmread('bankloan.csv',',',1)
X = [data(:,1) data(:,4:11)];
Y = [data(:,12)];
% split the data into train test set

rng(123);
P = cvpartition(Y ,'holdout',0.20);
X_train = X(P.training);
Y_train = Y(P.training);
X_test = X(P.test);
Y_test = Y(P.test);



% Train PNN Model
net=newpnn(X_train',ind2vec(double(Y_train)'+1),0.5)
view(net)

% Define a range of spread values
spread_values = [0.1, 0.5, 1, 2, 5];
error_rates = zeros(size(spread_values));
accuracy_rates = zeros(size(spread_values));

fprintf('Spread | Accuracy (%%) | Error Rate (%%)\n');
fprintf('--------------------------------------\n');

for i = 1:length(spread_values)
    spread = spread_values(i);
    
    % Train PNN Model with the given spread
    net = newpnn(X_train', ind2vec(double(Y_train)' + 1), spread);
    
    % Predict on Test Data
    Y_pred = vec2ind(sim(net, X_test')) - 1; % Convert back to labels
    
    % Compute Accuracy & Error Rate
    accuracy = sum(Y_pred' == double(Y_test)) / length(Y_test) * 100;
    error_rate = 100 - accuracy;
    
    accuracy_rates(i) = accuracy;
    error_rates(i) = error_rate;
    
    fprintf('  %.1f   |    %.2f%%   |    %.2f%%\n', spread, accuracy, error_rate);
end



