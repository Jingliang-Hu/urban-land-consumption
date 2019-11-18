function [ lcz_feature_persishomology, lcz_ref ] = lcz_feature_PH( feature,ref,measure )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load_javaplex_2
api.Plex4.createExplicitSimplexStream()
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
% the persistent homology feature records the 20 most persistent H0; the 5
% most persistent H1; the betti number of H0,H1 and H2;
% [ BettiNumberH012, TheMergeDistanceOf20MostPersitentH0,
%   TheStartDistanceOf5MostPersistentH1, TheEndDistanceOf5MostPersistentH1,
%   TheLengthOf5MostPersistentH1 ]
% in total vector length: 3 + 20 + 5 + 5 + 5 = 38
nb_bettiDim = 3;
nb_h0 = 10;
nb_h1 = 2;



lcz_feature_persishomology = zeros(max(grid_lcz_r),max(grid_lcz_c),nb_bettiDim + nb_h0 + 3 * nb_h1);

% organize features into new grid
feature = feature(1:r,1:c,:);

progress = floor(0:max(grid_lcz_r)/10: max(grid_lcz_r));


num_divisions = 500;
max_dimension = 3;
max_filtration_value = 2;

switch measure
    case 1 % polsar distance
        
        for i = 1 : max(grid_lcz_r)

            for j = 1: max(grid_lcz_c)
                
                % pairwise distance matrix; measure polarimetric difference
                temp = feature(grid_lcz_r==i,grid_lcz_c == j,:);
                c = reshape(temp,[],d);
                [ dist ] = polsar_dist( c,2 );
                dist = dist + tril(dist,-1)' - dist(1,1);
                dist(eye(size(dist))==1) = 0;
                
                % persistent homology calculation using javaplex
                
                m_space = metric.impl.ExplicitMetricSpace(dist);
                stream = api.Plex4.createVietorisRipsStream(m_space, max_dimension,max_filtration_value, num_divisions);
                persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);
                intervals = persistence.computeIntervals(stream);

                % H0
                ph = homology.barcodes.BarcodeUtility.getEndpoints(intervals, 0, false);
                betti = size(ph,1);
                lcz_feature_persishomology(i,j,1) = betti;
                if (betti > nb_h0)
                    betti = nb_h0;
                    lcz_feature_persishomology(i,j,4:3+betti) = ph(2:betti+1,2);
                elseif betti ~= 0
                    lcz_feature_persishomology(i,j,4:2+betti) = ph(2:betti,2);
                end

                
                %H1
                ph = homology.barcodes.BarcodeUtility.getEndpoints(intervals, 1, false);
                betti = size(ph,1);
                lcz_feature_persishomology(i,j,2) = betti;
                if (betti > nb_h1)
                    betti = nb_h1;
                    lcz_feature_persishomology(i,j,4+nb_h0        :3+nb_h0+betti) = ph(1:betti,1);
                    lcz_feature_persishomology(i,j,4+nb_h0+  nb_h1:3+nb_h0+  nb_h1+betti) = ph(1:betti,2);
                    lcz_feature_persishomology(i,j,4+nb_h0+2*nb_h1:3+nb_h0+2*nb_h1+betti) = ph(1:betti,2) - ph(1:betti,1);
                elseif betti ~= 0
                    lcz_feature_persishomology(i,j,4+nb_h0        :3+nb_h0+betti) = ph(1:betti,1);
                    lcz_feature_persishomology(i,j,4+nb_h0+  nb_h1:3+nb_h0+  nb_h1+betti) = ph(1:betti,2);
                    lcz_feature_persishomology(i,j,4+nb_h0+2*nb_h1:3+nb_h0+2*nb_h1+betti) = ph(1:betti,2) - ph(1:betti,1);
                end
                
                
                %H2
                ph = homology.barcodes.BarcodeUtility.getEndpoints(intervals, 2, false);
                betti = size(ph,1);
                lcz_feature_persishomology(i,j,3) = betti;
                
                
            end

            % to show the progress
            if sum(i==progress)==1
                disp(['----- Histogram Processing : ', num2str((find(progress==i)-1)*10),'%  of the ',num2str(chl),' channel done (total ',num2str(d),' channels) -----']);
            end
            
        end
        lcz_feature_persishomology (lcz_feature_persishomology == Inf) = max_filtration_value;
        
        
        
    case 2 % euclidean distance (tbc)
end

save('sentinel1_mumbai.mat','lcz_feature_persishomology','-append');



end

