close all; clear all; clc;

aa_userDefinition;
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));

secondsBeforeFiltering = 0.02;
samplesBeforeFiltering = secondsBeforeFiltering*frequency;

serialDataFiltered = movmean(serialData(:,2:5), [samplesBeforeFiltering 0], 1);

figure; q=tiledlayout(4,1,'tilespacing','none');
for signal = 1:4
    nexttile(signal); hold on; grid on;
    plot(serialData(:,1), serialData(:,signal+1),'.-');
    plot(serialData(:,1), serialDataFiltered(:,signal),'.-');
end

serialData = [serialData(:,1) serialDataFiltered];