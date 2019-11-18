function [ ROW_dat,COL_dat,row_lab,col_lab,xWorld,yWorld ] = findDataFromLabel_v3( labelGeoTif,dataGeoTif )
%only cope with the data sets which aligns the cooridinate to the center of
%pixels, ONLY geotiff for now.
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example:
% labelGeoTif = 'E:\So2Sat\LCZ29\LCZ29\rome\rome_lcz_GT.tif';
% dataGeoTif = 'E:\So2Sat\data\rome\mosaic_geotiff_dat\201612\mosaic_geotif.tif'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% read geo information of label geotiff
labelGeoInfo = geotiffinfo(labelGeoTif);
labelgeometa = geoMeta_v1( labelGeoInfo,'format','tif' );
% read label information of label geotiff
labelGeoData = geotiffread(labelGeoTif);
% find the row and column of labels
[row_lab,col_lab] = find(labelGeoData>0);
% calculate the world coordinate
xWorld = labelgeometa.XWorldLimits(1) + (col_lab - 1) * labelgeometa.CellExtentInWorldX;
yWorld = labelgeometa.YWorldLimits(2) - (row_lab - 1) * labelgeometa.CellExtentInWorldY;

% read geo information of data geotiff
dataGeoInfo = geotiffinfo(dataGeoTif);
datageometa = geoMeta_v1( dataGeoInfo,'format','tif' );
% find the row and column of data corresponding to the label location
COL_dat = round((xWorld - datageometa.XWorldLimits(1))./datageometa.CellExtentInWorldX) + 1;
ROW_dat = round((datageometa.YWorldLimits(2) - yWorld)./datageometa.CellExtentInWorldY) + 1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Validation:
% data = geotiffread(dataGeoTif);
% sarIm = rgbBandStrech(data(:,:,1));
% figure,imshow(sarIm)
% hold on
% scatter(COL_dat,ROW_dat,'o')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

