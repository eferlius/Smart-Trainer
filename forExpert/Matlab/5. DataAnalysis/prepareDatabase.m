close all; clear all; clc;

%% to load multiple files, filter the signals, compute the features and create a dataSet for training 

aa_userDefinition

% modality 1:
% fileName = uigetfile(filesDirectory)
% modality 2:
dataBase = zeros(1,18); % <------- N features + 2 = time + N features + label
for testNum = [51:82]
    testNum
    stringToMatch = sprintf('*%s*.mat',[num2str(testNum,'%03.f'),'_p',]);
    filesMatching = dir(fullfile(filesDirectory,stringToMatch));
    fileName = filesMatching.name;
    % load data
    load(fullfile(filesDirectory,fileName));
    
    % using friendly names
    timeArray = serialData(:,1);
    EMGsignals = serialData(:,2:5);
    labels = serialData(:,end);
    
    % plot data
    % plotEMGsignals([fileName, '-original'], timeArray, EMGsignals, labels);
    
    %% filtering data
    samplesBefore = round(secFiltering * frequency);
    % filtering the signals
    EMGsignalsFiltered = movmean(EMGsignals, [samplesBefore 0], 1);
    
    % % plotting
    % for i = 1:width(EMGsignalsFiltered)
    %     % version 1
    %     nexttile(i); hold on; grid on;
    %     % plot the signal
    %     plot(timeArray, EMGsignalsFiltered(:,i),'linewidth',1,'DisplayName',num2str(secondsBefore));
    %     legend('-DynamicLegend');
    %     legend('show');
    % end
    
    % filtered signals
    serialDataFiltered = [timeArray, EMGsignalsFiltered, labels];
    
    %% feature computation
    samplesWindow = round(secWindowAmplitude * frequency);
    features = featuresComputation(EMGsignalsFiltered, samplesWindow);
    
    % plotEMGsignals("features comparison", timeArray, features, labels)
    dataBase = [dataBase; timeArray, features, labels];
end
dataBase = dataBase(2:end,:);

%% now database should be saved