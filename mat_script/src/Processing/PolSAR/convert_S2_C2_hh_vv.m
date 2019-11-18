function [ C ] = convert_S2_C2_hh_vv( S )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(S);

C = zeros(rw,cl,4);

C(:,:,1) = abs(S(:,:,1)).^2;
C(:,:,2) = abs(S(:,:,2)).^2;
C(:,:,3) = real(S(:,:,1).*conj(S(:,:,2)));
C(:,:,4) = imag(S(:,:,1).*conj(S(:,:,2)));



end