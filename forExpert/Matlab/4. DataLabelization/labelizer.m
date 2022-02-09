close all; clear all; clc;

aa_userDefinition;

% load data
[fileName ,filesDirectory] = uigetfile(dataDirectory)
load(fullfile(filesDirectory,fileName));
serialData = data;

%% menu
nameOfLabels = {'0 [rest]', '1 [hand close]','2 [hand open]',...
    '3 [pronation (int rot)]', '4 [supination (ext rot)]'};

%% manual labelling with the function
[motion,start_index] = manualLabelFCN(serialData(:,2:end), nameOfLabels)

%% adding the labels as last column of serialData for each sample
start_index = floor(start_index); 
% adding the last element
start_index(end+1) = length(serialData);
% declaring a new column to store the label
labels = zeros(length(serialData),1);
for i = 1:length(start_index)-1
    labels(start_index(i):start_index(i+1),end)=motion(i);
end
serialData = [serialData(:,1:5),labels];

%% displaying the labelized data
zz_plotEMGsignals(fileName,serialData(:,1),serialData(:,2:5),serialData(:,6));

%% saving the data
choice=menu('Save Data?','yes','no');
if choice==1
    filesDirectory='G:\Drive condivisi\DesignMechatronicSystem\data\tests\taggedTests\';
    save([filesDirectory fileName],'serialData');
    disp(['file saved in ' filesDirectory fileName]);
elseif choice==2
    disp('file not saved');
end
close all;



