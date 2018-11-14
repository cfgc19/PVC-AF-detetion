function [sensitivity,  specificity] = classification(our_output,true_output)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
TP=0;
TN=0;
FN=0;
FP=0;

for i=1:length(our_output)
    if(our_output(i)==1 && true_output(i)==1)
        TP = TP+1;
    elseif(our_output(i)==1 && true_output(i)==0)
        FP = FP +1;
    elseif(our_output(i)==0 && true_output(i)==1)
        FN = FN +1;
    elseif(our_output(i)==0 && true_output(i)==0)
        TN = TN +1;
    end
end

sensitivity = TP/(TP+FN);
specificity = TN/(TN+FP);
end

