function [ imCoord ] =  getImCoord(geoTiffDir, coord, EPSG, flag)
% The function getImCoord find the image location of data, which corresponding to the label
%       Input:
%               -       geoTiffDir              - directory to a geotiff file of data, geo-coded in UTM coordinate system
%               -       coord                   - UTM zone coordinate of label, [N x 4] numpy array. 1st col: x; 2nd col: y; 3rd col: row number; 4th col: col number
%               -       EPSG                    - The EPSG code indicating the UTM zone of input coordinate
%               -       flag                    - flag indicating the input geotiff is SENTINEL-1 data "s1", or SENTINEL-2 data "s2"
%       Output:
%               -       imCoord                 - a [N x 6] numpy array
%                                                       1st column               UTM X
%                                                       2nd column               UTM Y
%                                                       3rd column               SEN1 row number
%                                                       4th column               SEN1 col number
%                                                       5th column               SEN2 row number
%                                                       6th column               SEN2 col number
%                                                       7th column               label row number
%                                                       8th column               label col number


% load geo information
info = geotiffinfo(geoTiffDir);

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

% initial output image coordinate
imCoord = zeros(size(coord,1),8);
imCoord(:,1:2) = coord(:,1:2);

% get the image coordinates
switch flag
    case 's1'
        imCoord(:,3) = round((info.RefMatrix(3,2) - coord(:,2))/abs(info.RefMatrix(1,2)));
        imCoord(:,4) = round((coord(:,1) - info.RefMatrix(3,1))/abs(info.RefMatrix(2,1)));
    case 's2'
        imCoord(:,5) = round((info.RefMatrix(3,2) - coord(:,2))/abs(info.RefMatrix(1,2)));
        imCoord(:,6) = round((coord(:,1) - info.RefMatrix(3,1))/abs(info.RefMatrix(2,1)));
end

imCoord(:,7:8) = coord(:,3:4);
end

