function [ dist_mat ] = euclidean_dist( point )
%This function calculate the distance matrix of Euclidean_distance.
%   Input:
%           - point             -- N by M matrix, N points with M dimension
%
%   Output:
%           - dist_mat          -- symmetric distance matrix N by N
%
[r,~] = size(point);
dist_mat = zeros(r,r);
for i = 1:r
    dist_mat(:,i) = sqrt(sum((repmat(point(i,:),r,1)-point).^2,2));
end

end

