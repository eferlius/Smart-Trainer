function seeTest(testNum, filesDirectory)

% find the test with that unique number in the specified
% filesDirectory. If labels are available as well, they're plotted

stringToMatch = sprintf('*%s*.mat',[num2str(testNum,'%03.f'),'_p',]);
filesMatching = dir(fullfile(filesDirectory,stringToMatch));
load(strcat(filesDirectory, filesMatching.name));

[nSamples nElements] = size(serialData);
if nElements > 5 % it means that also the label columnd is present
    zz_plotEMGsignals(filesMatching.name, serialData(:,1),serialData(:,2:5),serialData(:,end));
else
    zz_plotEMGsignals(filesMatching.name, serialData(:,1),serialData(:,2:end));
end
end

