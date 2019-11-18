function [opsShare,meanDist2OPS,opsAreaOPS,opsCenter] = openPubSpace1(lczTif)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   - output
%       - opsShare      -- the average share of OPS to the buildup area, for one city, unit in percentage (%)
%       - meanDist2OPS  -- a map shows the mean distance to the OPS, within 2 kilometers, unit in meter (m)
%       - opsAreaOPS    -- a map shows the area of accessible OPS, within 2 kilometers, unit in square meter (m²)
%
%
% noDataValue = -10;

% lczTif = 'OUTPUT/claMap_cLCZ.tif';


lcz = geotiffread(lczTif);

builtUp = sum(lcz(:)<=10);
opsArea = sum(lcz(:)>10 & lcz(:)~=107);

opsShare = single(opsArea)./builtUp;
clear builtup opsArea 


% set up neighborhood
res = 10;
neighborDist = 2000; % meter
neighborPix  = neighborDist/res;
neighborKernel = strel('sphere',neighborPix);
neighborKernel = neighborKernel.Neighborhood(:,:,neighborPix+1);

% neighborhood kernel of distance
distKernel = ...
    sqrt( ...
    (repmat( 1:size(neighborKernel,2),  size(neighborKernel,1),1)-ceil(size(neighborKernel,1)/2)*ones(size(neighborKernel))).^2 + ...
    (repmat((1:size(neighborKernel,2))',1,size(neighborKernel,1))-ceil(size(neighborKernel,1)/2)*ones(size(neighborKernel))).^2 ...
    ).*neighborKernel.*res;


% 
ops = (lcz>10)&(lcz~=107);

opsCount = conv2(ops,neighborKernel,'same');
opsDist  = conv2(ops,distKernel,'same');

opsCount(opsCount<10) = 0;
mask = opsCount==0;
meanDist2OPS = opsDist./opsCount;
meanDist2OPS(mask(:)) = max(distKernel(:));
% meanDist2OPS(lcz==107) = noDataValue;

opsAreaOPS = opsCount * 100;
% opsAreaOPS(lcz==107) = noDataValue;

opsCenter = (opsCount>4e4)+(meanDist2OPS<1000);
end