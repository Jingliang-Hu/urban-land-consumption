function [ refmat ] = mapRasterReferenceToRefmat( R )
%This function converts geoRasterReference to a refmat
%   Input:
%       - R         -- geoRsterReference
%   
%   Output:
%       - refmat    -- reference matrix
%

% [x11 + (col-1) * dx, y11 + (row-1) * dy] = pix2map(R, row, col)


if isprop(R,'CellExtentInWorldX')
    x1 = R.XWorldLimits(1);
    dx = R.CellExtentInWorldX;
    if strcmp(R.ColumnsStartFrom,'east')
        x1 = R.XWorldLimits(2);
        dx = -R.CellExtentInWorldX;
    end
    y1 = R.YWorldLimits(2);
    dy = -R.CellExtentInWorldY;
    if strcmp(R.ColumnsStartFrom,'south')
        y1 = R.YWorldLimits(1);
        dy = R.CellExtentInWorldY;
    end
else
    x1 = R.XWorldLimits(1);
    dx = R.SampleSpacingInWorldX;
    if strcmp(R.ColumnsStartFrom,'east')
        x1 = R.XWorldLimits(2);
        dx = -R.SampleSpacingInWorldX;
    end
    y1 = R.YWorldLimits(2);
    dy = -R.SampleSpacingInWorldY;
    if strcmp(R.ColumnsStartFrom,'south')
        y1 = R.YWorldLimits(1);
        dy = R.SampleSpacingInWorldY;
    end
end


refmat = makerefmat(x1,y1, dx, dy);

end

