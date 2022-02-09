% labels = randi(2,[1 100])
labels = [0 0 0 1 1 1 1 1 0 2 2 2 2 2 2 2 2 2 2 0 0 0 0];

time_array = [0]

for i = 1 : length(labels)-1
    time_array(end+1) = time_array(end) + rand()*0.5;
end

figure; hold on; grid on;
plot(time_array,labels, '.-')

findLabel(labels, time_array, 0.5)