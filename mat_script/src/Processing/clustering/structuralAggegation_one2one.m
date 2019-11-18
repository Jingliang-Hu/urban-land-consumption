function [ cluMapRes ] = structuralAggegation_one2one( trainMap, treeStructureMap )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

nb_level = size(treeStructureMap,3);
cluMap = zeros(size(treeStructureMap));
cluMapRes = zeros(size(treeStructureMap));

for i = 1:nb_level
    [ ~, cluMap(:,:,i) ] = clusteringMapShow_one2one( trainMap, treeStructureMap(:,:,i) );
end
cluMapRes(:,:,nb_level) = cluMap(:,:,nb_level);
close all;

for i = nb_level - 1:-1:1
    figure,imshow(cluMapRes(:,:,i+1),[]);colormap(gca,jet);
    
    if max(unique(cluMap(:,:,i+1))) <= max(unique(trainMap))
        break;
    end
    cluMapRes(:,:,i) = cluMapRes(:,:,i+1);
    for j = max(unique(trainMap))+1 : max(unique(cluMap(:,:,i+1)))
        masktemp = cluMap(:,:,i+1) == j;
        clusterIdx = unique(masktemp.*treeStructureMap(:,:,i));
        if length(clusterIdx)==2 % 0 and cluster order
            mask = treeStructureMap(:,:,i) == clusterIdx(2);
        else
            disp('something wrong');
        end
        clusterIdx = mask.*cluMap(:,:,i);
        clusterIdx(clusterIdx==0) = [];
        if ~isempty(clusterIdx)
            cluMapRes(:,:,i) = cluMapRes(:,:,i).*(~masktemp) + masktemp * mode(clusterIdx);
        end
        
        
    end
% %     
% %     [ ~, cluMap(:,:,i) ] = clusteringMapShow( cluMap(:,:,i+1), treeStructureMap(:,:,i) );
% %     maskTemp = (cluMap(:,:,i+1)<=max(unique(trainMap)));
% %     cluMap(:,:,i) = cluMap(:,:,i+1).*maskTemp + cluMap(:,:,i).*(~maskTemp);
end




end

