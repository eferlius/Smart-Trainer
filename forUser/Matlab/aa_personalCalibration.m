close all; clear all; clc;

% uses "record" function to record data for a given time
% returns the serialData recorderd in a matrix and the labels requested
% during the test

% to enable some parameters and not others in aa_userDefinition
personalCalibration = true;
realTimeClassifier = false;
aa_userDefinition

again = 1;
while again == 1
    movement = 1;
    while movement <= 4
        tmp = menu(strcat('I am ready to perform a test of: ', num2str(numberOfRep),  ...
            ' reps of the movement:"',instructions{movement}, '" every:', ...
            num2str(secToMove), ' s for a total duration of:', num2str(secDuration), ' s.'), 'ok')
        %% selection of the test
        % selection of the test
        subject = 'CALIB_';
        % getting the test number
        stringToMatch = '*.mat';
        filesMatching = dir(fullfile(filesDirectory,stringToMatch));
        testNumber = numel(filesMatching) + 1;
        % getting the trial number
        stringToMatch = sprintf('*%s*.mat',['p',num2str(subject,'%02.f'),'mov',num2str(movement,'%02.f')]);
        filesMatching = dir(fullfile(filesDirectory,currDate,stringToMatch));
        trialNumber = numel(filesMatching) + 1;
        % obtaining the fileName
        fileName = [num2str(testNumber,'%03.f'),'_','p',num2str(subject,'%02.f'),'mov',num2str(movement,'%02.f'),'_',num2str(trialNumber,'%02.f')]
        
        %% recording the data
        [serialData, label_array, realDuration] = record(COM, frequency, secDuration, movement, secToMove, false);
        
        time_array = serialData(1:end,1);
        EMGsignals = serialData(:,2:end);
        
        %% display the acquired signals
        % plot 1
%         figure; hold on; grid on; plot(time_array, EMGsignals', '.-')
%         title(fileName,'Interpreter', 'none'); legend('signal 1', 'signal 2', 'signal 3', 'signal 4');
        
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
            movement = movement + 1; % so increment the movement
        else
            disp('Test is discarded');
            % so don't increment the movement
        end
        close all;
    end
    again = menu('Do you want to perform another round of calibration?', {"yes", "no"});
end

%% train classifier
% load all the tests in the folder to create the database

stringToMatch = '*.mat';
filesMatching = dir(fullfile(filesDirectory,stringToMatch));

dataBase = zeros(1,Nfeatures+2); % <------- = time + N features + label

for testNum = [1:numel(filesMatching)]
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
    
    % plotEMGsignals("features comparison", timeArray, features, labels)
    dataBase = [dataBase; timeArray, features, labels];
end
dataBase = dataBase(2:end,:);

% computing the centroids
disp('training the algorithm...')
Training = dataBase(:,2:end); % features + label

tic;
for i = 0:1:4
    indexes = (find(Training(:,end) == i));
    centroidCoordinates(i+1,:) = mean(Training(indexes,1:end-1));
end
toc;


name = ['KM_F',num2str(secFiltering), '_Wamp', num2str(secWindowAmplitude), '_Nfeat', num2str(Nfeatures)];
name = strrep(name,'.','');
save([filesDirectory,'\',name], 'centroidCoordinates')
disp(['Classificator is saved with the name "', name, '"'])
disp(['in the folder ->', filesDirectory])