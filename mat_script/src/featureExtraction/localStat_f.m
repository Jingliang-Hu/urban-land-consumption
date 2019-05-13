function [ outStat ] = localStat_f( data,hSize,featType )
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

% calculate statistics using sliding window, paralell computing on
% dimensions
for d = 1:dn
    tempD = padData(:,:,d);
    temp = zeros(size(tempD,1),size(tempD,2),wSize*wSize);
    for r = -hSize:hSize
        for c = -hSize:hSize
            temp(:,:,(r+hSize)*wSize+c+hSize+1) = circshift(tempD,[r,c]);
        end
    end


   switch lower(featType)
       case 'std'
           outStat(:,:,d) = std(temp(hSize+1:end-hSize,hSize+1:end-hSize,:),[],3);
       case 'mean'           
           outStat(:,:,d) = mean(temp(hSize+1:end-hSize,hSize+1:end-hSize,:),3);
   end
    
end

tmp = whos;
mem=memProfile(tmp,'mb')

end

