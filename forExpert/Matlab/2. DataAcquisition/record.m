function [serialData, label_array, realDuration] = record(COM, frequency, secDuration, movement, secondToMove, dispDebugFigures)
%RECORD for the given time in seconds, records the signal read from the
%serial port and stores them in a a table
% each row is the samople
% the columns are: time [s], V1, V2, V3, V4

% definition of the serial device
clear device; device = serialport(COM,115200)
zz_pausing(3,"to give time to the serial port to establish the connection properly");

% to know how many samples shoud be read
timeStep = 1/frequency;
numberOfSamples=secDuration*frequency;

% in this matrix will be stored all the values read from the serial port
serialData = [0 0 0 0 0];

counter=0; % to count how many data are read from the serial port

sentence_array = {}; % to save the given instructions
label_array = [];

% [DEBUG]
skip = 0; % [DEBUG] to count how many times the loop is executed without data availables
timeArray_Matlab = [0]; % [DEBUG] to know in which moment, according to the matlab time counter, a new data is added

%% loop
% otherwise all the data retrieved from arduino since serialport definition would be read
flush(device,"input")

tStart = tic; % to compute the total duration

while counter<numberOfSamples
    
    % continously reading the data
    serialDataRead = str2num(readline(device));
    
    if length(serialDataRead) == 5 % if new data are available
        serialData(end+1,:) = serialDataRead; % new data are saved
        counter = counter + 1; % increment the counter
        timeArray_Matlab(end+1) = toc(tStart); % [DEBUG] to know when data are saved
    else
        skip = skip + 1; % increment the counter of skips
    end
    
    % to display the elapsed time in seconds
    if mod(counter, frequency)==0 % if a second (or more) sharps are elapsed
        elapsedTimeSeconds = counter/frequency;
        [sentence, label] = counterInstruction(elapsedTimeSeconds, secondToMove, movement);
        sentence_array{end+1} = sentence;
        label_array(end+1) = label;
        disp(sentence)
    end
    
end
% information regarding the execution
realDuration = toc(tStart)
counter
skip

clear device;

% extracting the data from the matrix
serialData = serialData(2:end,:);

%get the initial time from the second line (the first one is all 0)
initialTime = serialData(1,1);
% divide two times per 1000 since we pass from microseconds to seconds
serialData(1:end,1)=(serialData(1:end,1)-initialTime)/1000/1000;

if dispDebugFigures == true
    timeArray_Arduino = serialData(1:end,1);
    debugFigures
end

end

