close all; clear all; clc;

aa_userDefinition;
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));


serialDataDownSampled = downSampling(serialData, 30);

figure; q=tiledlayout(4,1,'tilespacing','none');
for signal = 1:4
    nexttile(signal); hold on; grid on;
    plot(serialData(:,1), serialData(:,signal+1),'.-');
    plot(serialDataDownSampled(:,1), serialDataDownSampled(:,signal+1),'.-');
end

serialData = serialDataDownSampled;