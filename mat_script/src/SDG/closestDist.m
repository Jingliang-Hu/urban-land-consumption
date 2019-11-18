function [closestDistMap] = closestDist(mask)

    
    closestDistMap = zeros(size(mask));
    dist = 1;
    while ~all(mask(:)) && dist~=201
        % up
        maskTmp = circshift(mask,[-1,0]);
        maskTmp(end,:) = 0;
        maskTmp = (maskTmp-mask)==1;
        maskBoundary = circshift(maskTmp,[1,0]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + 1;
        % down
        maskTmp = circshift(mask,[1,0]);
        maskTmp(1,:) = 0;
        maskTmp = (maskTmp-mask)==1;
        maskBoundary = circshift(maskTmp,[-1,0]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + 1;
        % left
        maskTmp = circshift(mask,[0,-1]);
        maskTmp(:,end) = 0;
        maskTmp = (maskTmp-mask)==1;
        maskBoundary = circshift(maskTmp,[0,1]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + 1;
        % right
        maskTmp = circshift(mask,[0,1]);
        maskTmp(:,1) = 0;
        maskTmp = (maskTmp-mask)==1;
        maskBoundary = circshift(maskTmp,[0,-1]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + 1;
        % mask to ensure verticle or horizontal shortest distance, instead of tiled
        maskMid = (mask+closestDistMap)>0
        closestDistMap
        % up-left
        maskTmp = circshift(mask,[-1,-1]);
        maskTmp(:,end) = 0;
        maskTmp(end,:) = 0;
        maskTmp = (maskTmp-maskMid)==1;
        maskBoundary = circshift(maskTmp,[1,1]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + sqrt(2);
        % up-right
        maskTmp = circshift(mask,[-1,1]);
        maskTmp(:,1) = 0;
        maskTmp(end,:) = 0;
        maskTmp = (maskTmp-maskMid)==1;
        maskBoundary = circshift(maskTmp,[1,-1]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + sqrt(2);
        % bottom-left
        maskTmp = circshift(mask,[1,-1]);
        maskTmp(:,end) = 0;
        maskTmp(1,:) = 0;
        maskTmp = (maskTmp-maskMid)==1;
        maskBoundary = circshift(maskTmp,[-1,1]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + sqrt(2);
        % bottom-right
        maskTmp = circshift(mask,[1,1]);
        maskTmp(:,1) = 0;
        maskTmp(1,:) = 0;
        maskTmp = (maskTmp-maskMid)==1;
        maskBoundary = circshift(maskTmp,[-1,-1]);
        closestDistMap(maskTmp(:)) = closestDistMap(maskBoundary(:)) + sqrt(2);
        % update mask
        mask = (mask+closestDistMap)>0;
        dist = dist + 1;
        closestDistMap 
    end


end
