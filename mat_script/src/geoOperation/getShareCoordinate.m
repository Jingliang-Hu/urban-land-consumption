function [ imCoord, label ] = getShareCoordinate( labelDir,se1Dir,se2Dir,patchSize )
%This function loads the real world coordinates and image coordinates of
%labeled data that exists in both sentinel-1 and sentinel-2 data
%       Input:
%               -       labelDir                - directory to a geotiff file of label, geo-coded in UTM coordinate system
%               -       se1Dir                  - directory to a geotiff file of sentinel-1 data, geo-coded in UTM coordinate system
%               -       se2Dir                  - directory to a geotiff file of sentinel-2 data, geo-coded in UTM coordinate system
%               -       patchSize               - patch size of data organization
%
%       Output:
%               -       imCoord                 - label coordiantes, [N x 8] numpy array. 
%               -       label                   - code of labels, [N x 1] numpy array. N: number of labels
% 
% imCoord is a [N x 8] numpy array
%       1st column               UTM X
%       2nd column               UTM Y
%       3rd column               SEN1 row number
%       4th column               SEN1 col number
%       5th column               SEN2 row number
%       6th column               SEN2 col number
%       7th column               label row number
%       8th column               label col number

% load the real world label coordinate
[ coord, label, EPSG ] = getCoordAndLabel( labelDir );

% delete the labels outside SE1 data
[ coord, label] = deleteLabelOutDataExtent(coord, label, se1Dir, EPSG);

% delete the labels outside SE2 data
[ coord, label] = deleteLabelOutDataExtent(coord, label, se2Dir, EPSG);

% get the image coordinates of label in SEN1 data
[ imCoord ] =  getImCoord(se1Dir, coord, EPSG, 's1');

% get the image coordinates of label in SEN2 data
[ imCoord_tmp ] =  getImCoord(se2Dir, coord, EPSG, 's2');
imCoord(:,5:6) = imCoord_tmp(:,5:6); clear imCoord_tmp

% get the SEN1 data mask
[ mask ] = getDataMaskSEN1(se1Dir, patchSize);

% delete the labels locates in no data area of SEN1
[ imCoord, label ] = deleteLabelOutDataMask(imCoord, label, mask, 's1', patchSize);

% get the SEN2 data mask
[ mask ] = getDataMaskSEN2(se2Dir, patchSize);

% delete the labels locates in no data area of SEN2
[ imCoord, label ] = deleteLabelOutDataMask(imCoord, label, mask, 's2', patchSize);


end

