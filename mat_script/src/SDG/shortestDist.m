function [closestDistMap] = shortestDist(ops)

    closestDistMap = zeros(size(ops));
    extentMask = ops;
    se = strel('disk',1);
    dist=1;


    while any(extentMask(:)==0)
        tmpMask = imdilate(extentMask,se);
        extentMask(extentMask(:)==0) = tmpMask(extentMask(:)==0);
        dist = dist+1;
    end
    clear tmpMask;
    extentMask = extentMask - ops;

    for idx = 1:max(extentMask(:))
        [r,c] = find(extentMask==idx);
        coord = [r,c];
        idxLoc = sub2ind(size(extentMask),r,c);
        [r,c] = find(ops==idx);
        opsCoord = [r,c];clear r c;
        D = pdist2(opsCoord,coord,'euclidean','Smallest',1);
        closestDistMap(idxLoc) = D;
    end
    closestDistMap = closestDistMap*10;
    closestDistMap(ops(:)>0)=0;

end

