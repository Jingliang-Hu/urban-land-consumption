function [ meta ] = geoMeta_v1( varargin )
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
        meta.XWorldLimits = info.SpatialRef.XWorldLimits;
        meta.YWorldLimits = info.SpatialRef.YWorldLimits;
               
        meta.ColumnsStartFrom = info.SpatialRef.ColumnsStartFrom;
        meta.RowsStartFrom = info.SpatialRef.RowsStartFrom;

    case 'tiff'
    case 'geotif'
    case 'goetiff'
    case 'hdr'
end

