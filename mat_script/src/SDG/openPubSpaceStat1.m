function [opsShare,mdStat,opsStat,meanDist2OPS,opsAreaOPS,opsCenter] = openPubSpaceStat1(lczTif,popTif)
%   Detailed explanation goes here
%   - input
%       - lczTif        -- a geotiff file of lcz classification map
%       - popTif        -- a geotiff file of population map corresponding to the lcz geotiff
%
%   - output
%       - opsShare      -- the average share of OPS to the buildup area, for one city, unit in percentage (%)
%       - meanDist2OPS  -- a map shows the mean distance to the OPS, within 2 kilometers, unit in meter (m)
%       - opsAreaOPS    -- a map shows the area of accessible OPS, within 2 kilometers, unit in square meter (m²)
%       - mdStat        -- statistics of the mean distance to OPS, 2 x 3 array, 
%                       -- first row:  	|	-   	|	mean   	|	standard deviation 
%			   (mean and std of distance to ops of a city)
%                       -- second row: 	|	close 	|	middle 	|	far		   
% 			   (percentages of population that live in three quantile of the distant map,0-30%, 30-70%, and 70-100%)
%			
%       - opsStat       -- statistics of the area of OPS, 2 x 3 matrix
%                       -- first row:  |       -       |       mean    |       standard deviation 
%                          (mean and std of ops area of a city)
%                       -- second row: |       close   |       middle  |       far                
%                          (percentages of population that live in three quantile of the ops area map,0-30%, 30-70%, and 70-100%)
%


% extract open public space
disp('extract open public space ...')
[opsShare,meanDist2OPS,opsAreaOPS,opsCenter] = openPubSpace1(lczTif);

% load population data
disp('load population data ...')
pop = single(geotiffread(popTif));
lcz = geotiffread(lczTif);
sz = size(lcz);clear lcz;
popTmp = imresize(pop,sz,'nearest');
pop = popTmp*sum(pop(:))/sum(popTmp(:)); clear popTmp;

noDataValue = min(meanDist2OPS(:));

% calcuates statistics
mdStat = zeros(2,3);
opsStat = zeros(2,3);

% distance to ops mean and std
datTmp = meanDist2OPS(:);
datTmp(datTmp==noDataValue) = [];
mdStat(1,2) = mean(datTmp);
mdStat(1,3) = std(datTmp);

% distance to ops population share
quantileTmp = quantile(datTmp(:),[0,0.3,0.7,1]);
for i = 2:length(quantileTmp)
    mask = (meanDist2OPS>quantileTmp(i-1))&(meanDist2OPS<=quantileTmp(i));
    mdStat(2,i-1) = sum(pop(mask(:)))/sum(pop(:));
end

% ops area mean and std
datTmp = opsAreaOPS(:);
datTmp(datTmp==noDataValue) = [];
opsStat(1,2) = mean(datTmp);
opsStat(1,3) = std(datTmp);

% ops area population share
quantileTmp = quantile(datTmp(:),[0,0.3,0.7,1]);
for i = 2:length(quantileTmp)
    mask = (opsAreaOPS>quantileTmp(i-1))&(opsAreaOPS<=quantileTmp(i));
    opsStat(2,i-1) = sum(pop(mask(:)))/sum(pop(:));
end

end
