function [ label, cluMap,labelColor ] = clusteringMapShow_mul2one( label, cluMap,colormaptype )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% input check
if length(label(:)) ~= length(cluMap(:))
    disp('------------------------- size not fit -------------------------')
    return;
end
if min(cluMap(:)) == 0
    cluMap = cluMap + 1;
end

% masked by ground truth
labeltemp = label(label~=0);
cluMaptemp = cluMap(label~=0);

labelIdx = unique(labeltemp);
cluMapIdx = unique(cluMaptemp);

nbClusterLabel = length(labelIdx);
nbClusterCluMap = length(cluMapIdx);

% initial the confusion matrix and calculate it
M_temp = zeros(nbClusterLabel,nbClusterCluMap);



for i = 1:length(labeltemp)
    M_temp(labeltemp(i)==labelIdx,cluMaptemp(i)==cluMapIdx) = M_temp(labeltemp(i)==labelIdx,cluMaptemp(i)==cluMapIdx) + 1;
end



while sum(M_temp(:))~=0
    [~,idx] = max(M_temp(:));
    [r, c] = ind2sub(size(M_temp),idx);
    cluMap(cluMap==cluMapIdx(c)) = -r;    
    M_temp(:,c) = 0;
end

temp = cluMap(cluMap > 0);
temp = unique(temp);
counts = zeros(size(temp));

for i = 1:length(temp)
    counts(i) = sum(cluMap(:)==temp(i));
end
[~,idx] = sort(counts);
for i = 1:length(temp)
    cluMap(cluMap == temp(idx(i))) = -max(labeltemp)-i;
end

cluMap = -cluMap;


labelColor=label2color(label, colormaptype);
figure,imshow(labelColor);
cluColor=label2color(cluMap.*(label~=0), colormaptype);
figure,imshow(cluColor);
cluColor=label2color(cluMap, colormaptype);
figure,imshow(cluColor);

end

