function [ trainIdx,testIdx ] = nFoldsDataSampleBlockEqual( lab,trainPerc )
%This function generates the n folds training and testing data index, in a
%spatial block-wise manner.
%   Input:
%       - lab           -- a n by 1 array of all labeled data, n: number of all labeled data
%       - trainPerc     -- the percentage of training data
%   Output:
%       - trainIdx      -- a logical n by 1 array indicating the locationg of training data
%       - testIdx       -- a logical n by 1 array indicating the locationg of testing data
%


% get the codes of classes
codeClas = unique(lab); 
codeClas(codeClas==0) = [];
% get the number of classes
nbClas = length(codeClas);
% get the number of all labeled data
nbData = size(lab,1);
% get the number of folds
nfolds = floor(1/trainPerc);
% initial the output: a logic index that indicats the training data
trainIdx = zeros(nbData,nfolds)==1;

% loop for n classes
for cv_class = 1:nbClas
    % get the label location of the 'cv_class' class
    clasIdx = find(lab == codeClas(cv_class));
    
    endpts = [1,quantile(1:length(clasIdx),[trainPerc:trainPerc:1])];
    
    % loop for n folds
    for cv_fold = 1:nfolds
        trainIdx(clasIdx(floor(endpts(cv_fold)):ceil(endpts(cv_fold+1))),cv_fold) = 1;        
    end
        
end
% get the index for the training data
testIdx = ~trainIdx;


end

