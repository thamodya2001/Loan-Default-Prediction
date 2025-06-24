% calculate no of outliers using numerical variables 

clc; clear;

data = dlmread('bankloan.csv', ',',1,3);

% Extract Features & Target Variable
X = data(:, 1:8);% Features
Y = data(:, 9);   % Default Status (Target)
% Split Data into Training & Testing (80-20 Split)
rng(123);
P = cvpartition(Y, 'Holdout', 0.2);

train.X = X(P.training, :);
train.Y = Y(P.training);

%%

% frequency encoding for education level categorical variable make it into
% numerical 
edu = train.X(:,2);

% Compute frequency of each unique education level
[uniqueEdu, ~, eduIndices] = unique(edu);  
eduCounts = histcounts(eduIndices, length(uniqueEdu));  
eduFrequencyEncoding = eduCounts(eduIndices) / length(edu);  % Normalize to get proportion


train.X(:, 2) = eduFrequencyEncoding;


% Load or generate sample data (Replace with your dataset)
rng(1); % For reproducibility

data = normc(train.X)
%%
% Compute mean and covariance matrix
meanData = mean(data);
covMatrix = cov(data);

% Compute Mahalanobis Distance
distances = mahal(data, data);

% Set threshold using Chi-square distribution (95% confidence, df = number of variables)
threshold = chi2inv(0.95, size(data,2));

% Identify outliers
outliers = distances > threshold;

% Count outliers
num_outliers = sum(outliers);

% Display results
fprintf('Number of outliers: %d\n', num_outliers);
