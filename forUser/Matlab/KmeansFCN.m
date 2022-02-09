function label = KmeansFCN(centroidCoordinates, features)
[numberOfSamples numberOfFeatures] = size(features);
[numberOfLabels  numberOfFeatures] = size(centroidCoordinates);
for i= 1 : numberOfSamples
    for j = 1:numberOfLabels
        distance(j) = norm(features(i,:) - centroidCoordinates(j,:));
    end
    label(i) = find(distance == min(distance)) - 1;
end
label = label';
end

