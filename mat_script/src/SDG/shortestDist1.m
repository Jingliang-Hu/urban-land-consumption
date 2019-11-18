function [shortestDist] = shortestDist1(ops)
% this funcion gets the shortest distance to the nearest open public space for each buildup pixel
%	- Input:
%		- ops 		-- an open public space map, each open public space is indicated by an integer
%
%	- Output:
% 		- shortestDist	-- a map shows the shortest distance to a nearest open public space, for each pixel.

% initial output with a large distance
shortestDist = (2201*sqrt(2)+1)*ones(size(ops));
% coordinate of buildup area
[r,c] = find(ops==0);
idxLoc = sub2ind(size(ops),r,c);
coord = [r,c];clear r c;
% temporary array to update the shortest distance to ops for each buildup pixel
tmp = zeros(size(idxLoc));

% set the number of buildup pixels to be updated each time, avoid out of memory.
tile = 50000;

nbOps = max(ops(:));
% parallel calculation is slower than single processor in this case
% delete(gcp('nocreate'));
% par = parpool(20);
% par.IdleTimeout = 600;
for cv = 1:floor(size(coord,1)/tile)
    % temporary array to update the shortest distance to ops for tiled buildup pixel
    tileTmp = zeros(tile,nbOps,'single');
    % temporary array to save the coordinate of tiled buildup pixels
    coordTmp = coord((cv-1)*tile+1:cv*tile,:);
    % go through every open public space, find out the shortest distance to each buildup pixel
    for idx = 1:nbOps    
        [r,c] = find(ops==idx);
        opsCoord = [r,c];
        r = [];c = [];
        D = pdist2(opsCoord,coordTmp,'euclidean','Smallest',1)';
        tileTmp(:,idx) = D;
    end
    tmp((cv-1)*tile+1:cv*tile) = min(tileTmp,[],2);
end


% temporary array to update the shortest distance to ops for the buildup pixel of the last tile
tileTmp = zeros(size(coord(cv*tile+1:end,:),1),nbOps,'single');
% temporary array to save the coordinate of tiled buildup pixels of the last tile
coordTmp = coord(cv*tile+1:end,:);
% go through every open public space, find out the shortest distance to the buildup pixel of the last tile
for idx = 1:nbOps    
    [r,c] = find(ops==idx);
    opsCoord = [r,c];
    r = [];c = [];
    D = pdist2(opsCoord,coordTmp,'euclidean','Smallest',1)';
    tileTmp(:,idx) = D;
end
tmp(cv*tile+1:end) = min(tileTmp,[],2);
% assign the shortest distance to output.    
shortestDist(idxLoc) = tmp;
% zero out the open public space
shortestDist(ops(:)>0)=0;


end
