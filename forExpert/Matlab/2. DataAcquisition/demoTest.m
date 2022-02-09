close all; clear all; clc;

% simulate the performance of a test: every second is displayed and the
% instruction is given
movement = 6;
secDuration = 51;
elapsedTimeSeconds = 0;

secondToMove = 4;

sentence_array = {};
label_array = [];
while elapsedTimeSeconds<secDuration
    elapsedTimeSeconds = elapsedTimeSeconds + 1;
    [sentence, label] = counterInstruction(elapsedTimeSeconds, secondToMove, movement);
    sentence_array{end+1} = sentence; 
    label_array(end+1) = label;
    disp(sentence)
    pause(1)
end
