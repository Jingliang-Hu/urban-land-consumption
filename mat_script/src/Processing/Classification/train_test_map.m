function [ trainMap,testMap ] = train_test_map( label,nb_train )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

trainMap = zeros(size(label));
testMap = zeros(size(label));


label_idx = unique(label);
label_idx(label_idx==0) = [];

for i = 1:length(label_idx)
    idl = find(label == label_idx(i));
    trainMap(idl(1:nb_train)) = label_idx(i);
    
end

testMap = label - trainMap;

end

