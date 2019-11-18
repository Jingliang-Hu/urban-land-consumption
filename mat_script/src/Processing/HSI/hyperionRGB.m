function [ rgbIm ] = hyperionRGB( varargin )
%Hyperion RGB image is is displayed as an RGB (29:20:11) band combination. 
%Each band is linearly stretched between the 1% and 97% histogram values.
%   Detailed explanation goes here

HSI = varargin{1};
if nargin == 2
    d = varargin{2};
else
    [~,~,dn] = size(HSI);
    d = num2str(dn);
end

switch d
    case '167'
        im(:,:,1) = HSI(:,:,22);
        im(:,:,2) = HSI(:,:,13);
        im(:,:,3) = HSI(:,:,4);
    case '242'
        im(:,:,1) = HSI(:,:,29);
        im(:,:,2) = HSI(:,:,20);
        im(:,:,3) = HSI(:,:,11);
    otherwise
        rgbIm = 0;
        disp('data not right');
        return;
end


mask = sum(im,3) ~= 0;

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

figure,imshow(rgbIm);




end

