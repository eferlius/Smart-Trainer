close all; clear all; clc;

tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
set(tcpipClient,'Timeout',30);

for labelToSend=1:100
    fopen(tcpipClient);
    fwrite(tcpipClient,num2str(labelToSend));
    fclose(tcpipClient);
    pause(0.1)
end
