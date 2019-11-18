function [ T ] = convert_S4_T3( S )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[rw,cl,dn] = size(S);
T = zeros(rw,cl,9);

if dn == 4
    Pauli = zeros(rw,cl,9);
    Pauli(:,:,1) = (S(:,:,1)+S(:,:,4))./sqrt(2);
    Pauli(:,:,2) = (S(:,:,1)-S(:,:,4))./sqrt(2);
    Pauli(:,:,3) = (S(:,:,2)+S(:,:,3))./sqrt(2);

    

    T(:,:,1) = abs(Pauli(:,:,1)).^2;
    T(:,:,2) = abs(Pauli(:,:,2)).^2;
    T(:,:,3) = abs(Pauli(:,:,3)).^2;
    T(:,:,4) = real(Pauli(:,:,1).*conj(Pauli(:,:,2)));
    T(:,:,7) = imag(Pauli(:,:,1).*conj(Pauli(:,:,2)));
    T(:,:,5) = real(Pauli(:,:,1).*conj(Pauli(:,:,3)));
    T(:,:,8) = imag(Pauli(:,:,1).*conj(Pauli(:,:,3)));
    T(:,:,6) = real(Pauli(:,:,2).*conj(Pauli(:,:,3)));
    T(:,:,9) = imag(Pauli(:,:,2).*conj(Pauli(:,:,3)));
elseif dn == 8
    T(:,:,1) = abs(Pauli(:,:,1)).^2;
    T(:,:,2) = abs(Pauli(:,:,2)).^2;
    T(:,:,3) = abs(Pauli(:,:,3)).^2;

end

