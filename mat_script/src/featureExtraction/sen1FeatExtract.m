function [ se1Feat ] = sen1FeatExtract( path )
%This function extracts features from the Sentinel-1 data
%   - Input:
%       - path              -- directory to a sentinel-1 geotiff file
%   - Output:
%       - polFeat           -- extracted PolSAR feature



% path = 'D:\Matlab\SDG\data\munich\SE1\mosaic.tif'

% read data from geotiff file
[polsar,~]=geotiffread(path);
polsar = cat(3,polsar(:,:,1),polsar(:,:,4),polsar(:,:,2:3));
% extract data mask
mask = sum(polsar,3)==0;
% coherence of VV and VH
coh = sqrt(polsar(:,:,3).^2+polsar(:,:,4).^2)./sqrt(polsar(:,:,1).*polsar(:,:,2));
coh(mask) = 0;
% ratio of VV and VH
ratio = (polsar(:,:,1)./polsar(:,:,2));
ratio(mask) = 0;
PolFeat = cat(3,polsar(:,:,1:2),ratio,coh);

%% morphological profile
r1 = 1:3;
r2 = r1;
options = 'MPr';
temp=[];
for i=1:size(PolFeat,3)
   MPNeachpca = Make_Morphology_profile(PolFeat(:,:,i),r1,r2,options);
   temp = cat(3,temp,MPNeachpca);        
end

%% statistics
[ featMean ] = localStat_f( PolFeat,5,'mean' );
[ featStd ]  = localStat_f( PolFeat,5,'std' );
se1Feat = cat(3,temp,featMean,featStd);   

end

