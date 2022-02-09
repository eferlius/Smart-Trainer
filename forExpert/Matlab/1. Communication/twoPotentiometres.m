%% run with the arduino script of the same name: read_2pot
% ARDUINO: at a fixed frequency (200 Hz) writes on the SERIAL PORT the
% values or the two potentiometers
% MATLAB: acquires the 2 voltages and decides which label is used
%
% plots the values of the 2 potentiometers on the acquiring time of Matlab,
% the label for each sample and sends, every sendingTime
% (set in user definition) the label on the TCPIP net

close all; clear all; clc;

%% user definition
aa_userDefinition

%% initialization
% definition of the serial device
clear arduino; arduino = serialport(COM,115200)

if sendTCPIP == true
    % make sure there is an active tpcipServer
    tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
    set(tcpipClient,'Timeout',30);
end

zz_pausing(3,"to give time to the serial port to establish the connection properly");

% frequency for data displaying is not necessary, data are displayed as
% soon as possible, only a little pause is put in the while loop to
% make the visualization as fluid as possible

% in this matrix will be stored all the values read from the serial port
serialData = [0 0 0]; % only the voltages of the two potentiometers

% array with times from matlab tic toc
time_array = [0];

% array with labels
labels_array = [0];

labelsAcquired = [0];

% figure initialization
if displayPlot == true
    figure; q=tiledlayout(3,1,'tilespacing','none');
end

%% loop
tStart = tic;
tSend = tic;

while toc(tStart)<secDuration
    
    % continously reading the data
    serialDataRead = str2num(readline(arduino));
    
    % flushing the device, the old data are eliminated, so always the
    % latest data is available. Remember we use this only to display data, not to
    % acquire properly, otherwise it would be necessary to save the
    % arduino time
    flush(arduino,"input");
    
    if length(serialDataRead) == 3 % if new data are available
        
        % new data are saved
        serialData(end+1,:) = serialDataRead;
        
        % getting the value of the two potentiometers
        pot1 = serialData(end,2); pot2 = serialData(end,3);
        
        % find the label
        label = 0;
        if pot1 < lowThreshold
            if pot2 < lowThreshold
                label = 1;
            elseif pot2 > highThreshold
                label = 2;
            end
        elseif pot1 > highThreshold
            if pot2 < lowThreshold
                label = 3;
            elseif pot2 > highThreshold
                label = 4;
            end
        end
        
        % adding elements to time_array and to labels_array
        time_array(end+1) = toc(tStart);
        labels_array(end+1) = label;
        labelsAcquired(end+1) = label;
        
        % seeing how many elements in the last backSeconds
        time_array_backSeconds = time_array(find(time_array > max(0, time_array(end)-backSeconds)));
        numberOfElements_backSeconds=length(time_array_backSeconds);
        
        % deleting last elements
        serialData = serialData(end-numberOfElements_backSeconds+1:end,:);
        labels_array = labels_array(end-numberOfElements_backSeconds+1:end);
        time_array = time_array_backSeconds;
        
        if displayPlot == true
            for signal = 2:3 % since signals are written in position 2 and 3
                nexttile(signal-1);
                cla(q); hold on; grid on;
                signal_array = serialData(:,signal);
                plot(time_array_backSeconds, signal_array,'.-');
                plot([time_array_backSeconds(1) time_array_backSeconds(end)+1], [lowThreshold lowThreshold])
                plot([time_array_backSeconds(1) time_array_backSeconds(end)+1], [highThreshold highThreshold])
                ylim([0 1000])
                xlim([time_array_backSeconds(1) time_array_backSeconds(end)+1])
            end
            
            % plotting the label as well
            nexttile(3)
            cla(q); hold on; grid on;
            plot(time_array_backSeconds, labels_array,'.-');
            ylim([-1 5])
            xlim([time_array_backSeconds(1) time_array_backSeconds(end)+1])
        end
%         toc(tStart)
        pause(0.001) % to make the visualization more fluid
    end
    
    
    if toc(tSend) > sendingTime
        % update the time
        tSend = tic;
        
        % find the most frequent label
        labelToSend = mode(labelsAcquired)
        
        % delete all the elements from the label
        labelsAcquired = labelsAcquired(end);
        
        % sending to the tcpip
        if sendTCPIP == true
            fopen(tcpipClient);
            fwrite(tcpipClient,num2str(labelToSend));
            fclose(tcpipClient);
        end
    end
end
