function [ interval,dendrogram ] = H0group( minTree,maxValue,minValue,nb_bin,filtrationValue )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



% filtrationValue = linspace(minValue,maxValue,nb_bin);

% filtration process
[r,~] = size(minTree.Edges);
dendrogram = zeros(r+1,nb_bin);
tic
for i = 1:nb_bin
    dendrogram(:,i) = find_union( minTree.Edges.EndNodes,minTree.Edges.Weight < filtrationValue(i));
end
toc

temp = dendrogram==repmat(dendrogram(:,1),1,nb_bin);

interval = [dendrogram(:,1),sum(temp,2)];


end

