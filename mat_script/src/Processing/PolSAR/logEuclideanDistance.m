function [ dist ] = logEuclideanDistance( C_1,C_2 )
%This function calculate the 'log-Euclidean Distrance'
% Arsigny et al., "Log-Euclidean Metrics for Fast and Simple Calculus
% on Diffusion Tensors"
%
%   Input:
%       - C_1           -- normal matrix form 3 by 3
%       - C_2           -- normal matrix form 3 by 3 by n
%
%   Output:
%       - dist          -- symmetric Revised Wishart Distrance

[n,~,~] = size(C_2);
dist = zeros(n,1);
C_1 = polsarproMatrix2Matrix(C_1);
C_2 = polsarproMatrix2Matrix(C_2);

for i = 1:n
    dist(i) = norm((logm(C_2(:,:,i)) - logm(C_1)),'fro')^2;
end


end

