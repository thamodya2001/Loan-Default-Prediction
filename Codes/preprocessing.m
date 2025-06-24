clc; clear;

data = dlmread('bankloan.csv', ',',1,0);


% Check for missing values
missingValues = isnan(data); % Count missing values per column
missingV=sum(missingValues(:))


% to check duplicate 
duplicate= unique(data)

% check for NaN values 

data(any(isnan(data), 2), :) = []; % remove the NaN rows 

% dropping variables 'ncust' and 'customer'
data(:,2:3)=[];

% filter data according to response variable 
% def= previously defaulted
% not_def = previously not defaulted 
def= data(data(:,10)==1);
not_def= data(data(:,10)==0);


