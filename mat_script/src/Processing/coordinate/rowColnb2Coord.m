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




% *************************************************************************
%
% coordinate information is passed in the reference matrix form. (among
% different functions)
% 
% refmat ('center position' )
% the third row of refmat gives the coordinate of the 'cell center' of
% the starting cell
%
% MapCellReference ('corner position')
% It gives the coordinate information regarding to the grid. 
% (Coordinates of four corners of each cell)

% *************************************************************************



function [ out_coord ] = rowColnb2Coord( rowCol,r_mat )
%This function calculates the pixel location (row and column) of one image
% (whose geo information given by r_mat). This pixel is indicated by the 
% number of row and column (rowCol).  
%
% It returns the coordinate of the pixel center.
%
%   Input:
%       - rowCol                - pixel location in image
%       - r_refmat              - geo-reference matrix of the data
%
%   Output:
%       - out_coord             - coordinate of the pixel center
%
%

out_coord = [r_mat(3,1)+(rowCol(:,2)-1)*r_mat(2,1),r_mat(3,2)+(rowCol(:,1)-1)*r_mat(1,2)];


end