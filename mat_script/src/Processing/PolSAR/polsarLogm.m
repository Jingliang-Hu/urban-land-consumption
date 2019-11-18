function [ polsarlog ] = polsarLogm( polsar )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[r,c,n] = size(polsar);
polsarlog = zeros(r,c,n);

for i = 1:r
    for j = 1:c
        temp = [polsar(r,c,1),polsar(r,c,3)+1i*polsar(r,c,4);polsar(r,c,3)-1i*polsar(r,c,4),polsar(r,c,2)];
        [V,D] = eig(temp);
        D = log(D);
        L = V*D/V;
        polsarlog(r,c,1)=L(1,1);
        polsarlog(r,c,2)=L(2,2);
        polsarlog(r,c,3)=real(L(1,2));
        polsarlog(r,c,4)=imag(L(1,2));
    end
end

end

