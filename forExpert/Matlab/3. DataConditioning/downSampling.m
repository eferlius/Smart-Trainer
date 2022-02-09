function serialDataDownSampled = downSampling(serialData,targetFrequency)
% DOWNSAMPLING resamples at the given frequency the data
% Serial data should contain in the first column the time array in seconds

targetTime = 1/targetFrequency;
moment = 0;
indexes = [1 1];

while moment <= serialData(end,1)
    % find all indexes in which the time is bigger than moment
    tmp = serialData(:,1);
    indexes = find(tmp >= moment);
    
    % take first row of that index
    if moment == 0
        serialDataDownSampled = serialData(indexes(1),:);
    else
        serialDataDownSampled(end+1,:) = serialData(indexes(1),:);
    end
    
    % increase the time
    moment = moment + targetTime;
end


end

