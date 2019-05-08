% last change was on 13.03.2018
% ----------------------------------
% change on 07.07.2018, add rng(1), before kmean, for reproduction
% ----------------------------------
% last change was on 05.04.2019:
% 1. decide the number of clusters
% 2. eig --> eigs

function [C,Center] = spectralClustering_MAPPER(W, Type)
%SPECTRALCLUSTERING Executes spectral clustering algorithm
%   Executes the spectral clustering algorithm defined by
%   Type on the adjacency matrix W and returns the k cluster
%   indicator vectors as columns in C.
%   If L and U are also called, the (normalized) Laplacian and
%   eigenvectors will also be returned.
%
%   'W' - Adjacency matrix, needs to be square
%   'k' - Number of clusters to look for
%   'Type' - Defines the type of spectral clustering algorithm
%            that should be used. Choices are:
%      1 - Unnormalized
%      2 - Normalized according to Shi and Malik (2000)
%      3 - Normalized according to Jordan and Weiss (2002)
%
%   References:
%   - Ulrike von Luxburg, "A Tutorial on Spectral Clustering", 
%     Statistics and Computing 17 (4), 2007
%
%   Original author:    Ingo Buerk
%   Year:               2011/2012
%
%   Modification:       Jingliang Hu
%   Year:               2017/2019



W = double(W);
W(W<1e-5)=0;
% calculate degree matrix

degs = sum(W, 2);
D    = sparse(1:size(W, 1), 1:size(W, 2), degs);

% compute unnormalized Laplacian
L = D - W;

% compute normalized Laplacian if needed
% switch Type
%     case 2
%         % avoid dividing by zero
%         degs(degs == 0) = eps;
%         % calculate inverse of D
%        D = spdiags(1./degs, 0, size(D, 1), size(D, 2));
%        
%        % calculate normalized Laplacian
%        L = D * L;
%    case 3
%        % avoid dividing by zero
%        degs(degs == 0) = eps;
%        % calculate D^(-1/2)
%        D = spdiags(1./(degs.^0.5), 0, size(D, 1), size(D, 2));
%        
%        % calculate normalized Laplacian
%        L = D * L * D;
% end

% compute the eigenvectors corresponding to the k smallest
% eigenvalues

% diff   = eps;
% [~,v,~]=eig(L);
% v = diag(v);
% figure,plot(1:length(v),v);

% disp(' ---------------------------------- Eigenvalue decomposition ...  ----------------------------------');
% eigenvalue decomposition

L = (L+L')/2;
if size(L,1)<=60
    [U, v] = eig(L,full(D));
else
    try
        [U, v] = eigs(L,full(D),55,'sa') ;
    catch e 
        [U, v] = eig(L,full(D));
        disp('Problem occurs, eig is used instead of eigs......')
    end
end

v = real(diag(v));
% get rid of eigenvector of eigenvalue 0
U(:,v<1e-7) = [];
v(v<1e-7) = [];
% resort eigenvalues
[sv,order]=sort(v);


% decision of number of clusters
if size(L,1)<150
    % get the gap, detect number of clusters
    ndx = sv(2:end)-sv(1:end-1);
    [~,loc] = max(ndx);
    k = loc(1)+1;
else
    % 
    k = ceil(size(L,1)/50);
end
if k > 50
    k = 50;
end

if length(order)>k
    U = U(:,order(1:k));
end
% while sum(isnan(U(:)))>0
%     [U, v] = eigs(L,k,eps);
% end
% disp(' ---------------------------------- Eigenvalue solved ----------------------------------');
% in case of the Jordan-Weiss algorithm, we need to normalize
% the eigenvectors row-wise
if Type == 3
    U = bsxfun(@rdivide, U, sqrt(sum(U.^2, 2)));
end

% now use the k-means algorithm to cluster U row-wise
% C will be a n-by-1 matrix containing the cluster number for
% each data point
% disp(' ---------------------------------- K mean started ...  ----------------------------------');
% C = kmeans(U, k, 'start', 'cluster', ...
%                  'EmptyAction', 'singleton');
rng(1)
[C,Center] = kmeans(real(U), k, 'start', 'plus', ...
                 'EmptyAction', 'singleton',...
                 'Replicates',5);
% C = kmeans(U, k, 'start', 'plus', ...
%                  'EmptyAction', 'singleton');
             
% disp(' ---------------------------------- K mean finished ----------------------------------');

% now convert C to a n-by-k matrix containing the k indicator
% vectors as columns
% C = sparse(1:size(D, 1), C, 1);

end


