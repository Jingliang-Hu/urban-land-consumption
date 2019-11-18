function [ rgb ] = sentinel2RGB( rgb )
%This function preprocess sentinel 2 into rgb. The final feature is
%scaled into [0,1]. 0.5% of lower boundary and high boundary are masked out
%due to the extreme low or high sar value will squaze the feature values.
%   Detailed explanation goes here

% edge elimination percentage 0.5%
p = 0.02;
rgb = double(rgb);

for i = 1:size(rgb,3)
    temp = rgb(:,:,i);

    lowBoundary = quantile(temp(:),p);
    highBoundary = quantile(temp(:),1-p);

    temp(temp < lowBoundary) = lowBoundary;
    temp(temp > highBoundary) = highBoundary;

    temp = (temp - lowBoundary)/(highBoundary - lowBoundary);
    rgb(:,:,i) = temp;

end

figure,imshow(rgb);
end

