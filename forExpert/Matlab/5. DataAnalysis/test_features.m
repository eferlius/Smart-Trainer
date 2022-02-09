%% computes the feature for each channel

close all; clear all; clc;

aa_userDefinition

%% loading the file
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));

% using friendly names
timeArray = serialData(:,1);
EMGsignals = serialData(:,2:5);
labels = serialData(:,end);

% plot data
zz_plotEMGsignals([fileName, '-original'], timeArray, EMGsignals, labels);

%% filtering data
% declaring the filtering intensity
samplesBefore = round(secFiltering * frequency);
% filtering the signals
EMGsignalsFiltered = movmean(EMGsignals, [samplesBefore 0], 1);

% filtered signals
serialDataFiltered = [timeArray, EMGsignalsFiltered, labels];

%% feature computation
% definition of the sliding window
samplesWindow = round(secWindowAmplitude * frequency);

features = featuresComputation(EMGsignalsFiltered, samplesWindow);

%% plots 4 figures, one for each signal, with all the features
switchIndexes = [1 find((diff(labels')~=0) == 1) length(labels)];
colorLabels={'w','r','g','y','b'};
for i=1:4
    maximo(i)=max(EMGsignalsFiltered(:,i));
    minimo(i)=min(EMGsignalsFiltered(:,i));
end
for i = 1:4 % for every signal
    figure; hold on; grid on;
    plot(timeArray, EMGsignalsFiltered(:,i),'linewidth',2);
    for j = 1:width(features)/4 % for every feature
        if mod(j,width(features)/4) == 0 % the last feature is standard deviation
            plot(timeArray, features(:,j+(i-1)*width(features)/4)+minimo(i))
        else
            plot(timeArray, features(:,j+(i-1)*width(features)/4))
        end
    end
    title(['signal ', num2str(i)])
    
    % to plot the labels as well
    for k = 1 : length(switchIndexes)-1
        xmin = switchIndexes(k)*timeArray(end)/length(timeArray); xmax = switchIndexes(k+1)*timeArray(end)/length(timeArray);
        ymin = minimo(i); ymax = maximo(i);
        h = patch([xmin xmax xmax xmin], [ymin ymin ymax ymax], colorLabels{labels(switchIndexes(k)+1)+1});
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        alpha 0.2
    end
end
