function [ M,oa,pa,ua,kappa ] = clusteringConfusionMatrix_one2one( label, claMap )
%This function calculates confusion matrix for clustering results only
%allow one cluster corresponding to one class in ground truth
%   Detailed explanation goes here



% make sure the length of reference and result are the same
if(length(label) ~= length(claMap))
    M = 0;
    oa = 0;
    pa = 0;
    ua = 0;
    kappa = 0;
    disp( ' ----------------------- size of label does not match size of claMap -----------------------' );
    return;
end

claMap = claMap(label~=0);
label = label(label~=0);


% save the index of different clusters
label_clusters = unique(label);
cla_clusters = unique(claMap);

% initial the confusion matrix and calculate it
if length(cla_clusters) < length(label_clusters)
    M_temp = zeros(length(label_clusters),length(label_clusters));
else
    M_temp = zeros(length(label_clusters),length(cla_clusters));
end
l = length(label);


for i = 1:l
    M_temp(label_clusters==label(i),cla_clusters==claMap(i)) = M_temp(label_clusters==label(i),cla_clusters==claMap(i)) + 1;
end

% -------------------------------------------------------------------------
%       Match the label(index) of reference and clustering result
% Description: sort from the maximum matched pair in confusion matrix

% initial final confusion matrix
M = zeros(size(M_temp));

% index confusion matrix used to update the sorting
M_ind = M_temp;

% flag to show certain column is processed or not
processed = zeros(length(label_clusters),length(cla_clusters));



while sum(M_ind(:))~=0
    [~,idx] = max(M_ind(:));
    [r, c] = ind2sub(size(M_ind),idx);
    M(:,r) = M_temp(:,c);
    M_ind(:,c) = 0;
    M_ind(r,:) = 0;
    processed(r,c) = 1;
end

if length(cla_clusters) <= length(label_clusters)
    % overall accuracy
    oa = sum(diag(M))./sum(M(:));

    % producer accuracy(accuracy for each class)
    pa = diag(M)./sum(M,2);

    % user accuracy(in each classified class, the percentage of correct classified)
    ua = diag(M)./sum(M(:,1:length(label_clusters)),1)';

    % kappa coefficient
    po = oa;
    pe = sum(sum(M(:,1:length(label_clusters)),1).*sum(M,2)')/l^2;
    kappa = (po-pe)/(1-pe);

else
    temp = M_temp(:,~sum(processed,1));
    M(:,~sum(processed,2)') = temp(:,1:sum(~sum(processed,2)'));
    M(:,length(label_clusters)+1:end) = temp(:,sum(~sum(processed,2)')+1:end);
    % overall accuracy
    oa = sum(diag(M))./sum(M(:));

    % producer accuracy(accuracy for each class)
    pa = diag(M)./sum(M,2);

    % user accuracy(in each classified class, the percentage of correct classified)
    ua = diag(M)./sum(M(:,1:length(label_clusters)),1)';

    % kappa coefficient
    po = oa;
    pe = sum(sum(M(:,1:length(label_clusters)),1).*sum(M,2)')/l^2;
    kappa = (po-pe)/(1-pe);

end

% -------------------------------------------------------------------------









end

