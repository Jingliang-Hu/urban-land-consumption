function [ feat ] = patchPCA( data,win,dim )
%In each feature, each pixel is equipped with all values of local window.
%PCA reduces the number to 20. Then, stacking all the 20 pcs of all
%features together. Finally, apply pca again. take the first pcs with 95%
%variations. 
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
mask = sum(data,3)~=0;
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
    temp = reshape(datatemp(1+win:r+win,1+win:c+win,:),r*c,[]);
    pc{k} = pca_dr(temp(mask(:),:),'criteria',dim);
    
end

feat_data = pca_dr(cat(2,pc{:}),'criteria',dim);
feat = zeros(r*c,size(feat_data,2));
feat(mask(:),:) = feat_data;
feat = reshape(feat',r,c,[]);


end

