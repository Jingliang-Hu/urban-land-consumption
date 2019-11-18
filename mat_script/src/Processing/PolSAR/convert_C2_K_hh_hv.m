function [ K ] = convert_C2_K_hh_hv( C )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(C);

K = zeros(rw,cl,4);

K(:,:,1) = C(:,:,1) + C(:,:,2);
K(:,:,2) = C(:,:,1) - C(:,:,2);
K(:,:,3) = C(:,:,3);
K(:,:,4) = C(:,:,4);

end