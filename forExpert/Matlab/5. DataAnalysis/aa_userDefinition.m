%% script called at the initialization of every other to set the parameters
% creates a new directory with the current date to store all the data

%% POST PROCESSING AND FEATURES COMPUTATION -------------------------------
% for the filter intensity of the signal
secFiltering = 0.02; % s

% for the sliding window for the features computation
secWindowAmplitude = 0.3; %s

% number of features for each signal
NfeaturesSignal = 4;
% number of total features
Nfeatures = NfeaturesSignal * 4;

%% OTHERS ------------------------------------------------------------------
% defined on the arduino script!!! the user should define it ALSO THERE!!!
frequency = 200; % here the frequency is used only to compute how many samples should be acquired

generalDirectory = 'G:\Drive condivisi\DesignMechatronicSystem\SmartTrainer\forExpert';
currDate = strrep(datestr(datetime), ':', '_');

% where will you locate the file?
dataDirectory=[generalDirectory, '\Data\', num2str(frequency),'Hz\'];
