function [ feature,label ] = trainingSet( sample,label )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[rw,cl,dn] = size(sample);

label = label*ones(rw*cl,1);
feature = reshape(sample,rw*cl,dn,1);

end

