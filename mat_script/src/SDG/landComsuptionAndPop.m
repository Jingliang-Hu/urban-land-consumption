function [landStat] = landComsuptionAndPop(lczTif,popTif)

%   - input
%       - lczTif        -- a geotiff file of lcz classification map
%       - popTif        -- a geotiff file of population map corresponding to the lcz geotiff
%
%   - output
%       - landStat      -- statistics on land consumption and population, a 2 X 5 matrix
%
%                 |   compact  |  open  |  light  |  industry  |  non-buildup
%       Area share|            |        |         |            |      
%       Popu share|            |        |         |            |            
% 



% load lcz data
disp('load lcz data ...')
lcz = single(geotiffread(lczTif));
lczTmp = lcz;
lczTmp(lczTmp==107) = 0;

% load population data
disp('load population data ...')
pop = single(geotiffread(popTif));
popTmp = imresize(pop,size(lcz),'nearest');
pop = popTmp*sum(pop(:))/sum(popTmp(:)); clear popTmp;


landStat = zeros(4,5);

landStat(1,1) = sum(lczTmp(:)==1)/sum(lczTmp(:)>0);
landStat(1,2) = sum(lczTmp(:)==6)/sum(lczTmp(:)>0);
landStat(1,3) = sum(lczTmp(:)==7)/sum(lczTmp(:)>0);
landStat(1,4) = sum(lczTmp(:)==8)/sum(lczTmp(:)>0);
landStat(1,5) = sum(lczTmp(:)>10)/sum(lczTmp(:)>0);

landStat(2,1) = sum(sum((lczTmp==1).*pop))/sum(pop(:));
landStat(2,2) = sum(sum((lczTmp==6).*pop))/sum(pop(:));
landStat(2,3) = sum(sum((lczTmp==7).*pop))/sum(pop(:));
landStat(2,4) = sum(sum((lczTmp==8).*pop))/sum(pop(:));
landStat(2,5) = sum(sum((lczTmp>10).*pop))/sum(pop(:));

landStat(3,1) = sum(lczTmp(:)==1);
landStat(3,2) = sum(lczTmp(:)==6);
landStat(3,3) = sum(lczTmp(:)==7);
landStat(3,4) = sum(lczTmp(:)==8);
landStat(3,5) = sum(lczTmp(:)>10);

landStat(4,1) = sum(sum((lczTmp==1).*pop));
landStat(4,2) = sum(sum((lczTmp==6).*pop));
landStat(4,3) = sum(sum((lczTmp==7).*pop));
landStat(4,4) = sum(sum((lczTmp==8).*pop));
landStat(4,5) = sum(sum((lczTmp>10).*pop));






end
