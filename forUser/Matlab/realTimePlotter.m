% Not for the acquistion, it's only to see the different signals on
% the EMG sensors that each movement is performing
% There is not a deterministic frequency of data acquisition: a while loop
% with data plotting inside is executed, data are flushed to always have
% the latest data and the time is computed on the Matlab execution, not on
% the Arduino's one

close all; clear all; clc;

%% user defined part
% frequency for data displaying is not necessary, data are displayed as
% soon as possible, only a little pause is put in the while loop to
% make the visualization as fluid as possible

aa_userDefinition

%%
% definition of the serial device
clear device; device = serialport(COM,115200)
zz_pausing(2,"to give time to the serial port to establish the connection properly");

% in this matrix will be stored all the values read from the serial port
serialData = [0 0 0 0 0];

% array with times from matlab tic toc
time_array = [0];

% figure initialization
figure('Units','normalized','Position',[0 0 1 1]); q=tiledlayout(4,1,'tilespacing','none');
title(q,"EMG signals collected")

%% while loop
tStart=tic;
while toc(tStart)<secDuration
    
    % continously reading the data
    serialDataRead = str2num(readline(device));
    
    % flushing the device, the old data are eliminated, so always the lates
    % data is available. Remember we use this only to display data, not to
    % acquire properly
    flush(device,"input");
    
    if length(serialDataRead) == 5 % if new data are available
        serialData(end+1,:) = serialDataRead; % new data are saved
        time_array(end+1) = toc(tStart);
        
        % time array of the last secondsBeforeFigure
        time_array_secondsBeforeFigure = time_array(find(time_array > max(0, time_array(end)-secondsBeforeFigure)));
        numberOfElements_secondsBeforeFigure=length(time_array_secondsBeforeFigure);
        
        % plot updates
        for signal = 2:5 % since EMG signals are written in position 2 to 5, pos 1 is for the time
            nexttile(signal-1);
            signal_array = serialData(end-numberOfElements_secondsBeforeFigure+1:end,signal);
            plot(time_array_secondsBeforeFigure, signal_array,'.-');
            %ylim([0 1000])
            xlim([time_array_secondsBeforeFigure(1) time_array_secondsBeforeFigure(end)+1])
        end
        toc(tStart)
        pause(0.001) % to make the visualization more fluid
    end
    
end
%% data on the execution
tEnd = toc(tStart);
totalData = length(time_array)
avgFrequency = totalData/tEnd
