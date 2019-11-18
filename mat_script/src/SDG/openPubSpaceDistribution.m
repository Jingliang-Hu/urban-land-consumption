function [opsDistriFeat, opsShare, popTotal, ops, meanDist2OPS, opsLandPerc, opsPopPerc] = openPubSpaceDistribution(lczTif,popTif)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   - output
%       - opsDistriFeat -- open public space feature of a city, a 1 by 4 array
% 			   opsDistriFeat(1): median distance of pairwise distances of all isolated open public space
% 			   opsDistriFeat(2): mean distance of pairwise distances of all isolated open public space
%                          opsDistriFeat(3): standard deviation of pairwise distances of all isolated open public space
%                          opsDistriFeat(4): number of isolated open public space
% 	- opsShare 	-- the share of a city that is open public space
%       - ops   	-- a map shows the open public space
% 	- meanDist2OPS	-- a map shows the average distance to the open public space, within 2 kilometers neighborhood
% 	- opsLandPerc 	-- the land shares that has different distance of accessing open public space, a 1 by 5 array
%                          opsLandPerc(1): the share of land that has a mean distance of 0 to 500 meters for accessing the open public space
%                          opsLandPerc(2): the share of land that has a mean distance of 500 to 1000 meters for accessing the open public space
%                          opsLandPerc(3): the share of land that has a mean distance of 1000 to 1500 meters for accessing the open public space
%                          opsLandPerc(4): the share of land that has a mean distance of 1500 to 2000 meters for accessing the open public space
%                          opsLandPerc(5): the share of land that has a mean distance of 2000 to 2000+ meters for accessing the open public space


%% load data
lcz = geotiffread(lczTif);
waterMask = lcz==107;

pop = single(geotiffread(popTif));
popTotal = sum(pop(:));
popTmp = imresize(pop,size(lcz),'nearest');
popTotalTmp = sum(popTmp(:));
pop = popTmp*popTotal/popTotalTmp; clear popTmp;
popTotalTmp = sum(pop(:));


%% derive open public space
ops = (lcz>10 & lcz~=107 & lcz~=105);
CC = bwconncomp(ops);
idx = cellfun(@length,CC.PixelIdxList);
idx = idx<50;
CC.PixelIdxList(idx) = [];
CC.NumObjects = length(CC.PixelIdxList);
ops = zeros(size(ops));
opsNodes = zeros(CC.NumObjects,2);

for i = CC.NumObjects:-1:1
    ops(CC.PixelIdxList{i}) = i;
    [rowTmp,colTmp] = ind2sub(CC.ImageSize,CC.PixelIdxList{i});
    opsNodes(i,:) = [mean(rowTmp),mean(colTmp)];
end

%% derive the share of open public space
opsShare = sum(ops(:)>=1)./sum(~waterMask(:));


%% ops distribution
dMat = pdist(opsNodes);
opsDistriFeat = [median(dMat),mean(dMat),std(dMat),CC.NumObjects];
clear dMat
%% access to open public space 1
% tic
%res = 10;
%neighborDist = 200:200:2000; % meter
%neighborPix  = neighborDist/res;

%mask = ops==1;
%meanDist2OPS = zeros(size(ops));

%for idx_neighbor = 1:length(neighborPix)
%    if all(mask(:))
%        break;
%    end
%    neighborKernel = strel('sphere',neighborPix(idx_neighbor));
%    neighborKernel = neighborKernel.Neighborhood(:,:,neighborPix(idx_neighbor)+1);
%    % neighborhood kernel of distance
%    distKernel = ...
%        sqrt( ...
%        (repmat( 1:size(neighborKernel,2),  size(neighborKernel,1),1)-ceil(size(neighborKernel,1)/2)*ones(size(neighborKernel))).^2 + ...
%        (repmat((1:size(neighborKernel,2))',1,size(neighborKernel,1))-ceil(size(neighborKernel,1)/2)*ones(size(neighborKernel))).^2 ...
%        ).*neighborKernel.*res;
%
%    opsCount = conv2(ops, neighborKernel,'same');
%    opsDist  = conv2(ops, distKernel,'same');
%
%    meanDist2OPS(~mask(:)) = opsDist(~mask(:))./opsCount(~mask(:));
%    mask = mask | (opsCount>25);
%end
%meanDist2OPS(~mask(:)) = max(distKernel(:));
% toc
% figure,imagesc(meanDist2OPS);
tic;
meanDist2OPS = shortestDist1(ops);
toc;

meanDist2OPS(waterMask) = -10;
perc = .2:.2:1;
opsLandPerc = quantile(meanDist2OPS(meanDist2OPS(:)>=0),perc);
opsPopPerc = zeros(size(perc));
thres = [0,opsLandPerc];
for i = 2:length(thres)
    opsLandMask = (meanDist2OPS(:)>=thres(i-1))&(meanDist2OPS(:)<thres(i));
    opsPopPerc(i-1) = sum(pop(opsLandMask(:)))/popTotalTmp;
end
opsLandMask = meanDist2OPS(:)>=thres(i);
opsPopPerc(i) = sum(pop(opsLandMask(:)))/popTotalTmp;
disp(['ops pop perc: ',num2str(opsPopPerc)])

%% access to open public space 2
% tic
% res = 10;
% meanDist2OPS = 2010*ones(size(ops));
% meanDist2OPS(ops(:)==1) = 0;
% mask = ops==1;
% seCross = strel('disk',1);
% seSquare = strel('rectangle',[3,3]);
% dist = 1;
% d1 = 1;
% d2 = sqrt(2);
% while ~all(mask(:))&&dist~=201
%     maskUpdate = imdilate(mask,se);
%     meanDist2OPS((maskUpdate(:)==1)&(mask(:)==0)) = dist;
%     mask = maskUpdate;
%     dist = dist+1;
% end
% meanDist2OPS = meanDist2OPS*res;
% toc
% figure,imagesc(meanDist2OPS);

end
