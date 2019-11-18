function [ dist ] = polsar_dist( C_point_cloud,flag )
%This function calculates the distance of covariance matrices based on the 
%user's choice.
%
%   Input:
%       - C_point_cloud         -- polsar data  
%       - flag                  -- choose the distance measurement
%
%   Output:
%       - dist                  -- distance measures
% 
% -------------------------------------------------------------------------
%   polsar data format:
%       [nb_row by nb_column by nb_chl] or [nb_pixel by 1 by nb_chl]
%   
%   flag:
%       - 1:                    -- Pretest
%       - 2:                    -- nonlocal
%       - 3:                    -- symmetric revised wishart distance
%       - 4:                    -- log-Euclidean Distrance
%       - 5:                    -- SPAN distance
%       - 6:                    -- Bartlett distance
%       - 7:                    -- Euclidean distance
%
%     Pretest:
%       Chen et al., Nonlocal Filtering for Polarimetric SAR Data: A Pretest Approach 
% 
%     nonlocal:
%       Deledalle et al., Exploiting Patch Similarity for SAR Image Processing: The nonlocal paradigm
% 
%     symmetric revised wishart distance:
%       Anfinsen et al., "SPECTRAL CLUSTERING OF POLARIMETRIC SAR DATA WITH WISHART-DERIVED DISTANCE MEASURES"
% 
%     log-Euclidean Distrance:
%       Arsigny et al., "Log-Euclidean Metrics for Fast and Simple Calculus on Diffusion Tensors"
% 
%     SPAN distance:
% 
%     Bartlett distance:
%       Kersten et al., Unsupervised classication of polarimetric synthetic aperture radar images using fuzzy clustering and EM clustering
%
%
%
%
%
% -------------------------------------------------------------------------



[r1,c1,d1] = size(C_point_cloud);

if d1 == 1
    C = permute(C_point_cloud,[1,3,2]);
    q = sqrt(c1);
else
    C = C_point_cloud;
    q = sqrt(d1);
end

dist = zeros(r1,r1);

L=9;



switch flag
    case 1      
        % Chen et al., Nonlocal Filtering for Polarimetric SAR Data: A Pretest Approach     
        for i = 1:r1
            C_1 = repmat(C(i,:,:),r1,1,1);
            dist(i+1:end,i) = -L*(2*q*log(2)+log(CDet(C_1(i+1:end,:,:)))+log(CDet(C(i+1:end,:,:)))-2*log(CDet(C_1(i+1:end,:,:)+C(i+1:end,:,:)))); 
        end
    case 2
        % Deledalle et al., Exploiting Patch Similarity for SAR Image Processing: The nonlocal paradigm
        for i = 1:r1
            C_1 = repmat(C(i,:,:),r1,1,1);
            dist(i:end,i) = L*(2*log(CDet(C_1(i:end,:,:)+C(i:end,:,:)))-2*log(2)-log(CDet(C_1(i:end,:,:)))-log(CDet(C(i:end,:,:)))); 
        end
    case 3
        % symmetric revised wishart distance
        % Anfinsen et al., "SPECTRAL CLUSTERING OF POLARIMETRIC SAR DATA WITH WISHART-DERIVED DISTANCE MEASURES"
        for i = 1:r1
            % fast version: calculate the lower diagnal matrix
            [ dist(i+1:end,i) ] = symmetricRevisedWishartDistance( C(i,:,:),C(i+1:end,:,:));
        end
        % slow version: calculate the whole matrix
        % [ dist(:,i) ] = symmetricRevisedWishartDistance( C(i,:,:),C );

    case 4
        % log-Euclidean Distrance
        % Arsigny et al., "Log-Euclidean Metrics for Fast and Simple Calculus on Diffusion Tensors"
        for i = 1:r1
            % fast version: calculate the lower diagnal matrix
            [ dist(i+1:end,i) ] = logEuclideanDistance( C(i,:,:),C(i+1:end,:,:));
        end
        % slow version: calculate the whole matrix
        % [ dist(:,i) ] = logEuclideanDistance( C(i,:,:),C );
    case 5
        % SPAN distance
        for i = 1:r1
            C_1 = repmat(C(i,:,:),r1,1,1);
            dist(i+1:end,i) = sum((C_1(i+1:end,:,1:3)-C(i+1:end,:,1:3)).^2,3);
        end

    case 6
        % Bartlett distance
        % Kersten et al., Unsupervised classication of polarimetric synthetic aperture radar images using fuzzy clustering and EM clustering
        for i = 1:r1
            C_1 = repmat(C(i,:,:),r1,1,1);
            dist(i:end,i) = 2*log(CDet(C_1(i:end,:,:)+C(i:end,:,:)))-log(CDet(C_1(i:end,:,:)))-log(CDet(C(i:end,:,:))); 
        end

    case 7
        % Euclidian distance
        for i = 1:r1
            C_1 = repmat(C(i,:,:),r1,1,1);
            dist(i:end,i) = sum((C_1(i:end,:,:) - C(i:end,:,:)).^2,3);
        end
    otherwise
        % Bartlett distance
        % Kersten et al., Unsupervised classication of polarimetric synthetic aperture radar images using fuzzy clustering and EM clustering
        for i = 1:r1
            C_1 = repmat(C(i,:,:),r1,1,1);
            dist(i:end,i) = 2*log(CDet(C_1(i:end,:,:)+C(i:end,:,:)))-log(CDet(C_1(i:end,:,:)))-log(CDet(C(i:end,:,:))); 
        end

end








end

