function [ lcz_feature_persishomology, lcz_ref ] = lcz_feature_simplifiedPH( feature,ref,measure )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% *************************************************************************
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

% load_javaplex;

% local climate zone resolution 100m
lcz_reso = 100;

% reference matrix for 100m grid
lcz_ref = ref;
lcz_ref(1:2,:) = lcz_reso * sign(lcz_ref(1:2,:));

% initial the output grid
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

% initial the persistent homology feature
nb_pix = ratio_reso_y_floor*ratio_reso_x_floor;
lcz_feature_persishomology = zeros(max(grid_lcz_r),max(grid_lcz_c),(nb_pix*nb_pix-nb_pix)/2);

% organize features into new grid
feature = feature(1:r,1:c,:);

progress = floor(0:max(grid_lcz_r)/10: max(grid_lcz_r));




switch measure
    case 1 % polsar distance
        
        for i = 1 : max(grid_lcz_r)

            for j = 1: max(grid_lcz_c)
                
                % pairwise distance matrix; measure polarimetric difference
                
                temp = feature(grid_lcz_r==i,grid_lcz_c == j,:);
                c = reshape(temp,[],d);
                [ dist ] = polsar_dist( c,2 );
                dist = tril(dist,-1);
                dist(dist == 0) = [];
                lcz_feature_persishomology(i,j,:) = sort(dist);
                
                
            end

            % to show the progress
            if sum(i==progress)==1
                disp(['----- Topology Processing : ', num2str((find(progress==i)-1)*10),'% done -----']);
            end
            
        end
        
        
        
    case 2 % euclidean distance (tbc)
end





end

