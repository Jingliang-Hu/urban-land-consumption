function [ rgbIm,ref ] = readHyperionRGB( path )
%Hyperion RGB image is is displayed as an RGB (29:20:11) band combination. 
%Each band is linearly stretched between the 1% and 97% histogram values.
%   Detailed explanation goes here


[im(:,:,1),~] = (geotiffread([path,'\EO1H1480472016328110PZ_B029_L1GST.tif']));
[im(:,:,2),~] = (geotiffread([path,'\EO1H1480472016328110PZ_B020_L1GST.tif']));
[im(:,:,3),ref] = (geotiffread([path,'\EO1H1480472016328110PZ_B011_L1GST.tif']));
ref = mapRasterReferenceToRefmat( ref );
im = double(im);

mask = im(:,:,1) ~= 0;

rgbIm = zeros(size(im));

for i = 1:3
    temp = im(:,:,i);
    temp = temp(mask);
    endvalue = quantile(temp,[0.01,0.97]);
    temp(temp < endvalue(1)) = endvalue(1);
    temp(temp > endvalue(2)) = endvalue(2);
    temp = (temp - endvalue(1))./(endvalue(2)-endvalue(1));
    bnd = zeros(size(im,1),size(im,2));
    bnd(mask) = temp;
    rgbIm(:,:,i) = bnd;
end






end

