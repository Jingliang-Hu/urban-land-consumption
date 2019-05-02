function [ coord, label] = deleteLabelOutDataExtent(coord, label, dataDir, EPSG)
% The function deleteLabelOutDataExtent delete the label and its coordinates, which are located out of the extent of data
%       Input:
%               -       coord                   - UTM zone coordinate of label, [N x 2] numpy array. 1st col: x; 2nd col: y
%               -       label                   - code of labels, [N x 1] numpy array. N: number of labels
%               -       dataDir                 - directory to a geotiff file of data, geo-coded in UTM coordinate system
%               -       EPSG                    - EPSG code, indicating the UTM zone of input coordinate
%       Output:
%               -       coord                   - UTM zone coordinate of label, [N x 4] numpy array. 1st col: x; 2nd col: y; 3rd col: row number; 4th col: col number
%               -       label                   - code of labels, [N x 1] numpy array. N: number of labels

% dataDir = 'D:\Matlab\SDG\data\munich\SE1\mosaic.tif'

% load geo information
info = geotiffinfo(dataDir);

% load the EPSG code of data
data_EPSG = info.GeoTIFFCodes.PCS;

if isempty(data_EPSG)
    disp('Geo-coordinates are not in WGS84/UTM');
    return
end


% check whether input coordinates and data coordinates are in the same UTM zone or not
if data_EPSG~=EPSG 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    disp('ERROR:           input coordinates and data coordinates are NOT in the same UTM zone')
    disp(['INPUT EPSG:      ',num2str(EPSG)])
    disp(['DATA EPSG :      ',num2str(data_EPSG)])
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
end

% delete the label that out of boundary
% western side
outIdx = coord(:,1)<min(info.CornerCoords.X);
coord(outIdx,:) = [];
label(outIdx) = [];

% eastern side
outIdx = coord(:,1)>max(info.CornerCoords.X);
coord(outIdx,:) = [];
label(outIdx) = [];

% northern side
outIdx = coord(:,2)>max(info.CornerCoords.Y);
coord(outIdx,:) = [];
label(outIdx) = [];

% southern side
outIdx = coord(:,2)<min(info.CornerCoords.Y);
coord(outIdx,:) = [];
label(outIdx) = [];


end

