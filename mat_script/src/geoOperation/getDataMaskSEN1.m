function [ mask ] = getDataMaskSEN1(geoTiffDir, patchSize)
% The function getDataMask find a [R x C] numpy array of 0 and 1, which indicating the availability of data in each pixel. R is the row number of data, C is the column number of data.
%       Input:
%               -       geoTiffDir              - directory to a geotiff file of data, geo-coded in UTM coordinate system
%               -       patchSize               - a scale number indicating the size of patch for later use
%       Output:
%               -       mask                    - a [R x C] array of '1' and '0', '1': data available with given patch size, '0': otherwise

% load data
[im,~] = geotiffread(geoTiffDir);

% data mask
mask = (im(:,:,1)+im(:,:,4))>0;

% get rid of data near boundary
if patchSize > 1
    se = strel('rectangle',[ceil(patchSize/2),ceil(patchSize/2)]);
    mask = imerode(mask,se);
end

end

