function [label] = postProc_findLabel(labels, time_array, threshold, lastLabel, minSignal3)
% returns the label(s) that exceeds the time threshold
label = 0; % default value
durations = [0];
possibleLabels = [0];
if lastLabel ~= 0
    label = 0;
else
    activatePostProcessing24 = false;
    if length(labels) > 1 % in case in the last sample no labels are collected
        
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
                if (possibleLabels(end) == 2 || possibleLabels(end) == 4)
                    activatePostProcessing24 = true;
                end
                % for debugging
                % duration
                % label = labels(switchIndexes(i)+1)
                % time = [time_array(switchIndexes(i+1)) time_array(switchIndexes(i)+1)]
            end
        end
        
        %% manual post processing
        label = possibleLabels(find(durations==max(durations)));
        if (activatePostProcessing24 == true && (label == 2 || label == 4))
            if sum(minSignal3 < 299) > 1
                label = 4;
            else
                label = 2;
            end
        end
    end
end
