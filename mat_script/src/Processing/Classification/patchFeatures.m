function [ data_out ] = patchFeatures( data,halfPatchWindow )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

patchSize = 2*halfPatchWindow+1;
[r,c,d] = size(data);
data_out = zeros(r,c,patchSize^2*d);

% data = padarray(data,[halfPatchWindow,halfPatchWindow],'symmetric','both');

for i = -halfPatchWindow : halfPatchWindow
    for j = -halfPatchWindow : halfPatchWindow
        ind = (i + halfPatchWindow) * patchSize + j + halfPatchWindow + 1;        
        data_out(:,:,((ind - 1)*d+1):(ind*d)) = circshift(data,[i,j]);        
    end
end




end

