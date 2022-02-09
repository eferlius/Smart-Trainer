%% real time signal classification - DEMO LOOP
% this is a DEMO to simulate the execution of the real time classifier.
% EVEN IF the whole test is already recorded, the loop execution for each
% sample is MANTAINED, to help the understanding of the process.
% for each acquired sample:
% - acquire the next sample
% - filtering according to the secondsBeforeFiltering
% - features computation according to the secondsBeforeWindow
% - classification of that sample
% - simulation of the sending labels at the given frequency
% - next step of the loop
%
% - debug plots

close all; clear all; clc;

%% setting the parameters from the other script
disp("loading classifier...")

aa_userDefinition

% load the classifer
% load(...) 
load('centroidCoordinates51_68_03SW.mat')
    
% load the file
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));


%% loop
loopExecuted = 0; numberOfDataAcquired = 0; numberOfLabelsSent = 0;

if displayPlot == true
    % figure initialization
    figure; q=tiledlayout(5,1,'tilespacing','none');
end
tStart = tic;
lastSend = 0;
while loopExecuted < length(serialData)
    
    loopExecuted = loopExecuted + 1;
    
    % continously reading the data
    % [time in seconds, V1, V2, V3, V4] % in the loaded file
    serialDataRead = serialData(loopExecuted,:);
    
    if length(serialDataRead) >= 5 % if new data are available
        numberOfDataAcquired = numberOfDataAcquired + 1;
        
        if loopExecuted == 1
            EMGsignals = serialDataRead(2:5); % new data are saved
            time_array =serialDataRead(1); % the time is referred to the saved one
        else
            % saving the new data
            EMGsignals(end+1,:) = serialDataRead(2:5); % new data are saved
            time_array(end+1) =serialDataRead(1); % the time is referred to the one on the test
        end
        
        % filtering the signal
        if loopExecuted == 1
            EMGsignalsFiltered = EMGsignals;
        else
            samplesBeforeFiltering = sum(time_array >= time_array(end)-secFiltering);
            tmp = movmean(EMGsignals, [samplesBeforeFiltering 0], 1);
            EMGsignalsFiltered(end+1,:) = tmp(end,:);
        end
        
        % features computation
        if loopExecuted == 1
            tmp = featuresComputation(EMGsignalsFiltered, 1);
            features = tmp(end,:);
        else
            samplesBeforeFeatures = sum(time_array >= time_array(end)-secWindowAmplitude);
            tmp = featuresComputation(EMGsignalsFiltered, samplesBeforeFeatures);
            features(end+1,:) = tmp(end,:);
        end
        
        
        
        % label
        if loopExecuted == 1
            labels_array = 0;
        else
            labels_array(end+1) = KmeansFCN(centroidCoordinates, features(end,:));
            %             labels_array(end+1) = classifier.predictFcn(features(end,:));
        end
        %         toc(tStart)
    end
    
    if time_array(end) > lastSend + sendingTime
        numberOfLabelsSent = numberOfLabelsSent + 1;
        
        % update the time
        lastSend = time_array(end);
        
        if numberOfLabelsSent == 1
            labelToSend = 0;
            labelsToSend = 0;
            timeSent = lastSend;
        else
            % find the label to be sent
            samplesBeforeLabel = sum(time_array >= time_array(end)-secondsBeforeLabel-sendingTime);
            labelToSend = postProc_findLabel(labels_array(end-samplesBeforeLabel+1:end), time_array(end-samplesBeforeLabel+1:end), secondsThresholdActivation, labelsToSend(end),features(:,10));
            labelsToSend(end+1) = labelToSend;
            timeSent(end+1) = lastSend;
        end
        
        % to show to the user
        frequencyOfThisLoop = ceil(sum(time_array >= time_array(end)-secondsBeforeLabel-sendingTime)/sendingTime);
        disp(['mov detected = ', num2str(labelToSend), ' at ', num2str(frequencyOfThisLoop), ' Hz']);
        
        
        if sendTCPIP == true
            % sending to the tcpip
            fopen(tcpipClient);
            fwrite(tcpipClient,num2str(labelToSend));
            fclose(tcpipClient);
        end
        
        if displayPlot == true
            
            % seeing how many elements in the last secondsBeforeFigure
            time_array_forFigure = time_array(find(time_array >= max(0, time_array(end)-secondsBeforeFigure)));
            samplesBeforeFigure=length(time_array_forFigure);
            
            for signal = 1:4
                nexttile(signal);
                cla(q); hold on; grid on;
                plot(time_array_forFigure, EMGsignalsFiltered(end-samplesBeforeFigure+1:end,signal),'.-');
                xlim([time_array_forFigure(1) time_array_forFigure(end)+1])
            end
            
            % plotting the label as well
            nexttile(5)
            cla(q); hold on; grid on;
            plot(time_array_forFigure, labels_array(end-samplesBeforeFigure+1:end),'.-');
            if width(serialData==6)
                plot(serialData(:,1), serialData(:,6))
            end
            plot(timeSent, labelsToSend, 'o', 'linewidth', 3)
            ylim([-1 5])
            xlim([time_array_forFigure(1) time_array_forFigure(end)+1])
            
            pause(1) % to make the visualization more fluid
        end
        
        
        % deleting all the elements older than back seconds
        
        % seeing how many elements in the last backSeconds
        time_array_forFigure = time_array(find(time_array >= max(0, time_array(end)-secondsBeforeFigure)));
        samplesBeforeFigure = length(time_array_forFigure);
        % delete all the elements from the arrays
        time_array = time_array(max(1,end-samplesBeforeFigure):end);
        EMGsignals = EMGsignals(max(1,end-samplesBeforeFigure):end,:);
        EMGsignalsFiltered = EMGsignalsFiltered(max(1,end-samplesBeforeFigure):end,:);
        features = features(max(1,end-samplesBeforeFigure):end,:);
        labels_array = labels_array(max(1,end-samplesBeforeFigure):end);
        labelsToSend = labelsToSend(max(1,end-samplesBeforeFigure):end);
        timeSent = timeSent(max(1,end-samplesBeforeFigure):end);
        pause(1-toc(tStart))
        toc(tStart)
    end
    
end

%% debug information
tEnd = toc(tStart);
loopExecuted
numberOfDataAcquired
numberOfLabelsSent

frequency = numberOfDataAcquired / tEnd