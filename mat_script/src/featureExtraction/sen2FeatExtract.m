function [ se2Feat ] = sen2FeatExtract( path )
%This function extracts features from the Sentinel-2 data
%   - Input:
%       - path              -- directory to a sentinel-2 geotiff file
%   - Output:
%       - se2Feat           -- extracted sentinel-2 feature



% path = 'D:\Matlab\SDG\data\munich\SE2\204371_summer.tif'

% read data from geotiff file
[se2data,~]=geotiffread(path);
if size(se2data,2)>40
   disp('The dimension of Sentinel-2 data is larger than 40. It is probably a L2A product. Only first 12 dimensions are used.')
    se2data = se2data(:,:,1:12);
end
% extract data mask
mask = sum(se2data,3)==0;
% apply pca on data
dataTmp = reshape(se2data,size(se2data,1)*size(se2data,2),size(se2data,3));
dataTmp = dataTmp(~mask(:),:);
dataTmp = pca_dr(double(dataTmp));
temp = zeros(size(se2data,1)*size(se2data,2),size(dataTmp,2));
temp(~mask,:) = dataTmp;
se2FeatTmp = reshape(temp,size(se2data,1),size(se2data,2),size(temp,2));
% morphological profile on pcs
r1 = 1:3;
r2 = r1;
options = 'MPr';
se2Feat=[];
for i=1:size(se2FeatTmp,3)
   MPNeachpca = Make_Morphology_profile(se2FeatTmp(:,:,i),r1,r2,options);
   se2Feat = cat(3,se2Feat,MPNeachpca);        
end

end
