function [labelsSent, timeSent] = findLabelDemoNoLoop(labels, time_array, secondsThresholdActivation, sendingTime, secondsBeforeLabel)

% to find the label when testing on the whole table and not in a loop
% simulates the loop and applies for each sending time the findLabel
% function
timeSent = 0;
labelsSent = 0;

while timeSent(end) < time_array(end)
    timeSent(end+1) = timeSent(end)+sendingTime;
    
    lowerTimeLimit = max(0, timeSent(end) - sendingTime - secondsBeforeLabel);
    upperTimeLimit = timeSent(end);
    logicalIndexes = (time_array >= lowerTimeLimit ) & (time_array <= upperTimeLimit );
    
    time_array_tmp = time_array(find(logicalIndexes == 1));
    labels_tmp = labels(find(logicalIndexes == 1));
    
    labelsSent(end+1) = findLabel(labels_tmp', time_array_tmp, secondsThresholdActivation, labelsSent(end));
    
end

% post processing

end
