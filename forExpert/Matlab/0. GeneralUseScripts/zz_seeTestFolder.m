function seeTest

% find the test with that unique number in the specified
% filesDirectory. If laels are available as well, they're plotted

[fileName ,filesDirectory] = uigetfile('G:\Drive condivisi\DesignMechatronicSystem\SmartTrainer\forExpert')
load(fullfile(filesDirectory,fileName));
serialData = data;
[nSamples nElements] = size(serialData);
if nElements > 5 % it means that also the label columnd is present
    zz_plotEMGsignals("", serialData(:,1),serialData(:,2:5),serialData(:,end));
else
    zz_plotEMGsignals("", serialData(:,1),serialData(:,2:end));
end
end

