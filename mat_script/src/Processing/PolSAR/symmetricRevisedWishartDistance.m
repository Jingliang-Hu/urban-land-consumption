function [ dist ] = symmetricRevisedWishartDistance( C_1,C_2 )
%This function calculate the 'symmetric Revised Wishart Distrance'
% Anfinsen et al., "SPECTRAL CLUSTERING OF POLARIMETRIC SAR DATA WITH 
% WISHART-DERIVED DISTANCE MEASURES"
%
%   Input:
%       - C_1           -- polsarpro matrix form 
%       - C_2           -- polsarpro matrix form 
%   polsarpro format:
%       (nb_row by nb_column by nb_chl) or (nb_pixel by 1 by nb_chl)
% -------------------------------------------------------------------------
%
%   Output:
%       - dist          -- symmetric Revised Wishart Distrance

[n,~,q] = size(C_2);
q = sqrt(q);
dist = zeros(n,1);
C_1 = polsarproMatrix2Matrix(C_1);
C_2 = polsarproMatrix2Matrix(C_2);

for i = 1:n
    dist(i) = trace(C_1/C_2(:,:,i) + C_2(:,:,i)/C_1)./2 - q;
end

dist = real(dist);
end

