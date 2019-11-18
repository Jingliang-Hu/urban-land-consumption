function [ T ] = convert_C3_T3( C )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,dn] = size(C);

T = zeros(rw,cl,dn);

T(:,:,1) = C(:,:,1)+2*C(:,:,5)+C(:,:,3);
T(:,:,4) = C(:,:,1) - C(:,:,3);
T(:,:,7) = -2*C(:,:,8);

T(:,:,5) = sqrt(2)*(C(:,:,4)+C(:,:,6));
T(:,:,8) = sqrt(2)*(C(:,:,7)-C(:,:,9));

T(:,:,2) = C(:,:,1)-2*C(:,:,5)+C(:,:,3);
T(:,:,6) = sqrt(2)*(C(:,:,4)-C(:,:,6));
T(:,:,9) = sqrt(2)*(C(:,:,7)+C(:,:,9));

T(:,:,3) = 2*C(:,:,2);
T = T./2;

end

