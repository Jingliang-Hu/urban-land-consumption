function [ coord, label, EPSG ] = getROICoord( path )
% Function getCoordAndLabel get the coordinate of label and the code of labels.
%       Input:
%               -       geoTiffDir              - directory to a geotiff file of label, geo-coded in UTM coordinate system
%               -       claCode                 - code of classes indicating which class label need to be extracte
%                                                 default value 1:17; all LCZ classes
%       Output:
%               -       coord                   - UTM zone coordinate of label, [N x 4] numpy array. 1st col: x; 2nd col: y; 3rd col: row number; 4th col: col number
%               -       label                   - code of labels, [N x 1] numpy array. N: number of labels
%               -       EPSG                    - EPSG code, indicating the UTM zone of input data
% 

% path = 'D:\Matlab\SDG\data\munich\GT\munich_lcz_GT_train.tif'

% load label and geo information
[im,ref] = geotiffread(path);
info = geotiffinfo(path);

% load the EPSG code of data
EPSG = info.GeoTIFFCodes.PCS;

if isempty(EPSG)
    disp('Geo-coordinates are not in WGS84/UTM');
end

[row,col] = size(im);
% load the label
r = repmat((1:row)',col,1);
c = repmat(1:col,row,1);
c = c(:);
label = im(sub2ind(size(im), r, c));
% load the coordinates of labels
coord = zeros(length(r),4);
coord(:,1) = ref.XWorldLimits(1) + (c-1)*ref.CellExtentInWorldX;
coord(:,2) = ref.YWorldLimits(2) - (r-1)*ref.CellExtentInWorldY;
coord(:,3:4) = [r,c];

end

