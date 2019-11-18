%
%           0   dy
% refmat =  dx  0
%           x   y
%
% refmat ('center position' )
% the third row of refmat gives the coordinate of the 'cell center' of
% the starting cell
%
% MapCellReference ('corner position')
% It gives the coordinate information regarding to the grid. 
% (Coordinates of four corners of each cell)



function [ subData,subMat ] = subSetPolSAR( data,mat,rp,cp,rl,cl )
%This function read indicated subset PolSAR data and the georeference
%information of the subset.
%   Input
%       - data          -- Polsar data in .mat formation
%       - mat           -- refmatrix of the data
%       - rp            -- row number of subset start point
%       - cp            -- column number of subset start point
%       - rl            -- row length of subset
%       - cl            -- column length of subset
%
%   Output
%       - subData       -- indicated polsar subset
%       - subMat        -- refmatrix of the subset


if mat(1,2)>=0 || mat(2,1)<=0
    disp('coordinate info should starts from northwest corner');
    return;
end

subData = data(rp:rp+rl,cp:cp+cl,:);
subMat = mat;
subMat(3,1) = mat(3,1) + (cp - 1) * mat(2,1);
subMat(3,2) = mat(3,2) + (rp - 1) * mat(1,2);
end

