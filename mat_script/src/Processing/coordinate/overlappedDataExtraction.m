function [ dataA_ol,refmatA_ol,dataB_ol,refmatB_ol ] = overlappedDataExtraction( dataA,refmatA,dataB,refmatB )
%This function extracts the overlapped area of the two input data according
%to their geo-reference information.
%
%   Input:
%       - polsar                - input polsar data
%       - pol_refmat            - polsar data reference matrix
%       - hsi                   - input hyperspectral data
%       - hsi_refmat            - hyperspectral data referenc matrix
%
%   Output:
%       - polsar_ol             - extracted overlapped polsar data
%       - polsar_refmat_ol      - extracted polsar reference matrix
%       - hsi_ol                - extracted overlapped hyperspectral data
%       - hsi_refmat_ol         - extracted hyperspectral reference matrix


if refmatA(1,2)>=0 || refmatA(2,1)<=0 || refmatB(1,2)>=0 || refmatB(2,1)<=0
    disp('coordinate info should starts from northwest corner');
    return;
end

[ start_A,end_A,start_B,end_B ] = dataExtent( dataA,refmatA,dataB,refmatB );
% 
% 
% [r_pol,c_pol,~] = size(polsar);
% [r_hsi,c_hsi,~] = size(hsi);
% 
% % coordinate of northwest corners of polsar and hsi
% start_pol = pol_refmat(3,:);
% start_hsi = hsi_refmat(3,:);
% 
% % coordinate of southeast corners of polsar and hsi
% end_pol(1) = pol_refmat(3,1) + (c_pol - 1) * pol_refmat(2,1);
% end_pol(2) = pol_refmat(3,2) + (r_pol - 1) * pol_refmat(1,2);
% 
% end_hsi(1) = hsi_refmat(3,1) + (c_hsi - 1) * hsi_refmat(2,1);
% end_hsi(2) = hsi_refmat(3,2) + (r_hsi - 1) * hsi_refmat(1,2);

% coordinate of northwest corner of overlapped area
if start_A(1)>start_B(1)
    start_temp(1) = start_A(1);
else
    start_temp(1) = start_B(1);
end

if start_A(2)>start_B(2)
    start_temp(2) = start_B(2);
else
    start_temp(2) = start_A(2);
end

% coordinate of southeast corner of overlapped area
if end_A(1)>end_B(1)
    end_temp(1) = end_B(1);
else
    end_temp(1) = end_A(1);
end

if end_A(2)>end_B(2)
    end_temp(2) = end_A(2);
else
    end_temp(2) = end_B(2);
end

% extract the image coordinate polsar data and the refmat
refmatA_ol = refmatA;
[refmatA_ol(3,:),A_start_pixel] = coord2RowColnb( start_temp,refmatA );
[~,A_end_pixel] = coord2RowColnb( end_temp,refmatA );



% extract the image coordinate hsi data and the refmat
refmatB_ol = refmatB;
[refmatB_ol(3,:),B_start_pixel] = coord2RowColnb( start_temp,refmatB );
[~,B_end_pixel] = coord2RowColnb( end_temp,refmatB );


if A_end_pixel(1)>size(dataA,1)
    A_end_pixel(1) = size(dataA,1);
end
if A_end_pixel(2)>size(dataA,2)
    A_end_pixel(2) = size(dataA,2);
end
if B_end_pixel(1)>size(dataB,1)
    B_end_pixel(1) = size(dataB,1);
end
if B_end_pixel(2)>size(dataB,2)
    B_end_pixel(2) = size(dataB,2);
end


% dealing the southeast image index when resolution is different
if (abs(refmatB(1,2)/refmatA(1,2))) < 1 && abs(refmatB(2,1)/refmatA(2,1)) < 1
%     dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1)+round(abs(refmatB(1,2)/refmatA(1,2))),A_start_pixel(2):A_end_pixel(2)+round(abs(refmatB(2,1)/refmatA(2,1))),:);
%     dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1)+round(abs(refmatA(1,2)/refmatB(1,2)))-1,B_start_pixel(2):B_end_pixel(2)+round(abs(refmatA(2,1)/refmatB(2,1)))-1,:);
%     dataB_ol = dataB;
    dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1),A_start_pixel(2):A_end_pixel(2),:);
    dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1),B_start_pixel(2):B_end_pixel(2),:);

elseif (abs(refmatB(1,2)/refmatA(1,2))) < 1 && abs(refmatB(2,1)/refmatA(2,1)) > 1
    dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1)+round(abs(refmatB(1,2)/refmatA(1,2))),A_start_pixel(2):A_end_pixel(2)+round(abs(refmatB(2,1)/refmatA(2,1)))-1,:);
    dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1)+round(abs(refmatA(1,2)/refmatB(1,2)))-1,B_start_pixel(2):B_end_pixel(2)+round(abs(refmatA(2,1)/refmatB(2,1))),:);
elseif (abs(refmatB(1,2)/refmatA(1,2))) > 1 && abs(refmatB(2,1)/refmatA(2,1)) < 1
    dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1)+round(abs(refmatB(1,2)/refmatA(1,2)))-1,A_start_pixel(2):A_end_pixel(2)+round(abs(refmatB(2,1)/refmatA(2,1))),:);
    dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1)+round(abs(refmatA(1,2)/refmatB(1,2))),B_start_pixel(2):B_end_pixel(2)+round(abs(refmatA(2,1)/refmatB(2,1)))-1,:);
elseif (abs(refmatB(1,2)/refmatA(1,2))) > 1 && abs(refmatB(2,1)/refmatA(2,1)) > 1
%     dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1)+round(abs(refmatB(1,2)/refmatA(1,2)))-1,A_start_pixel(2):A_end_pixel(2)+round(abs(refmatB(2,1)/refmatA(2,1)))-1,:);
%     dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1)+round(abs(refmatA(1,2)/refmatB(1,2))),B_start_pixel(2):B_end_pixel(2)+round(abs(refmatA(2,1)/refmatB(2,1))),:);
    dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1),A_start_pixel(2):A_end_pixel(2),:);
    dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1),B_start_pixel(2):B_end_pixel(2),:);
elseif (abs(refmatB(1,2)/refmatA(1,2))) == 1 && abs(refmatB(2,1)/refmatA(2,1)) == 1
%     dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1)+round(abs(refmatB(1,2)/refmatA(1,2))),A_start_pixel(2):A_end_pixel(2)+round(abs(refmatB(2,1)/refmatA(2,1))),:);
%     dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1)+round(abs(refmatA(1,2)/refmatB(1,2))),B_start_pixel(2):B_end_pixel(2)+round(abs(refmatA(2,1)/refmatB(2,1))),:);
    dataA_ol = dataA(A_start_pixel(1):A_end_pixel(1),A_start_pixel(2):A_end_pixel(2),:);
    dataB_ol = dataB(B_start_pixel(1):B_end_pixel(1),B_start_pixel(2):B_end_pixel(2),:);
%     dataA_ol = 0;
end
end



















