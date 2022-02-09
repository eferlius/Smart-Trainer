close all; clear all; clc;

% loads a database, divide it in training and test, computes the centroids
% and evaluate the performances

% load the database
load()

% division in Training and Test
Training = dataBase(1:length(dataBase)*0.8,2:end); % features + label

Test = dataBase(length(dataBase)*0.8+1:end, 2:end); % features + label

% centroid computation
for i = 0:1:4
    indexes = (find(Training(:,end) == i));
    centroidCoordinates(i+1,:) = mean(Training(indexes,1:end-1));
end

centroidCoordinates

% test
ypredicted = KmeansFCN(centroidCoordinates, Test(:,1:end-1));
labels = Test(:,end);

accuracy = (sum(ypredicted' == labels))/length(labels)

figure
confusionchart(labels,ypredicted)