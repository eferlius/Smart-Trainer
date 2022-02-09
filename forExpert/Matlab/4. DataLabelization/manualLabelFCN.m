function [motion,start_index] = manualLabelFCN(data, nameOfLabels)

%% Acquires in input the signals of the different electrodes

% initial parameters
numberOfGraphs=width(data);
maximo=zeros(1,numberOfGraphs);
minimo=zeros(1,numberOfGraphs);

% detecting parameters for each signal, useful for the plot
for i=1:numberOfGraphs
    maximo(i)=max(data(:,i));
    minimo(i)=min(data(:,i));
end

%% plot
figure1=figure;
q = tiledlayout(numberOfGraphs,1,'tilespacing','tight');
for i=1:1:numberOfGraphs
    nexttile
    hold on
    grid on
    plot(data(:,i))
%     if i~=numberOfGraphs
%         set(gca,'Xticklabel',[]) %to just get rid of the numbers but leave the ticks.
%     end
end

% limit of x-axis
max_axis_x_plot=length(data);

% inizializzo i vettori
x_line=1;
motion=[];
start_index=[];

while (x_line < max_axis_x_plot)
    
    figure1;
    for i=1:1:numberOfGraphs
        nexttile(i)
        % adding the vertical lines
        plot([x_line x_line],[minimo(i) maximo(i)], 'r--')
    end
    %nameOfLabels=[nameOfLabels{:} 
    tag=menu("Which label do you want to put to the phase which is starting now?",...
        nameOfLabels{:}, 'DELETE LAST ELEMENT');
    
    %% the user wants to delete the last element
    if tag==length(nameOfLabels)+1
        %% deleting the plot overwriting them with a white line
        figure1;
        for i=1:1:numberOfGraphs
            nexttile(i)
            % adding the vertical lines
            plot([x_line x_line],[minimo(i) maximo(i)], 'w--')
            plot([start_index(end) start_index(end)], [minimo(i) maximo(i)], 'w--')
            text(start_index(end),minimo(i),int2str(motion(end)),'Color','white');
        end
        
        %% deleting the last element from the arrays
        disp(datetime(now,'ConvertFrom','datenum'))
        motion = motion(1:end-1)
        start_index = start_index(1:end-1)
        
        
        %% the user adds the label
    else
        %% adding the new element to the arrays
        disp(datetime(now,'ConvertFrom','datenum'))
        motion = [motion; tag-1]
        start_index = [start_index; x_line]
        
        %% adding the text to the plot
        figure1;
        for i=1:1:numberOfGraphs
            nexttile(i)
            % adding the text
            text(start_index(end),minimo(i),int2str(motion(end)),'Color','red');
        end
    end
    % acquiring the new transition
    [x_line,y_line] = ginput(1);
end

tmp = menu('Labelling finished. Presso ENTER to continue', 'ENTER');

close(figure1)

end

