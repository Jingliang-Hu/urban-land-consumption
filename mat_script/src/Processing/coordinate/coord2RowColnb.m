

function [ out_coord,out_pixel ] = coord2RowColnb( coord,r_mat )
%This function calculates the pixel location (row and column) of one image
% (whose geo information given by r_mat). This pixel is indicated by the 
% coordinate 'coord'. The 'coord' is included in the pixel, but not 
% necessarily the center of the pixel. 
%
% It returns the row and column numbers of the pixel and the coordinate of
% the pixel center.
%
%   Input:
%       - coord                 - the coordinate
%       - r_refmat              - geo-reference matrix of the data
%
%   Output:
%       - out_coord             - coordinate of the pixel center
%       - out_pixel             - row and column number of the pixel
%
%

out_pixel = [round((coord(2)-r_mat(3,2))/r_mat(1,2)+1),round((coord(1)-r_mat(3,1))/r_mat(2,1))+1];
out_coord = [round((coord(1)-r_mat(3,1))/r_mat(2,1))*r_mat(2,1)+r_mat(3,1),round((coord(2)-r_mat(3,2))/r_mat(1,2))*r_mat(1,2)+r_mat(3,2)];


end