% Author:       Jingliang Hu, PhD candidate 
% Email:        jingliang.hu@dlr.de
% Affiliation:  German Aerospace Center (DLR)
%               Technische Universität München (TUM)
function [ W,cluCens,filMean ] = visualMAPPER( clusterIdx,clusterCen,fil )
%simple visualization of MAPPER derived topological structure of data
%W is the graph of clusters
%   -- Input:
%        - clusterIdx          -- cluster index of MAPPER result
%        - clusterCen          -- cluster centers of MAPPER result
%        - fil                 -- filtered value
%
%   -- Output:
%        - W                   -- cluster level MAPPER graph
%        - cluCens             -- cluster centers of MAPPER in matrix
%        - filMean             -- mean filter value for clusters
%

% initial the graph
nbCluster = 0;
for i = 1:size(clusterCen,2)
    nbCluster = nbCluster + length(clusterCen{1,i});
end
W = zeros(nbCluster);

% construct cluster level graph
cluCens = cat(1,clusterCen{2,:});
for i = 1:size(clusterIdx,2)-1
    pairs = clusterIdx(:,i:i+1);
    tmp = unique(pairs,'rows');
    tmpIdx = (tmp(:,1)>0&tmp(:,2)>0);
    tmp = tmp(tmpIdx,:);
    for j = 1:size(tmp,1)
        W(tmp(j,1),tmp(j,2)) = sum(pairs(:,1)==tmp(j,1)&pairs(:,2)==tmp(j,2));
    end
end
W = (W+W')/2;

% get mean fil value for clusters
filMean = size(nbCluster,1);
for i = 1:nbCluster
    tmpfil = fil(sum(clusterIdx==i,2)==1);
    filMean(i) = mean(tmpfil);
end

% figure,plot(graph(W),'NodeCData',mat2gray(filMean));

end

