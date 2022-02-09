function pausing(seconds, message)
% performs a countdown of the given duration in seconds and gives a message
% at the starting
if nargin > 1
    disp(message)
end
while seconds > 0
    disp(['pausing ', num2str(seconds), ' seconds...'])
    seconds = seconds - 1;
    pause(1);
end
disp('Ready to go...')
end

