function [ feature ] = sarfeaturedb( feature,mask )
%This function preprocess polsar features into db. The final feature is
%scaled into [0,1]. 0.5% of lower boundary and high boundary are masked out
%due to the extreme low or high sar value will squaze the feature values.
%   Detailed explanation goes here

% edge elimination percentage 0.5%



temp = feature(mask);
temp = 10 * log10(temp);

p = 0.05;
lowBoundary = quantile(temp(:),p);
highBoundary = quantile(temp(:),1-p);


% lowBoundary = min(temp(temp~=-Inf));
% highBoundary = max(temp(:));

temp(temp < lowBoundary) = lowBoundary;
temp(temp > highBoundary) = highBoundary;

temp = (temp - lowBoundary)/(highBoundary - lowBoundary);
feature(mask) = temp;
feature(~mask) = 0;


end

