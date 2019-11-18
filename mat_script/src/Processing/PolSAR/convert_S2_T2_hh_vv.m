function [ T ] = convert_S2_T2_hh_vv( S )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(S);

T = zeros(rw,cl,4);
temp = zeros(rw,cl,2);
temp(:,:,1) = S(:,:,1)+S(:,:,2);
temp(:,:,2) = S(:,:,1)-S(:,:,2);


T(:,:,1) = abs(temp(:,:,1)).^2;
T(:,:,2) = abs(temp(:,:,2)).^2;
T(:,:,3) = real(temp(:,:,1).*conj(temp(:,:,2)));
T(:,:,4) = imag(temp(:,:,1).*conj(temp(:,:,2)));

T = T./2;

end