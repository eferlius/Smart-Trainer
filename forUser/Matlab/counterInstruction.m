function [sentence, label] = counterInstruction(elapsedTimeSeconds, secondToMove, movement)

%% Gives instructions to the patient that is performing the test.
% Every second is displayed and, if elapsedTimeSeconds is multilple of
% secondToMove, then also the movement to be performed is displayed
instructions = {"close", "open", "int", "ext"};

output = num2str(elapsedTimeSeconds,'%03.f');


label = 0;

if elapsedTimeSeconds ~= 0
    if mod(elapsedTimeSeconds, secondToMove) == 0
        if movement == 5 % random movement
            label = randi(4);
        elseif movement == 6 % order movement
            label = mod(elapsedTimeSeconds/secondToMove, 4);
        else
            label = movement;
        end
        output = strcat(output, ' ->  ' , instructions{label});
    end
end



% finally printing the sentence
sentence = output;
label;

end

