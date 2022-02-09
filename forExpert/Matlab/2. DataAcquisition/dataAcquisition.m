close all; clear all; clc;

% uses "record" function to record data for a given time
% returns the serialData recorderd in a matrix and the labels requested
% during the test

aa_userDefinition

%% selection of the test
% selecting the subject that will perform the test
subject = menu('Select the tester:', subjects);
% selecting the movement that will be performed
movement = menu('Select the performed movement:', movements);

% getting the test number
stringToMatch = '*.mat';
filesMatching = dir(fullfile(filesDirectory,stringToMatch));
testNumber = numel(filesMatching) + 1;
% getting the trial number
stringToMatch = sprintf('*%s*.mat',['p',num2str(subject,'%02.f'),'mov',num2str(movement,'%02.f')]);
filesMatching = dir(fullfile(filesDirectory,stringToMatch));
trialNumber = numel(filesMatching) + 1;
% obtaining the fileName
fileName = [num2str(testNumber,'%03.f'),'_','p',num2str(subject,'%02.f'),'mov',num2str(movement,'%02.f'),'_',num2str(trialNumber,'%02.f')]

%% recording the data
[serialData, label_array, realDuration] = record(COM, frequency, secDuration, movement, secToMove, true);

time_array = serialData(1:end,1);
EMGsignals = serialData(:,2:end);

%% display the acquired signals
% plot 1
figure; hold on; grid on; plot(time_array, EMGsignals', '.-')
title(fileName,'Interpreter', 'none'); legend('signal 1', 'signal 2', 'signal 3', 'signal 4');

% plot 2
zz_plotEMGsignals(fileName, time_array, EMGsignals)

%% automatic labelization
confirm = 2
while confirm == 2
    labelSecDuration = input('Insert the label duration for classification [check duration on the plots]: ');
    
    % labelize data
    labels =zeros(frequency*secDuration,1);
    for j = 1:secDuration
        if mod(j,secToMove)==0
            labels(j*frequency:j*frequency+frequency*labelSecDuration,1) = label_array(j) * ones(frequency*labelSecDuration+1,1);
        end
    end
    
    labels = labels(1:length(EMGsignals),:);
    zz_plotEMGsignals(fileName, time_array, EMGsignals, labels)
    confirm = menu('Check if the labelization is correct. Proceed?', {"yes", "change duration"});
end
serialData = [time_array, EMGsignals, labels];

%% saving data and logging into the csv file
saveYN = menu(['Test will be saved with the name "', fileName, '"'] ,{"confirm", "discard"});
if (saveYN == 1)
    save([filesDirectory,'\',fileName],'serialData')
    noteYN = menu(['Do you want to add notes into the csv files?'] ,{"yes", "no"});
    note="";
    if (noteYN == 1)
        note=input("Insert here the note:",'s');
    end
    order = string(label_array);
    results = {testNumber, datetime, frequency, secDuration, realDuration, subject, movement, trialNumber, order, note};
    writecell(results, [filesDirectory,'\','testsLog.csv'], 'WriteMode', 'append');
    disp(['The file is saved with the name: "', fileName,'"'])
end
close all;

