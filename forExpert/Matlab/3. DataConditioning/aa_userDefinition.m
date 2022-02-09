%% script called at the initialization of every other to set the parameters

generalDirectory = 'G:\Drive condivisi\DesignMechatronicSystem\SmartTrainer\forExpert';

% defined on the arduino script!!! the user should define it ALSO THERE!!!
frequency = 200; % here the frequency is used only to compute how many samples should be acquired

% where will you locate the file?
dataDirectory=[generalDirectory, '\Data\', num2str(frequency),'Hz\'];

% where will you locate the file?
filesDirectory=[generalDirectory, '\Data\', num2str(frequency),'Hz\1. rawData'];

% in which port is arduino?
COM = "COM3";

% how long should the test be?
secDuration = 12; %s

% how many seconds of distance between a movement and the other?
secToMove = 3;

% to avoid that in the end of the test it's requested to perform a movement
if mod(secDuration,secToMove)==0
    secDuration = secDuration - 1;
end

% how many seconds do you want to visualize in the real time plot?
backSeconds = 10; %s

% ----------------------------------------------------------------------- %
% subjects array
subjects = {'1. Subj1','2. Subj2','3. Subj3'};

% movements array
movements = {'1. hand close','2. hand open','3. pronation (int rot)','4. supination (ext rot)', '5. free movements', '6. in order'};



