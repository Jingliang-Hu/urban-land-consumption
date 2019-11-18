function [ out_label ] = labelTransferRes( label,label_ref,out_ref,out_dataset )
%Because different resolution of polsar and hyperspectral image, and
%coregistration issue, this function identalizes the labeled dataset for
%both data. According to the input label, this function finds out the
%corresponding label in the other dataset (polsar or hyperspectral image)
%
%   Input:
%       - label                 - label mark of one dataset (polsar or hyperspectral image)
%       - label_ref             - reference matrix of input label
%       - out_ref               - reference matrix of output label
%       - out_dataset           - dataset corresponding to out_label (polsar or hyperspectral image)
%                                 providing the raster size information
%
%   Output:
%       - out_label             - label of the other dataset corresponding
%                                 to input label
%
%

labelInd = unique(label);
labelnb = length(labelInd)-1;
out_label = zeros(size(out_dataset(:,:,1)));


for i = 1:labelnb
    [temp_r,temp_c] = find(label == labelInd(i+1));
    
    [ coord_start ] = rowColnb2Coord( [temp_r(1),temp_c(1)],label_ref );
    [ coord_end ] = rowColnb2Coord( [temp_r(end),temp_c(end)],label_ref );
    
    [ ~,p_start ] = coord2RowColnb( coord_start,out_ref );
    [ ~,p_end ] = coord2RowColnb( coord_end,out_ref );
    
    out_label(p_start(1):p_end(1),p_start(2):p_end(2)) = labelInd(i+1);
end


end

