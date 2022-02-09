function plotEMGsignals(titolo,timeArray,data,labels)

% creates a new figure and plots in a 4x1 the 4 EMG signals, 
% if labels array is available, shows them as well

numberOfGraphs=width(data);
maximo=zeros(1,numberOfGraphs);
minimo=zeros(1,numberOfGraphs);

% detecting parameters for each signal
for i=1:numberOfGraphs
    maximo(i)=max(data(:,i));
    minimo(i)=min(data(:,i));
end

if nargin >= 4
    % find switch indexes for corresponding label
    switchIndexes = [1 find((diff(labels')~=0) == 1) length(labels)];
    colorLabels={'w','r','g','y','b'};
end

figure('Units','normalized','Position',[0 0 1 1]); q=tiledlayout(width(data),1,'tilespacing','none');
% if titolo == "";
%     title(q,"EMG signals collected")
% else
%     title(q,titolo,'Interpreter', 'none');
% end

for signal = 1:width(data)

    nexttile(signal); hold on; grid on;
    % plot the signal
    plot(timeArray, data(:,signal));
    % plot the areas corresponding to the label
    if nargin >= 4
        for i = 1 : length(switchIndexes)-1
            xmin = switchIndexes(i)*timeArray(end)/length(timeArray); xmax = switchIndexes(i+1)*timeArray(end)/length(timeArray);
            ymin = minimo(signal); ymax = maximo(signal);
            patch([xmin xmax xmax xmin], [ymin ymin ymax ymax], colorLabels{labels(switchIndexes(i)+1)+1});
            alpha 0.2
        end
    end
end
end

