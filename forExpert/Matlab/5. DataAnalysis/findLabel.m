function [label] = findLabel(labels, time_array, threshold)

% returns the label(s) that exceeds the time threshold
label = 0; % default value

durations = [0];
possibleLabels = [0];

% if only one outlier, then correct it
for i=1:length(labels)-2
    if labels(i) == labels(i+2)
        labels(i+1) = labels(i);
    end
end
switchIndexes = [1 find((diff(labels)~=0) == 1) length(labels)];

for i = 1 : length(switchIndexes)-1
    duration = time_array(switchIndexes(i+1))-time_array(switchIndexes(i)+1);
    if  duration >= threshold && labels(switchIndexes(i)+1) ~= 0
        durations(end+1) = duration;
        possibleLabels(end+1) = labels(switchIndexes(i)+1);
        % for debugging
        % duration
        % label = labels(switchIndexes(i)+1)
        % time = [time_array(switchIndexes(i+1)) time_array(switchIndexes(i)+1)]
    end
end
% among all the possible label, find the one with max duration
label = possibleLabels(find(durations==max(durations)));
end
