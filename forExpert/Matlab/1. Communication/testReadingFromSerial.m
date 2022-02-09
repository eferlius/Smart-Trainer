close all; clear all; clc;

aa_userDefinition

clear arduino; arduino = serialport(COM,115200)

for nOfReading = 1:100
    serialDataRead = str2num(readline(arduino))
    flush(arduino,"input"); % to clean the data from the serial port
    pause(0.1)
end

clear device

