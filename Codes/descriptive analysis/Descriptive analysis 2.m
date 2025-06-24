clc; clear;

data = dlmread('bankloan.csv', ',',1,0);
%%
% Extract Features & Target Variable
X = data(:, 1:8);% Features
Y = data(:, 9);   % Default Status (Target)
% Split Data into Training & Testing (80-20 Split)
rng(123);
P = cvpartition(Y, 'Holdout', 0.2);

train.X = X(P.training, :);
train.Y = Y(P.training);

%%
% Example: Education Levels (1-5) and Default Status (0 = No Default, 1 = Default)
education = train.X(:,2)
defaultStatus = train.Y


rho=corr(education,defaultStatus,'type','spearman')
%% Segmented Bar Chart of Education Level vs Default Status

% Example Data: Education Levels (1-5) and Default Status (0/1)
education = train.X(:,2);
defaultStatus = train.Y;

% Count occurrences of Default (1) and No Default (0) for each education level
categories = unique(education);  % Find unique education levels (1 to 5)
counts = zeros(length(categories), 2);  % Initialize count matrix

for i = 1:length(categories)
    counts(i, 1) = sum(defaultStatus(education == categories(i)) == 0);  % Count Non-Defaulters (0)
    counts(i, 2) = sum(defaultStatus(education == categories(i)) == 1);  % Count Defaulters (1)
end

% Convert counts to percentages for each education level
percentages = zeros(size(counts));  % Initialize the percentage matrix

for i = 1:length(categories)
    total = sum(counts(i, :));  % Total customers for the current education level
    if total > 0
        percentages(i, :) = counts(i, :) / total * 100;  % Calculate the percentage for Non-Defaulters and Defaulters
    end
end


% Create segmented (stacked) bar chart with percentages
figure;
b= bar(categories, percentages, 'stacked');

b(1).FaceColor = [0 0.447 0.741]; % Blue for No Default (0)
b(2).FaceColor = [0.75 0.325 0.098]; % Red-Orange for Default (1)

% Customize appearance
title('Segmented Bar Chart of Education Level vs Default Status');
xlabel('Education Level');
ylabel('Percentage of Customers (%)');
legend({'No Default (0)', 'Default (1)'}, 'Location', 'northwest');
grid on;

%% pie chart of education levels 

% Example Data: Education Levels (1-5)
education = train.X(:,2);  % Assuming education levels are in the second column

% Count occurrences of each education level (1, 2, 3, 4, 5)
categories = 1:5;  % Education levels from 1 to 5
counts = zeros(1, length(categories));  % Initialize count array

for i = 1:length(categories)
    counts(i) = sum(education == categories(i));  % Count occurrences of each level
end

% Create pie chart
figure;
pie(counts, categories);

% Customize appearance
%title('Pie Chart of Education Levels'); 
legend({'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'}, 'Location', 'best');

%% correlation heatmap 

r = corr([train.X, train.Y], 'rows', 'pairwise')
isupper = logical(triu(ones(size(r)),1));
r(isupper) = NaN


labels = { 'age', 'edu' ,'employee' ,'address',	'income', 'debtinc'	,'creddebt'	,'othdebt','default' };

figure;
imagesc(r); % Display correlation matrix as an image
set(gca, 'XTick', 1:11); % center x-axis ticks on bins
set(gca, 'YTick', 1:11); % center y-axis ticks on bins
set(gca, 'XTickLabel', labels); % set x-axis labels
set(gca, 'YTickLabel',labels); % set y-axis labels
title('Correlation Heatmap', 'FontSize', 10); % set title
colormap('jet'); % Choose jet or any other color scheme



h=colorbar;
% Label color changes in the colorbar
caxis([-1, 1]);  % Set color scale range to match correlation values
set(h, 'Ticks', [-1, -0.5, 0, 0.5, 1]);  % Set specific colorbar tick positions
set(h, 'TickLabels', {'Strong Negative (-1)', 'Moderate Negative (-0.5)', 'No Correlation (0)', 'Moderate Positive (0.5)', 'Strong Positive (1)'});  % Custom labels for colorbar



% Add correlation values, but skip NaNs
[m, n] = size(r);
for i = 1:m
    for j = 1:n
        if ~isnan(r(i, j))  % Skip NaN values
            text(j, i, sprintf('%.2f', r(i, j)), ...
                'HorizontalAlignment', 'center', 'Color', 'w', 'FontSize', 10, 'FontWeight', 'bold');
        end
    end
end


