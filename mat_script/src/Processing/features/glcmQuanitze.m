% this script prepare the data set for extracting glcm features using the
% software PolSARpro. This script linearly quantizes the image values into
% 32 levels in order to avoid NaN response from PolSARpro

%% read polsar
load('D:\Matlab\Data\Berlin\sentinel1\C2_nlsar_exp\sentinel1_berlin_C.mat');polsar = C;


[ K ] = convert_C2_K_hv_vv( C );
[ NK ] = convert_K_NK( K );


%% set im as the feature image
bnd = 2;

% im = polsar(:,:,bnd);
im = NK(:,:,bnd);

%% quantizing image
numlevel = 32;
levels = min(im(:)):range(im(:))/(numlevel-1):max(im(:));
quan_im = imquantize(im,levels);



%% set value 

NK(:,:,bnd) = im;


%% save
matdata = NK;
path = 'D:\Matlab\Data\Berlin\sentinel1\NK_nlsar_exp\C2';
Mat2PolSARpro( matdata,path );
