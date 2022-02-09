%% debug figures to check the execution of the code

% diagonal check: comparison of theorical time array with arduino and
% matlab ones
timeArray_theorical = 0:timeStep:secDuration-timeStep;
figure; hold on; grid on;
plot(timeArray_theorical, timeArray_Arduino, '.-') % should obtain a perfect diagonal
plot(timeArray_theorical, timeArray_Matlab(1:end-1),'.-') % should obtain a perfect diagonal
legend('time declared in Arduino', 'tic-toc time in Matlab');
xlabel('theorical time [s]'); ylabel('real time [s]'); title('check of time accuracy');

% time difference between each sample collected in arduino and in matlab
figure; hold on; grid on;
q = tiledlayout(1,2); title(q, 'time between each pair of samples recorded')
nexttile; hold on; grid on; plot([0 length(timeArray_Arduino)],[timeStep timeStep], 'linewidth', 4);
plot(diff(timeArray_Arduino),'.');
ylim([0 max([diff(timeArray_Matlab(2:end)), diff(timeArray_Arduino)'])])
xlabel('sample number'); ylabel('time difference [s]'); title('Arduino');

nexttile; hold on; grid on; plot([0 length(timeArray_Arduino)],[timeStep timeStep], 'linewidth', 4);
plot(diff(timeArray_Matlab(2:end)),'.');
ylim([0 max([diff(timeArray_Matlab(2:end)), diff(timeArray_Arduino)'])])
xlabel('sample number'); ylabel('time difference [s]'); title('Matlab');