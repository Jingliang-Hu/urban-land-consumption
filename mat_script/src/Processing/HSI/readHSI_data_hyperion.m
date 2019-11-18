function [ HSI,rgb,R ] = readHSI_data_hyperion( varargin )
%This function read HSI data from binary file.
%   Input:
%       - var 1         - path to file
%       - var 2-4       - the target data extent preference
%
%   Output: 
%       - HSI           - hyperspectral data in .mat 

if nargin==0 || nargin>4
    disp('Not enough input');
    return
end

rgbbnd = {'_B029_L1GST.TIF';'_B020_L1GST.TIF';'_B012_L1GST.TIF'};

path = varargin{1};
files = strsplit(path,'\');


[red,R] = geotiffread([path,'\',files{end},rgbbnd{1}]);
rgb = zeros(size(red,1),size(red,2),3);
rgb(:,:,1) = red; clear red;
[rgb(:,:,2),~] = geotiffread([path,'\',files{end},rgbbnd{2}]);
[rgb(:,:,3),~] = geotiffread([path,'\',files{end},rgbbnd{3}]);
[ rgb ] = sentinel2RGB( rgb );






bndIdx = [8:55,77,56,78,57,79:224]+1e3;
HSI = zeros(size(rgb,1),size(rgb,2),length(bndIdx));

for i = 1:length(bndIdx)
    nbBnd = num2str(bndIdx(i));
    filepath = [path,'\',files{end},'_B',nbBnd(2:end),'_L1GST.TIF'];
    [HSI(:,:,i),~] = geotiffread(filepath);
       
end

% VNIR (8 -- 57) and SWIR (77 -- 224) scaling factors are 40 and 80 respectivly
HSI(:,:,bndIdx < 1060) = HSI(:,:,bndIdx < 1060)./40;
HSI(:,:,bndIdx > 1060) = HSI(:,:,bndIdx > 1060)./80;




end

