function [ polsar ] = sen1DataRead( path )
%This function reads the Sentinel-1 data
%   - Input:
%       - path              -- directory to a sentinel-1 geotiff file
%   - Output:
%       - polsar            -- extracted PolSAR data



% path = 'D:\Matlab\SDG\data\munich\SE1\mosaic.tif'

% read data from geotiff file
[polsar,~]=geotiffread(path);
polsar = cat(3,polsar(:,:,1),polsar(:,:,4),polsar(:,:,2:3));


end
