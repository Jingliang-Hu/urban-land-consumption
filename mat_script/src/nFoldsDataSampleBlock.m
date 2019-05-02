function [ trainIdx,testIdx ] = nFoldsDataSampleBlock( lab,nfolds,testPerc )
%This function generates the n folds training and testing data index, in a
%spatial block-wise manner.
%   Input:
%       - lab           -- a n by 1 array of all labeled data, n: number of all labeled data
%       - nfolds        -- the number of folds
%       - testPerc      -- the percentage of testing data
%   Output:
%       - trainIdx      -- a logical n by 1 array indicating the locationg of training data
%       - testIdx       -- a logical n by 1 array indicating the locationg of testing data
%


% get the codes of classes
idClas = unique(lab); 
idClas(idClas==0) = [];
% get the number of classes
nbClas = length(idClas);
% get the number of all labeled data
nbData = size(lab,1);
% initial the output: a logic index that indicats the testing data
testIdx = zeros(nbData,nfolds)==1;


% loop for n folds
for i = 1:nfolds    
    for j = 1:nbClas
        clasIdx = find(lab == idClas(j));
        nbDataCla = length(clasIdx);
        nbVal = ceil(nbDataCla*testPerc);
        startPt = [round(1:(nbDataCla-nbVal)/(nfolds-1):nbDataCla-nbVal),nbDataCla-nbVal];
        if length(startPt)~=nfolds
            startPt = [startPt,repmat(startPt(end),1,nfolds-length(startPt))];
        end
        testIdx(clasIdx(startPt(i):startPt(i)+nbVal),i) = 1;        
    end
        
end
% get the index for the training data
trainIdx = ~testIdx;


end

