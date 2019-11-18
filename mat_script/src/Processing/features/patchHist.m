function [ feat ] = patchHist( data,win,bins )
%In each feature, each pixel is represented by a histogram of values within
%a local patch.
%
%   Detailed explanation goes here
%       Input:
%           - data          -- [row,col,bnd]
%           - win           -- half window size
%           - dim           -- number of dimension to reduce
%
%       Output:
%           - feat          -- [row,col,nbOfDim]

[r,c,n] = size(data);
dataPad = padarray(data,[win,win],'symmetric','both');
pc = cell(1,n);
% loop of every feature
for k = 1:n
    datatemp = zeros(size(dataPad));
    % loop of patch
    for i = -win:win
        for j = -win:win
            datatemp(:,:,(i+win)*(2*win+1)+j+win+1) = circshift(dataPad(:,:,k),[i,j]);
        end
    end
    pc{k} = hist(reshape(datatemp(1+win:r+win,1+win:c+win,:),r*c,[])',bins);
    
end


feat = reshape(cat(1,pc{:})',r,c,[]);


end

