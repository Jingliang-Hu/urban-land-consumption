function [ outStat ] = localStat_mov( data,hSize,featType )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% initial output
outStat = zeros(size(data));
% get the size of input data
[~,~,dn] = size(data);

% data padding
padData = padarray(data,[hSize,hSize],'symmetric');

% window size
wSize = hSize*2+1;
% conv kernel

% calculate statistics using convolution
% dimensions
for d = 1:dn
    tmpD = padData(:,:,d);
    switch lower(featType)
        case 'mean'           
            tmpM = movmean(movmean(tmpD,wSize,2),wSize,1);
            outStat(:,:,d) = tmpM(hSize+1:end-hSize,hSize+1:end-hSize);
        case 'std'
            tmpS = movingstd2(tmpD,hSize);      
            outStat(:,:,d) = tmpS(hSize+1:end-hSize,hSize+1:end-hSize);
    end
    
end
% tmp = whos;
% mem=memProfile(tmp,'mb')
end
