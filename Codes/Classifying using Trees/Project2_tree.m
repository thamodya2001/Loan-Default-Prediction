
clc; clear;

data = dlmread('bankloan.csv', ',',1,0);


% Check for missing values
missingValues = isnan(data); % Count missing values per column
missingV=sum(missingValues(:))


% to check duplicate 
duplicate= unique(data)

% check for NaN values 

data(any(isnan(data), 2), :) = []; % remove the NaN rows 


%%
% dropping variables 'ncust' and 'customer'
data(:,2:3)=[];

% filter data according to response variable 
% def= previously defaulted
% not_def = previously not defaulted 
def= data(data(:,10)==1);
not_def= data(data(:,10)==0);
%%
X = [data(:,1:9)];
Y = [data(:,10)];
%x___branch     age    ed    employ    address    income    debtinc    creddebt    othdebt     default
%%
% split the data into train test set
rng(123);
P = cvpartition(Y ,'holdout',0.2);
X_train = X(P.training,1:9);
Y_train = Y(P.training);
X_test = X(P.test,1:9);
Y_test = Y(P.test);
%%
%split the train set into train and validation set
vP = cvpartition(Y_train ,'holdout',0.2);
X_train_f = X(vP.training,1:9);
Y_train_f = Y(vP.training);
X_val = X(vP.test,1:9);
Y_val = Y(vP.test);

%% Considering imbalanced Data
tpI = fitctree(X(P.training,:),Y(P.training),'PredictorNames',...
     {'x___branch' 'age' 'ed' 'employ' 'address' 'income' 'debtinc' 'creddebt' 'othdebt'},...
     'PruneCriterion', 'impurity');
%%
%view(t1);
view(tpI,'Mode','graph');
%%
[label2,score2,node2,cnum2] = predict(tpI,X(P.test,1:9));
accuracyimp = sum(label2 == Y_test) / numel(Y_test); 
testErrorI = sum(label2 ~= Y_test) / numel(Y_test);
conmatPimp = confusionmat(Y_test,label2);
cvModel = crossval(tpI); 
cvError = kfoldLoss(cvModel);
trainL = resubLoss(tpI);
%%
% got 79 as best
rng(1)
[etpI1,setpI1,nleaftpI1,bestleveltpI1] = cvLoss(tpI, 'SubTrees', 'All', 'TreeSize', 'min');% 1 SE rule
%%
view(tpI,'Mode','graph','prune',bestleveltpI1);
%%
figure;
plot(nleaftpI1, etpI1, '-o', 'LineWidth', 1.5, 'MarkerSize', 6);
hold on;
[~, bestIdx] = min(abs(nleaftpI1 - bestleveltpI1));
plot(nleaftpI1(bestIdx), etpI1(bestIdx), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Mark best level
xlabel('Pruning Level');
ylabel('Cross-Validation Error');
title('Cross-Validation Error vs. Pruning Level');
grid on;
legend('CV Error', 'Best Level');
hold off;
%%
tpI2 = prune(tpI, 'Level', 79);
Y_tpI2 = predict(tpI2, X_test);
accuracy2imp = sum(Y_tpI2 == Y_test) / numel(Y_test); 
testErrorIP = sum(Y_tpI2 ~= Y_test) / numel(Y_test);
conmatP_imp = confusionmat(Y_test,Y_tpI2);
cvModelP = crossval(tpI2); 
cvErrorP = kfoldLoss(cvModelP);
trainLP = resubLoss(tpI2);
%%
imp = predictorImportance(tpI2);

figure;
bar(imp);
title('Predictor Importance Estimates');
ylabel('Estimates');
xlabel('Predictors');
h = gca;
h.XTickLabel = tpI2.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';

%%
view(tpI2,'Mode','graph');






















