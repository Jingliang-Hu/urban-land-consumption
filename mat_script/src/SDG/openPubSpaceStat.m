function [opsShare,mdStat,opsStat,meanDist2OPS,opsAreaOPS] = openPubSpaceStat(lczTif,popTif)
%   Detailed explanation goes here
%   - input
%       - lczTif        -- a geotiff file of lcz classification map
%       - popTif        -- a geotiff file of population map corresponding to the lcz geotiff
%
%   - output
%       - opsShare      -- the average share of OPS to the buildup area, for one city, unit in percentage (%)
%       - meanDist2OPS  -- a map shows the mean distance to the OPS, within 2 kilometers, unit in meter (m)
%       - opsAreaOPS    -- a map shows the area of accessible OPS, within 2 kilometers, unit in square meter (m²)
%       - mdStat        -- statistics of the mean distance to OPS, 3 x 6 matrix
%                       -- first row:  0   0.2   0.4   0.6   0.8   1 (quantile percentage)
%                       -- second row: 0   aaa   bbb   ccc   ddd   e (mean distance values correpond to quantile percentages)
%                       -- third row:  0   AAA   BBB   CCC   DDD   E (share of population that live in the corresponding region)
%       - opsStat       -- statistics of the area of OPS, 3 x 6 matrix
%                       -- first row:  0   0.2   0.4   0.6   0.8   1 (quantile percentage)
%                       -- second row: 0   aaa   bbb   ccc   ddd   e (area values correpond to quantile percentages)
%                       -- third row:  0   AAA   BBB   CCC   DDD   E (share of population that live in the corresponding region)

% extract open public space
disp('extract open public space ...')
[opsShare,meanDist2OPS,opsAreaOPS] = openPubSpace(lczTif);

% load population data
disp('load population data ...')
pop = single(geotiffread(popTif));
lcz = geotiffread(lczTif);
sz = size(lcz);clear lcz;
popTmp = imresize(pop,sz,'nearest');
pop = popTmp*sum(pop(:))/sum(popTmp(:)); clear popTmp;

noDataValue = min(meanDist2OPS(:));

% calcuates statistics
mdStat = [0:.2:1;zeros(1,6);zeros(1,6)];
opsStat = [0:.2:1;zeros(1,6);zeros(1,6)];

datTmp = meanDist2OPS;
datTmp(datTmp==noDataValue) = [];
mdStat(2,:) = quantile(datTmp(:),mdStat(1,:));
for i = 2:size(mdStat,2)
    mask = (meanDist2OPS>=mdStat(2,i-1))&(meanDist2OPS<=mdStat(2,i));
    mdStat(3,i) = sum(pop(mask(:)))/sum(pop(:));
end


datTmp = opsAreaOPS;
datTmp(datTmp==noDataValue) = [];
opsStat(2,:) = quantile(datTmp(:),opsStat(1,:));
for i = 2:size(opsStat,2)
    mask = (opsAreaOPS>=opsStat(2,i-1))&(opsAreaOPS<=opsStat(2,i));
    opsStat(3,i) = sum(pop(mask(:)))/sum(pop(:));
end

end
