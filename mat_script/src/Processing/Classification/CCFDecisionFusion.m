function [ testClass, predClass, evaluationIdx ] = CCFDecisionFusion( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% read input variables
testVoteCell = varargin{1};
nb_data = length(testVoteCell);

testIdx = [];
predVoteCell = [];
evaluationIdx = [];
weight = ones(1,nb_data);

n = 2;
while n < nargin
    switch lower(varargin{n})
        case 'predvote'
            n = n + 1;
            predVoteCell = varargin{n};            
        case 'test'
            n = n + 1;
            testIdx = varargin{n};    
        case 'datamask'
            n = n + 1;
            mask = varargin{n}; 
        case 'weight'
            n = n + 1;
            weight = varargin{n}; 
    end
    n = n + 1;
end


%% voting on test samples

testVote = zeros(size(testVoteCell{1}));
for i = 1:length(testVoteCell)
    testVote = testVote + weight(i).*testVoteCell{i};
end
[voteNOtest,testClass] = max(testVote,[],3);


if ~ isempty(testIdx)
    [ M,oa,pa,ua,kappa ] = confusionMatrix( testIdx, testClass );
    evaluationIdx = {M oa pa ua kappa};
    
    labIdx = unique(testIdx);
    claIdx = unique(testClass);
    labIdx(labIdx==0) = [];
    claIdx(claIdx==0) = [];
        
    for i = 1:length(claIdx)
        testClass(testClass == claIdx(i)) = labIdx(claIdx(i));
    end
    
end


if ~isempty(predVoteCell)
    predVote = zeros(size(predVoteCell{1}));
    for i = 1:length(predVoteCell)
        predVote = predVote + weight(i).*predVoteCell{i};
    end
    [voteNOpred,predClass] = max(predVote,[],3);
        
    labIdx = unique(testIdx);
    claIdx = unique(predClass);
    labIdx(labIdx==0) = [];
    claIdx(claIdx==0) = [];
    
    for i = 1:length(claIdx)
        predClass(predClass == claIdx(i)) = labIdx(claIdx(i));
    end
end






end

