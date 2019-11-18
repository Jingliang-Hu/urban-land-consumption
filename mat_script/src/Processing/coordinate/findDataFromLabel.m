function [ ROW_dat,COL_dat,row_lab,col_lab ] = findDataFromLabel( labelGeoTif,dataGeoTif )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example:
% labelGeoTif = 'E:\So2Sat\LCZ29\LCZ29\rome\rome_lcz_GT.tif';
% dataGeoTif = 'E:\So2Sat\data\rome\geotiff\201612\sentinel-1_roi.tif'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read geo information of label geotiff
labelGeoInfo = geotiffinfo(labelGeoTif);
labelgeometa = geoMeta( labelGeoInfo,'format','tif' );
% read label information of label geotiff
labelGeoData = geotiffread(labelGeoTif);
% find the row and column of labels
[row_lab,col_lab] = find(labelGeoData>0);
% calculate the world coordinate
xWorld = labelgeometa.XWorldLimits(1) + col_lab * labelgeometa.CellExtentInWorldX;
yWorld = labelgeometa.YWorldLimits(2) - row_lab * labelgeometa.CellExtentInWorldY;

% read geo information of data geotiff
dataGeoInfo = geotiffinfo(dataGeoTif);
datageometa = geoMeta( dataGeoInfo,'format','tif' );
% find the row and column of data corresponding to the label location
COL_dat = ceil((xWorld - datageometa.XWorldLimits(1))./datageometa.CellExtentInWorldX + dataGeoInfo.CornerCoords.Col(1));
ROW_dat = ceil((datageometa.YWorldLimits(2) - yWorld)./datageometa.CellExtentInWorldX + dataGeoInfo.CornerCoords.Row(1));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Validation:
% data = geotiffread(dataGeoTif);
% sarIm = rgbBandStrech(data(:,:,1));
% figure,imshow(sarIm)
% hold on
% scatter(COL_dat,ROW_dat,'o')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

