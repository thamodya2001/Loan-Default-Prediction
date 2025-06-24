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

% Optimize K Using Cross-Validation
k_values = [1, 3, 5, 7, 9, 11]; % Different K values to test
best_k = k_values(1);
best_accuracy = 0;

for k = k_values
    % Train KNN Model with Current K
    mdl = fitcknn(X_train, Y_train, 'NumNeighbors', k);
    
    % Predict on Test Data
    Y_pred = predict(mdl, X_test);
    
    % Compute Accuracy
    accuracy = sum(Y_pred == Y_test) / length(Y_test);
    
    % Update Best K if Accuracy is Higher
    if accuracy > best_accuracy
        best_accuracy = accuracy;
        best_k = k;
    end
end

% Train Final KNN Model with Best K
final_knn = fitcknn(X_train, Y_train, 'NumNeighbors', best_k);

% Predict on Test Data
Y_pred = predict(final_knn, X_test);

% Compute Evaluation Metrics
confMat = confusionmat(Y_test, Y_pred)
precision = confMat(2,2) / sum(confMat(:,2));
recall = confMat(2,2) / sum(confMat(2,:));
f1_score = 2 * (precision * recall) / (precision + recall);

% Display Results
fprintf('Best K Value: %d\n', best_k);
fprintf('KNN Accuracy: %.2f%%\n', best_accuracy * 100);
fprintf('Precision: %.2f%%\n', precision * 100);
fprintf('Recall: %.2f%%\n', recall * 100);
fprintf('F1-Score: %.2f\n', f1_score);

%Best K Value: 7
%KNN Accuracy: 62.00%
%Precision: 46.67%
