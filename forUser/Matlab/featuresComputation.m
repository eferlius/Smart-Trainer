function [features] = featuresComputation(signals,samplesWindow)
% Given one or more array in column, applies the movingAverageFilter
% vertically to each sample
[numberOfSamples numberOfSignals] = size(signals);
% numberOfSamples = length(signals);
% numberOfSignals = width(signals);
numberOfFeatures = 4;% <----------------------------------- to be specified
features = zeros(numberOfSamples,numberOfSignals*numberOfFeatures);

for i=1:1:numberOfSamples % for each sampling time
    for j = 1:1:numberOfSignals % for each signal
        % considering only the sliding window
        signalToBeAnalyzed = signals(max(i-samplesWindow,1):min(i,numberOfSamples),j);
        for k = 1:1:numberOfFeatures % for each feature
            switch mod(k,numberOfFeatures)
                case 1
                    value = max(signalToBeAnalyzed);
                case 2
                    value = min(signalToBeAnalyzed);
                case 3
                    value = rms(signalToBeAnalyzed);
                case 0 % due to hard coding for features analysis through plots, keep the std dev as last feature
                    value = std(signalToBeAnalyzed);
            end
            features(i,(j-1)*numberOfFeatures+k)=value;
        end
    end
end


