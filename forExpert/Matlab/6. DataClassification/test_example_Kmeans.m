close all; clear all; clc;

nFeat = 2; nSamp = 20;
features = [rand(nSamp ,nFeat); rand(nSamp ,nFeat)+1; rand(nSamp ,nFeat)+2;rand(nSamp ,nFeat)+3; rand(nSamp ,nFeat)+4];
labels = [ones(nSamp,1)*0; ones(nSamp,1)*1; ones(nSamp,1)*2; ones(nSamp,1)*3; ones(nSamp,1)*4];
figure; hold on; grid on;
for i = 0:4
    plot(features(nSamp*i+1:nSamp*(i+1),1),features(nSamp*i+1:nSamp*(i+1),2),'o')
end

dataBase = [features, labels];

for i = 0:1:4
    indexes = (find(dataBase(:,end) == i));
    centroidCoordinates(i+1,:) = mean(dataBase(indexes, 1:end-1));
end

for i = 0:4
    plot(centroidCoordinates(i+1,1),centroidCoordinates(i+1,2),'x', 'linewidth', 2)
end

label = KmeansFCN(centroidCoordinates, [1.5 1.5; 2.5 2.5; 3.5 3.5])