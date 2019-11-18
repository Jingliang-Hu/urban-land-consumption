function [ R ] = mosaicSentinel2Data( dataPath1,dataPath2,savePath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[ x1,y1,nrows1,ncol1 ] = readSentinel2MetaXML( [dataPath1,'metadata.xml'] );
[ x2,y2,nrows2,ncol2 ] = readSentinel2MetaXML( [dataPath2,'metadata.xml'] );
if y1~=y2
    disp('----------------------------------------------------------------');
    disp('not aligned on y direction');
    disp('----------------------------------------------------------------');
    return;
end




% file name of each band
fileNames = {'B01.jp2','B02.jp2','B03.jp2','B04.jp2','B05.jp2','B06.jp2','B07.jp2','B08.jp2','B09.jp2','B10.jp2','B11.jp2','B12.jp2','B8A.jp2'};


% resolution of band [1,2,3,... ,12,B8A]
resolutionIdx = [60,10,10,10,20,20,20,10,60,60,20,20,20];

xdiff = (x1-x2);

% make sure image im1 on the left, im2 on the right
if xdiff > 0
    temp = dataPath1;
    dataPath1 = dataPath2;
    dataPath2 = temp;
%     
    [ x1,y1,nrows1,ncol1 ] = readSentinel2MetaXML( [dataPath1,'metadata.xml'] );
%     [ x2,y2,nrows2,ncol2 ] = readSentinel2MetaXML( [dataPath2,'metadata.xml'] );
end
xdiff = abs(xdiff);



if exist([savePath,'\mosaic'], 'file') == 0
    mkdir([savePath,'\mosaic']);
end

%
for i = 1:length(resolutionIdx)
    im_L = imread([dataPath1,fileNames{i}]);
    im_R = imread([dataPath2,fileNames{i}]);
    
%     switch resolutionIdx(i)
%         case 10
%             nb_rows = nrows1(3);    
%             nb_cols = ncols1(3);
%         case 20
%             nb_rows = nrows1(2);
%             nb_cols = ncols1(2);
%         case 60
%             nb_rows = nrows1(1);
%             nb_cols = ncols1(1);
%     end
    xOverlap = xdiff/resolutionIdx(i);
    im = [im_L(:,1:xOverlap),im_R];
            
    writeFile = [savePath,'\mosaic\',fileNames{i}];
    imwrite(im,writeFile);
end

% *************************************************************************
% In UTM reference system
%
% x axis goes from west to east, cooresponds to column number of raster
% image. x coordinate of each district's central line is 500,000 m
% 
% 
% y axis goes from south to north, cooresponds to row number of raster
% image. 
%
%           0   dy
% refmat =  dx  0
%           x   y
%
% *************************************************************************

R = zeros(3,2);
R(1,2) = -10;
R(2,1) = 10;
R(3,1) = x1;
R(3,2) = y1;

end

