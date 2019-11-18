function [ HSI_component ] = PCAMAT2HSI( mat,row )
%Convert the data format of HSI for pca into normal data format of HSI
%
%   Input
%       - mat           - HSI data for pca (SAMPLE x BAND)
%                         SAMPLE = ROW x COLUMN
%       - row           - number of ROW
%
%   Output
%       - HSI           - HSI data (ROW x COLUMN x BAND)



r = row;
[s,d] = size(mat);
c=s/r;
HSI_component=reshape(permute(mat,[1,3,2]),r,c,d);


end

