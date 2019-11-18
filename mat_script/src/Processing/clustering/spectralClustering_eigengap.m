function [C, L, vec, val] = spectralClustering_eigengap(W, Type)
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
%   Author: Ingo Buerk
%   Year  : 2011/2012
%   Bachelor Thesis

W(W<1e-5)=0;
% calculate degree matrix

degs = sum(W, 2);
D    = sparse(1:size(W, 1), 1:size(W, 2), degs);

% compute unnormalized Laplacian
L = D - W;

% compute normalized Laplacian if needed
switch Type
    case 2
        % avoid dividing by zero
        degs(degs == 0) = eps;
        % calculate inverse of D
        D = spdiags(1./degs, 0, size(D, 1), size(D, 2));
        
        % calculate normalized Laplacian
        L = D * L;
    case 3
        % avoid dividing by zero
        degs(degs == 0) = eps;
        % calculate D^(-1/2)
        D = spdiags(1./(degs.^0.5), 0, size(D, 1), size(D, 2));
        
        % calculate normalized Laplacian
        L = D * L * D;
end

% compute the eigenvectors corresponding to the k smallest
% eigenvalues

% diff   = eps;
% [~,v,~]=eig(L);
% v = diag(v);
% figure,plot(1:length(v),v);

disp(' ---------------------------------- Eigenvalue decomposition ...  ----------------------------------');
[vec, val] = eig(L);
disp(' ---------------------------------- Eigenvalue solved ----------------------------------');

v = real(diag(val));
[sv,order]=sort(v);

idx =sv(2:end)-sv(1:end-1);
[~,k] = max(idx(1:ceil(length(idx)/3)));
k = k + 1;
U = vec(:,order(1:k));
% while sum(isnan(U(:)))>0
%     [U, v] = eigs(L,k,eps);
% end

% in case of the Jordan-Weiss algorithm, we need to normalize
% the eigenvectors row-wise
if Type == 3
    U = bsxfun(@rdivide, U, sqrt(sum(U.^2, 2)));
end

% now use the k-means algorithm to cluster U row-wise
% C will be a n-by-1 matrix containing the cluster number for
% each data point
disp(' ---------------------------------- K mean started ...  ----------------------------------');
% C = kmeans(U, k, 'start', 'cluster', ...
%                  'EmptyAction', 'singleton');

C = kmeans(real(U), k, 'start', 'plus', ...
                 'EmptyAction', 'singleton',...
                 'Replicates',100);
% C = kmeans(U, k, 'start', 'plus', ...
%                  'EmptyAction', 'singleton');
             
disp(' ---------------------------------- K mean finished ----------------------------------');

% now convert C to a n-by-k matrix containing the k indicator
% vectors as columns
% C = sparse(1:size(D, 1), C, 1);

end























