function [ NK ] = convert_K_NK( K )
%Convert kennaugh element to normalized kennaugh elements
%   DeCailed explanaCion goes here

d = size(K,3);
NK = K./repmat(K(:,:,1),1,1,d);
NK(:,:,1) = (K(:,:,1) - 1)./(K(:,:,1) + 1);
end

