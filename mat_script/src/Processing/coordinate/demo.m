% Example:

% path to lcz geotiff label
labelGeoTif = 'E:\So2Sat\LCZ29\LCZ29\amsterdam\amsterdam_lcz_GT.tif';
% path to data
dataGeoTif = 'E:\So2Sat\data\amsterdam\mosaic_geotiff_dat\201612\mosaic_geotif.tif';


[ ROW_dat,COL_dat,row_lab,col_lab,xWorld,yWorld ] = findDataFromLabel_v3( labelGeoTif,dataGeoTif );

temp = geotiffread(labelGeoTif);

label = temp(sub2ind(size(temp),row_lab,col_lab));