function [ fuzzyProbability ] = majorVote( segMap,claMap )
%This function conducts major voting for each segments of segmentation map
%using the classification result in classification map. The highest voted
%class is assigned to output classification map. Also, the probability of
%each classes are stored in the fuzzyProbability
%
%   Input:
%       - segMap                - segmentation map
%       - claMap                - classification map
%
%   Output:
%       - out_claMap            - output classification map. each segment
%                                 is assigned to the class to which most
%                                 pixels in the segment are assigned
%       - fuzzyProbability      - the probabilities of each class for the
%                                 pixels. [row, column, classes]
%

[rs,cs] = size(segMap);
[rc,cc] = size(claMap);

if rs~=rc || cs~=cc
    disp('size of segmentation map and classification map do not suit');
    return;
end
segMap = segMap - min(segMap(:)) + 1;

segInd = unique(segMap);
segInd(segInd==0) = [];
segnb = length(segInd);

classInd = unique(claMap);
classNb = length(classInd);
fuzzyProbability = zeros(rs,cs,classNb);

indicator = ceil(segnb/100);


for i = 1:segnb
    Ind = (segMap == segInd(i));
    claPix = Ind.*claMap;
    claPix(claPix==0) = [];
    
    for j = 1:classNb
        temp_p = sum(claPix(:)==classInd(j))/sum(Ind(:));
        fuzzyProbability(:,:,j) = fuzzyProbability(:,:,j)+temp_p*Ind;
    end
    if ~mod(i,indicator)
        disp([num2str(i/indicator),'% is done...']);
    end
end


end

