function [ C ] = convert_T3_C3( T )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,dn] = size(T);

C = zeros(rw,cl,dn);

C(:,:,1) = T(:,:,1)+2*T(:,:,4)+T(:,:,2);
C(:,:,2) = 2*T(:,:,2);
C(:,:,3) = T(:,:,1)-2*T(:,:,4)+T(:,:,2);

C(:,:,4) = sqrt(2)*(T(:,:,5)+T(:,:,6));
C(:,:,7) = sqrt(2)*(T(:,:,8)+T(:,:,9));

C(:,:,5) = T(:,:,1) - T(:,:,2);
C(:,:,8) = -2*T(:,:,7);

C(:,:,6) = sqrt(2)*(T(:,:,5)-T(:,:,6));
C(:,:,9) = sqrt(2)*(-T(:,:,8)+T(:,:,9));

C = C./2;

end

