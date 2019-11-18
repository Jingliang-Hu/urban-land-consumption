function [ trainMap,testMap,label ] = produceTrainTestMap( varargin )
%produce training map and testing map for classification tasks
%   Input:
%       - label             -- ground truth same size with the data
%       - nbOfTrain         -- number of training samples
%       - sampleMethod      -- default 0: random sampling; 1: first k samples
%
%   Output:
%       - trainMap          -- map includes training samples
%       - testMap           -- map includes testing samples
%       - label             -- ground truth includes classes in training
%

label = varargin{1};
nbOfTrain = varargin{2};
sampleMethod = 0;
if nargin == 3
    sampleMethod = varargin{3};
end



idOfClass = unique(label(label>0));
nbOfClass = length(idOfClass);

trainMap = zeros(size(label));

for i = 1:nbOfClass
    idx = find(label(:) == idOfClass(i));
    if ceil(length(idx)*0.8) > nbOfTrain
        if sampleMethod
            % first k samples
            trainMap(idx(1:nbOfTrain)) = idOfClass(i);  
        else
            % random sampling
            idx = randsample(idx,nbOfTrain);
            trainMap(idx) = idOfClass(i);        
        end
    else
        label(label==idOfClass(i)) = 0;
    end
end

testMap = label - trainMap;
testMap(testMap<0) = 0;
end

