function [ feature ] = sarfeaturemask( feature,mask )
%This function preprocess polsar features with given mask. The final feature is
%scaled into [0,1]. 0.5% of lower boundary and high boundary are masked out
%due to the extreme low or high sar value will squaze the feature values.
%   Detailed explanation goes here

% edge elimination percentage 0.5%
p = 0.005;

d = size(feature,3);

for i = 1:d
    chl = feature(:,:,i);
    
    temp = chl(mask);

    lowBoundary = quantile(temp(:),p);
    highBoundary = quantile(temp(:),1-p);

    temp(temp < lowBoundary) = lowBoundary;
    temp(temp > highBoundary) = highBoundary;

    temp = (temp - lowBoundary)/(highBoundary - lowBoundary);
    chl(mask) = temp;
    chl(~mask) = 0;
    
    feature(:,:,i) = chl;
end

end

