%% script called at the initialization of every other to set the parameters

generalDirectory = 'G:\Drive condivisi\DesignMechatronicSystem\SmartTrainer\forExpert';

% defined on the arduino script!!! the user should define it ALSO THERE!!!
frequency = 200; % here the frequency is used only to compute how many samples should be acquired

% where will you locate the file?
dataDirectory=[generalDirectory, '\Data\', num2str(frequency),'Hz\'];

% where will you locate the file?
filesDirectory=[generalDirectory, '\Data\', num2str(frequency),'Hz\1. rawData'];
