close all; clear all; clc;
% to load a test, trasform it into timetable and to load the signalAnalyzer
aa_userDefinition

% modality 1:
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));
% % modality 2:
% testNum = 27;
% stringToMatch = sprintf('*%s*.mat',[num2str(testNum,'%03.f'),'_p',]);
% filesMatching = dir(fullfile(dataDirectory,stringToMatch));
% fileName = filesMatching.name;
% load data
load(fullfile(filesDirectory,fileName));

% using friendly names
timeArray = serialData(:,1);
EMGsignals = serialData(:,2:5);
labels = serialData(:,end);

% conversion to time table 
TT = array2timetable(EMGsignals,'TimeStep', seconds(1/frequency));

%% opening signal Analyzer
signalAnalyzer