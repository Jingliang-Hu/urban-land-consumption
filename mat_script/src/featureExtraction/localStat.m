function [ outStat ] = localStat( data,hSize,featType )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% initial output
outStat = zeros(size(data));
% get the size of input data
[rw,cl,dn] = size(data);
% set number of cores for parallel computing
nbCore = dn;
if nbCore > 10
    nbCore = 10;
end
maxNumCompThreads(nbCore)

% data padding
padData = padarray(data,[hSize,hSize],'symmetric');

% window size
wSize = hSize*2+1;

% calculate statistics using sliding window, paralell computing on
% dimensions
parfor d = 1:dn
    tempD = padData(:,:,d);
    for r = 1:rw
        for c = 1:cl
            temp = tempD(r:r+wSize-1,c:c+wSize-1);
            switch lower(featType)
                case 'std'
                    outStat(r,c,d) = std(temp(:));
                case 'mean'           
                    outStat(r,c,d) = mean(temp(:));                    
            end
        end
    end
    
end




end

