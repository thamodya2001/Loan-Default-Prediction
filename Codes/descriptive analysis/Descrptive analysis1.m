clc; clear;

% Load Data
Data = dlmread('bankloan.csv', ',', 'A2..L1501');

%% Extract Features & Target Variable
X = Data(:, 1:11); % Features
Y = Data(:, 12);   % Default Status (Target)

%% education group 

x = nominal(X(:,5));
%%
count1=sum(x == '1');
count2=sum(x == '2');
count3=sum(x == '3');
count4=sum(x == '4');
count5=sum(x == '5');
pie([count1 , count2,count3,count4 , count5]);

legend({'1',' 2', '3','4 ','5'}, 'Location', 'southoutside', 'Orientation', 'horizontal');
title('Pie Chart of Edu level');

%% Income group

income_threshold = median(train.income); 
% Create Income Categories
income_group=nominal(zeros());
income_group(train.income <= income_threshold) = 'Low Income';  
income_group(train.income > income_threshold) = 'High Income'; 
%% Convert Default Status to Categorical
default_group = categorical(Y, [0 1], {'Not Default', 'Default'});

%% Split Data into Training & Testing (80-20 Split)
rng(123);
P = cvpartition(Y, 'Holdout', 0.2);

train.X = X(P.training, :);
train.Y = default_group(P.training);

%% Pie Chart for Default Distribution 
default_counts = sum(train.Y == 'Default');
not_default_counts = sum(train.Y == 'Not Default');

figure;
pie([default_counts, not_default_counts]);
legend({'Default', 'Not Default'}, 'Location', 'southoutside', 'Orientation', 'horizontal');
title('Pie Chart of Default and Not Default Count');
colormap([0 0.7 0.8; 0.9 0.5 0]);
%% Age boxplot 

figure;
boxplot(train.X(:,4), train.Y);
title('Age Distribution Among Defaulters and Non-Defaulters');
xlabel('Default Status');
ylabel('Age');
grid on;

%% emply boxplot 
figure;
boxplot(train.X(:,6), train.Y);
title('years of employ Distribution Among Defaulters and Non-Defaulters');
xlabel('Default Status');
ylabel('years of employ');
grid on;

%% Boxplot of address 
figure;
boxplot(train.X(:,7), train.Y);
title(' Years at current address by Default Status');
xlabel('Default Status');
ylabel('Years at current address');
grid on;

%% Income 

train.income = train.X(:,8);

train.Y = default_group(P.training);

%% Data for Histograms
inc_not_default = train.income(train.Y == 'Not Default'); 
inc_default = train.income(train.Y == 'Default'); 


figure;

% Histogram for Non-Defaulters
subplot(1,2,1); 
histogram(inc_not_default, 'FaceColor', [0.2 0.6 1], 'FaceAlpha', 0.7);
title('Non-Defaulters');
xlabel('Income (in thousands)');
ylabel('Count');
grid on;


subplot(1,2,2); 
histogram(inc_default, 'FaceColor', [1 0.4 0.4], 'FaceAlpha', 0.7); 
title(' Defaulters');
xlabel('Income (in thousands)');
ylabel('Count');
grid on;
%% boxplot of income 
figure;
boxplot(train.X(:,8), train.Y);
title('income  Distribution Among Defaulters and Non-Defaulters');
xlabel('Default Status');
ylabel('income ( in thousand) ');
grid on;


%%
train.income_group = income_group';


%% pie chart for income group
count_income=[low_inc_default+low_inc_not_default  high_inc_not_default+high_inc_default]
pie(count_income)
legend({'High', 'Low'}, 'Location', 'southoutside', 'Orientation', 'horizontal');
title('Pie Chart of income group');

%% 
train.debt_inc = train.X(:,9);
train.Y = default_group(P.training);

%% Boxplot for Debt-to-Income Ratio by Default Status
figure;
boxplot(train.debt_inc, train.Y);
title('Debt-to-Income Ratio by Default Status');
xlabel('Default Status');
ylabel('Debt-to-Income Ratio (%)');
grid on;

%% Overlapping Histogram for Debt-to-Income Ratio
figure;
hold on;
histogram(train.debt_inc(train.Y == 'Not Default'), 'FaceColor', [0.2 0.6 1], 'FaceAlpha', 0.5);
histogram(train.debt_inc(train.Y == 'Default'), 'FaceColor', [1 0.4 0.4], 'FaceAlpha', 0.5);
hold off;
title('Debt-to-Income Ratio Distribution for Defaulted vs. Non-Defaulted Customers');
xlabel('Debt-to-Income Ratio (%)');
ylabel('Count');
legend({'Not Default', 'Default'}, 'Location', 'northeast');
grid on;
%%


%% 
train.credit_debt = train.X(:,10);
train.Y = default_group(P.training);

%% Boxplot for credit card debt  by Default Status
figure;
boxplot(train.credit_debt, train.Y);
title('Credit card debt by Default Status');
xlabel('Default Status');
ylabel('Credit card debt in thousands ');
grid on;

%% Overlapping Histogram for credit debt Ratio
figure;
hold on;
histogram(train.credit_debt(train.Y == 'Not Default'), 'FaceColor', [0.2 0.6 1], 'FaceAlpha', 0.5);
histogram(train.credit_debt(train.Y == 'Default'), 'FaceColor', [1 0.4 0.4], 'FaceAlpha', 0.5);
hold off;
title('Credit card Debt Distribution for Defaulted vs. Non-Defaulted Customers');
xlabel('Credit card debt in (thousands)');
ylabel('Count');
legend({'Not Default', 'Default'}, 'Location', 'northeast');
grid on;
%%

train.other_debt = train.X(:,11);


%% Boxplot for other debt by Default Status
figure;
boxplot(train.other_debt, train.Y);
title('Other debt by Default Status');
xlabel('Default Status');
ylabel('Other debt in thousands ');
grid on;

%%  Overlapping Histogram for other debt 
figure;
hold on;
histogram(train.other_debt(train.Y == 'Not Default'), 'FaceColor', [0.2 0.6 0.2], 'FaceAlpha', 0.5);
histogram(train.other_debt(train.Y == 'Default'), 'FaceColor', [1 0.4 0.4], 'FaceAlpha', 0.5);
hold off;
title('other Debt Distribution for Defaulted vs. Non-Defaulted Customers');
xlabel('other card debt in (thousands)');
ylabel('Count');
legend({'Not Default', 'Default'}, 'Location', 'northeast');
grid on;
%%
train.Total_debt=train.other_debt+train.credit_debt
% Boxplot for total debt
figure;
boxplot(train.Total_debt, train.Y);
title('Total debt by Default Status');
xlabel('Default Status');
ylabel('Total debt in thousands ');
grid on;

%%  Overlapping Histogram for Total Debt
figure;
hold on;
histogram(train.Total_debt(train.Y == 'Not Default'), 'FaceColor','cyan', 'FaceAlpha', 0.5);
histogram(train.Total_debt(train.Y == 'Default'), 'FaceColor', [1 0.4 0.4], 'FaceAlpha', 0.5);
hold off;
title('Total Debt Distribution for Defaulted vs. Non-Defaulted Customers');
xlabel('Total debt in (thousands)');
ylabel('Count');
legend({'Not Default', 'Default'}, 'Location', 'northeast');
grid on;



%%

Total_debt=Data(:,10)+Data(:,11)
numerical_data = [Data(:,4) Data(:,6:9) Total_debt];  

var_names = ['Age',  'Employ', 'Address', 'Income', 'Debt_Inc', 'Total Debt'];

%% Compute Correlation Matrix
corr_matrix = corr(numerical_data, 'Rows', 'complete');



%%
X = [Data(:, [4, 5 ,6, 7, 8, 9]) Total_debt ];  % Age, Edu Level, Employ, Address, Income, Debt_Inc, Total_Debt
Y = Data(:, 12);  
%% spearman correlation 
[rho pval]=corr(X(P.training,:),Y(P.training),'type','spearman')
%%
% testing the significance
pval<0.05 
pval<0.01
