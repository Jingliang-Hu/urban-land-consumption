function [ lcz_feature, lcz_ref ] = lcz_feature( feature,ref,method )
%This function organise the original features for the local climate zone
%classification. It returns the classification features in the resolution
%of 100 meter which is standard for lcz. The input feature should have
%higher rsolution than 100 meter. The organization based on user's option:
% 1) method == 1: 'accumulation', one cell of the output feature has a
%vector containing all the pixel values it covers geographically and from
%all channels; 
% 2) method == 2: down sampling, bicubic interpolation.
% 3) method == 3: 'statistically', one cell of the output
%feature has a vector containing the mean, the gaussion kernel mean and the
%variance of the pixel values it covers geographically and from all
%channels.
% 
%
%
%   Input:
%       - feature           -- features of original data (polsar, hsi ...)
%       - ref               -- reference matrix of original data
%       - method            -- 1 or 2; way of organizing data
% 
%   Output:
%       - lcz_feature       -- features for local climate zone app
%       - lcz_ref           -- reference matrix of output data
% 
% 
% -------------------------------------------------------------------------
% Description:
% 
% 
% In UTM reference system
%
% x axis goes from west to east, cooresponds to column number of raster
% image. x coordinate of each district's central line is 500,000 m
% 
% 
% y axis goes from south to north, cooresponds to row number of raster
% image. 
%
%           0   dy
% refmat =  dx  0
%           x   y
%
% *************************************************************************

% local climate zone resolution 100m
lcz_reso = 100;

% reference matrix for 100m grid
lcz_ref = ref;
lcz_ref(1:2,:) = lcz_reso * sign(lcz_ref(1:2,:));

% initial the feature data based on resolution...
ratio_reso_x = lcz_reso / abs(ref(2,1));
ratio_reso_y = lcz_reso / abs(ref(1,2));
ratio_reso_y_floor = floor(ratio_reso_y);
ratio_reso_x_floor = floor(ratio_reso_x);

[r,c,d] = size(feature);

r = floor(r/ratio_reso_y_floor)*ratio_reso_y_floor;
c = floor(c/ratio_reso_x_floor)*ratio_reso_x_floor;
grid_r = 1 : r;
grid_c = 1 : c;

grid_lcz_r = ceil(grid_r ./ ratio_reso_y_floor);
grid_lcz_c = ceil(grid_c ./ ratio_reso_x_floor);



% organize features into new grid
feature = feature(1:r,1:c,:);
[idx_c,idx_r] = meshgrid(grid_lcz_c,grid_lcz_r);


progress = floor(0:max(grid_lcz_r)/10: max(grid_lcz_r));

switch method
    case 1
        
        lcz_feature = zeros(max(grid_lcz_r),max(grid_lcz_c),d*ratio_reso_y_floor*ratio_reso_x_floor);
        
        
            for i = 1 : max(grid_lcz_r)

                for j = 1: max(grid_lcz_c)

                    idx = (idx_r == i) & (idx_c == j);
                    lcz_feature(i,j,:) = feature(repmat(idx,1,1,d));
                    
                end

                % to show the progress
                if sum(i==progress)==1
                    disp(['----- Feature Overlap Processing : ', num2str((find(progress==i)-1)*10),'% done -----']);
                end
            end
        
        
    case 2
        lcz_feature = imresize(feature,[max(grid_lcz_r),max(grid_lcz_c)]);
        
        
    case 3 % to be constructed
end





end

