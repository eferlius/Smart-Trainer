%% real time signal classification - DEMO LOOP
% this is a DEMO to simulate the execution of the real time classifier.
% SINCE the whole test is already recorded, the loop execution for each
% sample is ELIMINATED, to show immediately the results
% - acquire the next sample
% - filtering according to the secondsBeforeFiltering
% - features computation according to the secondsBeforeWindow
% - classification of that sample
% - simulation of the sending labels at the given frequency
% - next step of the loop
%
% - debug plots

close all; clear all; clc;

aa_userDefinition;

% load the classifer
% load(...) 
load('centroidCoordinates51_68_03SW.mat')

% load the file
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));


timeArray = serialData(:,1);
EMGsignals = serialData(:,2:5);
labels = serialData(:,end);
disp('computing...')
%% filtering the signals
% EMGsignalsFiltered = movmean(EMGsignals, [secondsBeforeFiltering*frequency 0], 1);
EMGsignalsFiltered = EMGsignals;
%% computing the features
features = featuresComputation(EMGsignalsFiltered,secWindowAmplitude*frequency);
%% classification of each sample
% labels_array = classifier.predictFcn(features);
labels_array = KmeansFCN(centroidCoordinates, features);
%% sending the label at each sendingTime
[labels_sent_array time_sent_array] = findLabelDemoNoLoop(labels_array, timeArray,  secondsThresholdActivation, sendingTime, secondsBeforeLabel);

% trying to send in a while loop the computed labels
% tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
% set(tcpipClient,'Timeout',30);
% for i = 1:length(time_sent_array)
%     disp(labels_sent_array(i))
%     fopen(tcpipClient);
%     fwrite(tcpipClient,num2str(labels_sent_array(i)));
%     fclose(tcpipClient);
%     pause(2)
% end
%% debug plots
% figure('Units','normalized','Position',[0 0 1 1])
nexttile; hold on; grid on;
plot(timeArray, labels_array,'.')
plot(timeArray, labels)
plot(time_sent_array, labels_sent_array, 'o', 'linewidth',5)
ylim([-1 5])
legend('real label', 'labels detected from the classifier', 'labels sent')
title([fileName, ' labels comparison'],'interpreter', 'none')


figure('Units','normalized','Position',[0 0 1 1]); q=tiledlayout(5,1,'tilespacing','none');
title(q, fileName, 'interpreter', 'none')
for signal = 1:4
    nexttile(signal);
    cla(q); hold on; grid on;
    plot(timeArray, EMGsignalsFiltered(:,signal),'.-');
end

% plotting the label as well
nexttile(5)
cla(q); hold on; grid on;
plot(timeArray, labels_array,'.');
if width(serialData==6)
    plot(serialData(:,1), serialData(:,6))
end
plot(time_sent_array, labels_sent_array, 'o', 'linewidth', 3)
ylim([-1 5])

disp('preparing figures...')
zz_plotEMGsignals(fileName, timeArray, EMGsignalsFiltered, labels_array)