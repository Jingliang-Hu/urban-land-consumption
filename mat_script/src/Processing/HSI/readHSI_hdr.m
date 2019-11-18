function [ infoArr,band,coord ] = readHSI_hdr( path,varargin )
%This function read the information from hyperspectral header file
%   Input:
%       - path          - path to header or data file
% 
%   Output:
%       - infoArr       - 10 by 1 cell array stores the information of 
%                         [samples;         lines;          bands;      
%                          header offset;   file type;      data type;  
%                          interleave;      sensor type;    byte order;
%                          map info;]

% read original data and store in tempArr 
if path(end-3)=='.'
    path(end-3:end)='.hdr';
else
    path = [path,'.hdr'];    
end

tempArr = cell(200,1);
fid = fopen(path);
fline = fgets(fid);

i=1;
while ischar(fline)
    tempArr(i) = cellstr(fline);
    fline = fgets(fid);
    i=i+1;
end
fclose(fid);


% extract the nine crucial info and put in infoArr
infoStr = {'samples';'lines';'bands';'header offset';'file type';'data type';'interleave';'sensor type';'byte order';'map info'};
infoArr = cell(10,1);

for j=1:length(infoStr)
    for i=1:20
        if isempty(tempArr{i})
            break;
        end
        if contains(tempArr{i},infoStr{j})
            temp = strsplit(tempArr{i},'= ');
            infoArr{j}=temp(end);
            break;
        end
    end 
end

% extract the wavelength of each band
bandNum = str2double(infoArr{3});
band=zeros(1,bandNum);

i=1;
while ~isempty(tempArr{i})
    if strcmp(tempArr{i},'wavelength = {')
        i=i+1;
        ind=i;
        while ~strcmp(tempArr{i}(end),'}')
            temp = str2double(strsplit(tempArr{i},','));
            col=(length(temp)-1);
            for j = 1:col
                band((i-ind)*col+j)=temp(j);
            end
            i=i+1;
        end
        temp = str2double(strsplit(tempArr{i}(1:end-1),','));
        for j = 1:(length(temp))
            band((i-ind)*col+j)=temp(j);
        end
    end
    i=i+1;
    if i > size(tempArr,1)
        break;
    end
end

% extract the coordinate information (UTM)

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
if isempty(infoArr{10}) % if not geoinformation in the header
    
    coord = 0;
    return
end

temp = strsplit(cell2mat(infoArr{10}),',');
coord = [str2double(cell2mat(temp(4))),str2double(cell2mat(temp(5))),str2double(cell2mat(temp(6))),-str2double(cell2mat(temp(7)))];
r_start = str2double(cell2mat(temp(3)));
c_start = str2double(cell2mat(temp(2)));


coord = [0,coord(4);coord(3),0;coord(1) - (c_start - 1) * coord(3),coord(2) - (r_start - 1) * coord(4)];
% ENVI coordinate typically refers to the location of the upper left cornor
% of each pixel.

r_start = 1;
c_start = 1;
switch nargin
    case 1
        
    case 2
        infoRowCol = varargin(1);
        if strcmp(infoRowCol{1}{1},'Row')&&strcmp(infoRowCol{1}{2},'range')
            r_start = infoRowCol{1}{3}(1);
        end
        if strcmp(infoRowCol{1}{1},'Column')&&strcmp(infoRowCol{1}{2},'range')
            c_start = infoRowCol{1}{3}(1);
        end
        
    case 3
        infoRowCol = varargin(1);
        if strcmp(infoRowCol{1}{1},'Row')&&strcmp(infoRowCol{1}{2},'range')
            r_start = infoRowCol{1}{3}(1);
        end
        if strcmp(infoRowCol{1}{1},'Column')&&strcmp(infoRowCol{1}{2},'range')
            c_start = infoRowCol{1}{3}(1);
        end
        infoRowCol = varargin(2);
        if strcmp(infoRowCol{1}{1},'Row')&&strcmp(infoRowCol{1}{2},'range')
            r_start = infoRowCol{1}{3}(1);
        end
        if strcmp(infoRowCol{1}{1},'Column')&&strcmp(infoRowCol{1}{2},'range')
            c_start = infoRowCol{1}{3}(1);
        end
    otherwise
        disp('number of input is not legal');
        return;
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
coord(3,1) = coord(3,1)+(c_start-1)*coord(2,1);
coord(3,2) = coord(3,2)+(r_start-1)*coord(1,2);


end


