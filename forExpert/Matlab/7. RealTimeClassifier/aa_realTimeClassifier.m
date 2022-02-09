%% real time signal classification
% ARDUINO: at a fixed frequency (200 Hz) writes on the serial port the
% values or the two potentiometers
% MATLAB: acquires the 4 voltages and decides which label is used
%
% plots the values of the 4 EMGS, the label for each sample and
% sends, every sendingTime (set in user definition) the label on the tcpip
% net

close all; clear all; clc;

%% setting the parameters from the other script
% to enable some parameters and not others in aa_userDefinition
personalCalibration = false;
realTimeClassifier = true;
aa_userDefinition

% loading the classifier
dateFolder = '05-Jan-2022 17_38_47'
classifierName = 'KM_F002_Wamp03_Nfeat16'; % copy inside here
load([dataDirectory,'\',dateFolder,'\',classifierName]);

%% definition of the serial device
clear device; device = serialport(COM,115200)

if sendTCPIP == true
    tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
    set(tcpipClient,'Timeout',30);
end

zz_pausing(3,"to give time to the serial port to establish the connection properly");

% frequency for data displaying is not necessary, data are displayed as
% soon as possible, only a little pause is put in the while loop to
% make the visualization as fluid as possible

if displayPlot == true
    % figure initialization
    figure; q=tiledlayout(5,1,'tilespacing','none');
end

%% loop
loopExecuted = 0; numberOfDataAcquired = 0; numberOfLabelsSent = 0;

tStart = tic;
tSend = tic;

while toc(tStart)<secDuration
    loopExecuted = loopExecuted + 1;
    
    % continously reading the data
    % [time in microseconds, V1, V2, V3, V4]
    serialDataRead = str2num(readline(device));
    
    % flushing the device, the old data are eliminated, so always the
    % latest data is available
    flush(device,"input");
    
    if length(serialDataRead) >= 5 % if new data are available
        numberOfDataAcquired = numberOfDataAcquired + 1;
        
        % saving the new data
        if numberOfDataAcquired == 1
            EMGsignals = serialDataRead(2:5); % new data are saved
            time_array = toc(tStart); % the time is referred to the saved one
        else
            EMGsignals(end+1,:) = serialDataRead(2:5); % new data are saved
            time_array(end+1) = toc(tStart); % the time is referred to the one on the test
        end
        
        % filtering the signal
        if numberOfDataAcquired == 1
            EMGsignalsFiltered = EMGsignals;
        else
            samplesBeforeFiltering = sum(time_array >= time_array(end)-secFiltering);
            tmp = movmean(EMGsignals, [samplesBeforeFiltering 0], 1);
            EMGsignalsFiltered(end+1,:) = tmp(end,:);
        end
        
        % features computation
        if numberOfDataAcquired == 1
            tmp = featuresComputation(EMGsignalsFiltered, 1);
            features = tmp(end,:);
        else
            samplesBeforeFeatures = sum(time_array >= time_array(end)-secWindowAmplitude);
            tmp = featuresComputation(EMGsignalsFiltered, samplesBeforeFeatures);
            features(end+1,:) = tmp(end,:);
        end
        
        % label
        if numberOfDataAcquired == 1
            labels_array = 0;
        else
            labels_array(end+1) = KmeansFCN(centroidCoordinates, features(end,:));
        end
        
        if displayPlot == true
            
            % seeing how many elements in the last secondsBeforeFigure
            time_array_forFigure = time_array(find(time_array >= max(0, time_array(end)-secondsBeforeFigure)));
            samplesBeforeFigure=length(time_array_forFigure);
            
            for signal = 1:4 % since signals are written in position 1 and 2
                nexttile(signal);
                cla(q); hold on; grid on;
                plot(time_array_forFigure, EMGsignalsFiltered(end-samplesBeforeFigure+1:end,signal),'.-');
                %                 ylim([290 330])
                xlim([time_array_forFigure(1) time_array_forFigure(end)+1])
            end
            
            % plotting the label as well
            nexttile(5)
            cla(q); hold on; grid on;
            plot(time_array_forFigure, labels_array(end-samplesBeforeFigure+1:end),'.-');
            ylim([-1 5])
            xlim([time_array_forFigure(1) time_array_forFigure(end)+1])
            
            pause(0.001) % to make the visualization more fluid
        end
        %         toc(tStart)
    end
    
    if toc(tSend) > sendingTime
        numberOfLabelsSent = numberOfLabelsSent + 1;
        
        % update the time
        tSend = tic;
        
        if numberOfLabelsSent == 1
            labelToSend = 0;
        else
        % find the label to be sent
        samplesBeforeLabel = sum(time_array >= time_array(end)-secondsBeforeLabel-sendingTime);
        labelToSend = findLabel(labels_array(end-samplesBeforeLabel+1:end), time_array(end-samplesBeforeLabel+1:end), secondsThresholdActivation, labelToSend);
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

        % deleting all the elements older than secondsBeforeFigure
        
        % seeing how many elements in the last backSeconds
        time_array_forFigure = time_array(find(time_array >= max(0, time_array(end)-secondsBeforeFigure)));
        samplesBeforeFigure=length(time_array_forFigure);
        % delete all the elements from the arrays
        time_array = time_array(max(1,end-samplesBeforeFigure):end);
        EMGsignals = EMGsignals(max(1,end-samplesBeforeFigure):end,:);
        EMGsignalsFiltered = EMGsignalsFiltered(max(1,end-samplesBeforeFigure):end,:);
        features = features(max(1,end-samplesBeforeFigure):end,:);
        labels_array = labels_array(max(1,end-samplesBeforeFigure):end);
    end
end

%% debug information
tEnd = toc(tStart);
loopExecuted
numberOfDataAcquired
numberOfLabelsSent

frequency = numberOfDataAcquired / tEnd
