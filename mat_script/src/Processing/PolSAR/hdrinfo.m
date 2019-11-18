function [ size,pre,hea,int,byteorder ] = hdrinfo( path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



[ dataInfo,~,~ ] = readHSI_hdr( path );


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




end

