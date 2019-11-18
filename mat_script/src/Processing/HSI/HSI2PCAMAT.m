function [ mat ] = HSI2PCAMAT( HSI )
%Convert the data format of HSI into an other which could be used in 'pca'
%principal component analysis
%   Input
%       - HSI           - HSI data (ROW x COLUMN x BAND)
%
%   Output
%       - mat           - HSI data for pca (SAMPLE x BAND)
%                         SAMPLE = ROW x COLUMN
%

[r,c,b] = size(HSI);
mat = permute(reshape(HSI,r*c,1,b),[1,3,2]);


end

