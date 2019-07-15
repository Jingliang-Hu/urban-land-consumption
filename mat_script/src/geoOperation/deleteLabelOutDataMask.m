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

% initial output
outCoord = imCoord;
outLabel = label;

if flag == 's1'
    for i = size(outLabel,1):-1:1
        if all(all(mask(outCoord(i,3)-ceil(patchSize/2):outCoord(i,3)+ceil(patchSize/2),outCoord(i,4)-ceil(patchSize/2):outCoord(i,4)+ceil(patchSize/2))))==0
            outCoord(i,:) = [];
            outLabel(i,:) = [];
        end
    end
elseif flag == 's2'
    for i = size(outLabel,1):-1:1
        if all(all(mask(outCoord(i,5)-ceil(patchSize/2):outCoord(i,5)+ceil(patchSize/2),outCoord(i,6)-ceil(patchSize/2):outCoord(i,6)+ceil(patchSize/2))))==0
            outCoord(i,:) = [];
            outLabel(i,:) = [];
        end
    end
end




end

