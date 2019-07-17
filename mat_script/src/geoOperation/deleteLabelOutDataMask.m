function [ outCoord, outLabel ] = deleteLabelOutDataMask(imCoord, label, mask, flag, patchSize)
% The function deleteLabelOutDataMask delete the label and its coordinates, which are located in the gap of data
%       Input:
%               -       imCoord                 - a (N x 6) numpy array
%               -       label                   - code of labels, (N x 1) numpy array. N: number of labels
%               -       mask                    - a (R x C) numpy array of 'True' and 'False'
%                                                       'True' : data available with given patch size,
%                                                       'False': otherwise
%               -       flag                    - flag indicating the input geotiff is SENTINEL-1 data 's1', or SENTINEL-2 data 's2'
%               -       patchSize               - a scale number indicating the size of patch for later use
%       Output:
%               -       outCoord                - a (N x 6) numpy array
%               -       outLabel                - code of labels, (N x 1) numpy array. N: number of labels
if patchSize>0
    halfPatch = (patchSize-1)/2;
elseif patchSize == 0
    halfPatch =0;
else
    disp('patch size should be non-negetive')
end
% a mask indicates the data location
maskTmp = zeros(size(mask),'single');
if flag == 's1'
    idx = sub2ind(size(mask),imCoord(:,3),imCoord(:,4));
elseif flag == 's2'
    idx = sub2ind(size(mask),imCoord(:,5),imCoord(:,6));
end
maskTmp(idx) = 1;

% a data mask indicats those data points which have data cover within given patchsize
for cv_row = -halfPatch : halfPatch
    for cv_col = -halfPatch : halfPatch
        maskTmp = circshift(maskTmp,[cv_row,cv_col]);
        maskTmp = maskTmp & mask;
        maskTmp = circshift(maskTmp,[-cv_row,-cv_col]);
    end
end

% delete those data point which have no data cover within given patchsize
idxDel = maskTmp(idx)==1;
outCoord = imCoord(idxDel,:);
outLabel = label(idxDel,:);

end



%% old version
%if flag == 's1'
%    for i = size(outLabel,1):-1:1
%        if all(all(mask(outCoord(i,3)-ceil(patchSize/2):outCoord(i,3)+ceil(patchSize/2),outCoord(i,4)-ceil(patchSize/2):outCoord(i,4)+ceil(patchSize/2))))==0
%            outCoord(i,:) = [];
%            outLabel(i,:) = [];
%        end
%    end
%elseif flag == 's2'
%    for i = size(outLabel,1):-1:1
%        if all(all(mask(outCoord(i,5)-ceil(patchSize/2):outCoord(i,5)+ceil(patchSize/2),outCoord(i,6)-ceil(patchSize/2):outCoord(i,6)+ceil(patchSize/2))))==0
%            outCoord(i,:) = [];
%            outLabel(i,:) = [];
%        end
%    end
%end


