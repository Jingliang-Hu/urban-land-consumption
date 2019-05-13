function [ outStat ] = localStat_cov( data,hSize,featType )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% initial output
outStat = zeros(size(data));
% get the size of input data
[rw,cl,dn] = size(data);

% data padding
padData = padarray(data,[hSize,hSize],'symmetric');

% window size
wSize = hSize*2+1;
% conv kernel
ker = ones(wSize);

% calculate statistics using convolution
% dimensions
for d = 1:dn
    tmpD = padData(:,:,d);
    switch lower(featType)
        case 'mean'           
            tmpM = conv2(tmpD,ker)./(wSize^2);
            outStat(:,:,d) = tmpM(wSize:end-wSize+1,wSize:end-wSize+1);
        case 'std'
            %
    end
    
end

tmp = whos;
mem=memProfile(tmp,'mb')


end

