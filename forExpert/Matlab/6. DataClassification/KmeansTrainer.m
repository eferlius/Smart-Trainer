close all; clear all; clc;

% loads a database and computes the centroids position


Training = dataBase(:,2:end); % features + label

tic;
for i = 0:1:4
    indexes = (find(Training(:,end) == i));
    centroidCoordinates(i+1,:) = mean(Training(indexes,1:end-1));
end
toc;

centroidCoordinates

save(...,'centroidCoordinates')