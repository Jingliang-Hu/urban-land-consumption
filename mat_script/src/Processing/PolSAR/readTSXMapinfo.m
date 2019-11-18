function [ mRef ] = readTSXMapinfo( path )
%This function reads the map information of polsar data
%   Input:
%       - path          - the path to the tif file
%   Output:
%       - R             - mapRasterReference


% read the geo-reference data
p = [path '\TSX.tif'];
[~, mRef] = geotiffread(p);

end

