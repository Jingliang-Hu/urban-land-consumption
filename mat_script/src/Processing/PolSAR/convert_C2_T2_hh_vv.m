function [ T ] = convert_C2_T2_hh_vv( C )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(C);

T = zeros(rw,cl,4);

T(:,:,1) = C(:,:,1)+C(:,:,2)+2*C(:,:,3);
T(:,:,2) = C(:,:,1)+C(:,:,2)-2*C(:,:,3);
T(:,:,3) = C(:,:,1)-C(:,:,2);
T(:,:,4) = -2*C(:,:,4);
T = T./2;


end