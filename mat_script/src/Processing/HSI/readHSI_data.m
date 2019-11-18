function [ HSI,coord ] = readHSI_data( varargin )
%This function read HSI data from binary file.
%   Input:
%       - var 1         - path to file
%       - var 2         - data type: .dat, .img. .bsq .....
%       - var 3-5       - the target data extent preference
%
%   Output: 
%       - HSI           - hyperspectral data in .mat 

if nargin==0 || nargin>5
    disp('Not enough input');
    return
end

path = varargin{1};
[ dataInfo,~,coord ] = readHSI_hdr( path );

 
if path(end-3)=='.'
    path(end-3:end) = varargin{2};
else
    path = [path,varargin{2}];    
end

% *********************** read HSI parameter ******************************
% [samples;         lines;          bands;      header offset;	
%  file type;       data type;      interleave;	sensor type;	
%  byte order;      map info]
sam = str2double(cell2mat(dataInfo{1}));
lin = str2double(cell2mat(dataInfo{2}));
ban = str2double(cell2mat(dataInfo{3}));
hea = str2double(cell2mat(dataInfo{4}));
fil = cell2mat(dataInfo{5});
dat = str2double(cell2mat(dataInfo{6}));
int = lower(cell2mat(dataInfo{7}));
sen = cell2mat(dataInfo{8});
byt = str2double(cell2mat(dataInfo{9}));
% map = cell2mat(dataInfo{10});
% *************************************************************************

% set the dimension of HSI
size = [lin sam ban];

% set the precision
switch dat
    case 1
        pre = 'int8';
    case 2
        pre = 'int16';
    case 3
        pre = 'int32';
    case 4
        pre = 'float';
    case 12
        pre = 'uint16';
    otherwise
        pre = 'int8';
        fprintf('Precision used to read binary data might not correct, default value int8 was used');
end

% matlab byteorder
switch byt
    case 0
        byteorder = 'ieee-le';
    case 1
        byteorder = 'ieee-be';
    otherwise
        byteorder = 'ieee-le';
        fprintf('byteorder used to read binary data might not correct, default value ieee-le was used');
end

switch nargin
    case 1
        HSI = multibandread(path,size,pre,hea,int,byteorder);
    case 2
        HSI = multibandread(path,size,pre,hea,int,byteorder);
    case 3
        HSI = multibandread(path,size,pre,hea,int,byteorder,varargin{3});
    case 4
        HSI = multibandread(path,size,pre,hea,int,byteorder,varargin{3},varargin{4});
    case 5
        HSI = multibandread(path,size,pre,hea,int,byteorder,varargin{3},varargin{4},varargin{5});
    
end


end

