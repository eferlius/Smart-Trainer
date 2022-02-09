% do you want Matlab to display the data in real time?
% (reduces the acquisition frequency)
displayPlot = true;

% do you want to send to the tcpip the label?
% (true for real working, false for debug)
sendTCPIP = false;

% how long will be the acquisition
secDuration = 60;

% how many seconds should be displayed in the plot
backSeconds = 5;

% thresholds to detect the class according to the values of the
% potentiometers
lowThreshold = 200;
highThreshold = 800;

% how often should the label be sent?
sendingTime = 2; %s

% in which port is arduino?
COM = "COM5";