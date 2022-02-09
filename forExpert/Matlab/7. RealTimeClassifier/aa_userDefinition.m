%% script called at the initialization of every other to set the parameters
% creates a new directory with the current date to store all the data

%% ACQUISITION OF THE MOVEMENTS -------------------------------------------
% in which port is arduino?
COM = "COM3";

% how long should the test be?
secDuration = 600; %s

% how many seconds of distance between a movement and the other?
secToMove = 4; % s

%% REAL TIME CLASSIFIER ---------------------------------------------------
% how often should the real time classifier send the label?
sendingTime = 2; %s

% do you want Matlab to display the data in real time?
% (reduces the acquisition frequency)
displayPlot = true;

% do you want to send to the tcpip the label?
% (true for real working, false for debug)
sendTCPIP = false;

%% POST PROCESSING AND FEATURES COMPUTATION -------------------------------
% for the filter intensity of the signal
secFiltering = 0.02; % s

% for the sliding window for the features computation
secWindowAmplitude = 0.3; %s

% number of features for each signal
NfeaturesSignal = 4;

% number of total features
Nfeatures = NfeaturesSignal * 4;

%% FIND LABEL PARAMETERS --------------------------------------------------
% the real time classificator uses
secondsBeforeLabel = 0.5*sendingTime; %s

% for label identification: if this label is active for at least threshold,
% than it's considered valid
secondsThresholdActivation = 0.25; %s

%% OTHERS ------------------------------------------------------------------
% defined on the arduino script!!! the user should define it ALSO THERE!!!
frequency = 200; % here the frequency is used only to compute how many samples should be acquired

generalDirectory = 'G:\Drive condivisi\DesignMechatronicSystem\SmartTrainer\forExpert';
currDate = strrep(datestr(datetime), ':', '_');

% where will you locate the file?
dataDirectory=[generalDirectory, '\Data\', num2str(frequency),'Hz\'];


% how many seconds do you want to visualize in the real time plot?
secondsBeforeFigure= 5; %s
secondsBeforeFigure = max(sendingTime + 1,secondsBeforeFigure); %s

% -------------------------------------------------------------------------
% subjects array
subjects = {'1. Subj1','2. Subj2','3. Subj3'};

% movements array
movements = {'1. hand close','2. hand open','3. pronation (int rot)','4. supination (ext rot)', '5. free movements', '6. in order'};

% instructions array
instructions = {"close", "open", "int", "ext", "random", "in order"};


