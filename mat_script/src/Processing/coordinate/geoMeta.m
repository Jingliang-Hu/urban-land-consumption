function [ meta ] = geoMeta( varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%
% meta = 
% 
%   struct with fields:
% 
%             Projection: 'UTM zone 33N'
%             RasterSize: [666 643]
%           XWorldLimits: [360280 424580]
%           YWorldLimits: [5789320 5855920]
%          XLimIntrinsic: [0.5000 643.5000]
%          YLimIntrinsic: [0.5000 666.5000]
%     CellExtentInWorldX: 100
%     CellExtentInWorldY: 100
%       ColumnsStartFrom: 'north'
%          RowsStartFrom: 'west'




info = varargin{1};
n = 2;
while n < nargin
    switch lower(varargin{n})
        case 'format'
            n = n + 1;
            format = varargin{n};        
    end
    n = n + 1;
end

switch lower(format)
    
    case 'tif' % coordinate of geotif aligns at the center of pixel. 
        meta.Projection = info.Projection;
        meta.RasterSize = info.SpatialRef.RasterSize;
        if isprop(info.SpatialRef,'CellExtentInWorldX')
            meta.CellExtentInWorldX = info.SpatialRef.CellExtentInWorldX;
            meta.CellExtentInWorldY = info.SpatialRef.CellExtentInWorldY;        
        elseif isprop(info.SpatialRef,'SampleSpacingInWorldX')
            meta.CellExtentInWorldX = info.SpatialRef.SampleSpacingInWorldX;
            meta.CellExtentInWorldY = info.SpatialRef.SampleSpacingInWorldY;     
        end
        meta.XWorldLimits = info.SpatialRef.XWorldLimits - 0.5 * meta.CellExtentInWorldX;
        meta.YWorldLimits = info.SpatialRef.YWorldLimits - 0.5 * meta.CellExtentInWorldY;
               
        meta.ColumnsStartFrom = info.SpatialRef.ColumnsStartFrom;
        meta.RowsStartFrom = info.SpatialRef.RowsStartFrom;

    case 'tiff'
    case 'geotif'
    case 'goetiff'
    case 'hdr'% sentinel 1 in envi
        temp = strsplit(info.coordinate_system_string,'"');
        meta.Projection = temp{2}(10:end);
        meta.RasterSize = [info.lines,info.samples];
        
        temp = strsplit(info.map_info,',');
        meta.CellExtentInWorldX = str2double(temp{6});
        meta.CellExtentInWorldY = str2double(temp{7});
        
        x11 = str2double(temp{4}) - meta.CellExtentInWorldX * (str2double(temp{2})-1);
        y11 = str2double(temp{5}) + meta.CellExtentInWorldY * (str2double(temp{3})-1);
        meta.XWorldLimits = [x11, x11 + info.samples * meta.CellExtentInWorldX];
        meta.YWorldLimits = [y11 - info.lines * meta.CellExtentInWorldY, y11];
        
        meta.ColumnsStartFrom = 'north';
        meta.RowsStartFrom = 'west';
end

