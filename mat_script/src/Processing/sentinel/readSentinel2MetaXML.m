function [ x,y,nrows,ncols ] = readSentinel2MetaXML( xmlpath )
%This function read the metadata.xml of sentinel 2 data set. It returns the
%x & y coordinates of the starting point and the number of pixels in row
%and column
%   Detailed explanation goes here
%   Input:
%       - xmlpath           -- a string of directory to the xml file
% 
%   Output:
%       - x                 -- the x coordinate of starting point
%       - y                 -- the y coordinate of starting point
%       - nrows             -- the number of pixels in row for 60m, 20m,10m resolutions respectively
%       - ncols             -- the number of pixels in column for 60m, 20m,10m resolutions respectively


% read the xml file
metaXML = xmlread(xmlpath);

% extract the x coordinate
ulx = metaXML.getElementsByTagName('ULX');
ulx = getChildNodes(ulx.item(0));
x = char(ulx.item(0).toString());
x = strsplit(x,' ');
x = strsplit(x{2},']');
x = str2double(x{1});


% extract the y coordinate
uly = metaXML.getElementsByTagName('ULY');
uly = getChildNodes(uly.item(0));
y = char(uly.item(0).toString());
y = strsplit(y,' ');
y = strsplit(y{2},']');
y = str2double(y{1});




% extract the number of pixels in row and column
nrows = zeros(1,3);
ncols = zeros(1,3);


nbRow = metaXML.getElementsByTagName('NROWS');
nbCol = metaXML.getElementsByTagName('NCOLS');


for i = 0:nbRow.getLength-1
    nbR = getChildNodes(nbRow.item(i));
    t = char(nbR.item(0).toString());
    t = strsplit(t,' ');
    t = strsplit(t{2},']');
    nrows(i+1) = str2double(t{1});
    
    nbC = getChildNodes(nbCol.item(i));
    t = char(nbC.item(0).toString());
    t = strsplit(t,' ');
    t = strsplit(t{2},']');
    ncols(i+1) = str2double(t{1});
    
end


nrows = sort(nrows);
ncols = sort(ncols);




end

