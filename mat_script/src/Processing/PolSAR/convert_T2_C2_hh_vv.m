function [ C ] = convert_T2_C2_hh_vv( T )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(T);

C = zeros(rw,cl,4);

C(:,:,1) = T(:,:,1)+T(:,:,2)+2*T(:,:,3);
C(:,:,2) = T(:,:,1)+T(:,:,2)-2*T(:,:,3);
C(:,:,3) = T(:,:,1)-T(:,:,2);
C(:,:,4) = -2*T(:,:,4);
C = C./2;


end