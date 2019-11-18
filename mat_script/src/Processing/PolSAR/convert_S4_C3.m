function [ C ] = convert_S4_C3( S )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,dn] = size(S);

C = zeros(rw,cl,9);


if dn == 4
    %sinclair to  covariance
    %   S(:,:,1): real(HH) + imag(HH)*1i
    %   S(:,:,2): real(HV) + imag(HV)*1i
    %   S(:,:,3): real(VH) + imag(VH)*1i
    %   S(:,:,4): real(VV) + imag(VV)*1i
       
    temp(:,:,1) = S(:,:,1);
    temp(:,:,2) = (S(:,:,2)+S(:,:,3))./sqrt(2);
    temp(:,:,3) = S(:,:,4);

    C(:,:,1) = abs(temp(:,:,1)).^2;
    C(:,:,2) = abs(temp(:,:,2)).^2;
    C(:,:,3) = abs(temp(:,:,3)).^2;
    C(:,:,4) = real(temp(:,:,1).*conj(temp(:,:,2)));
    C(:,:,7) = imag(temp(:,:,1).*conj(temp(:,:,2)));
    C(:,:,5) = real(temp(:,:,1).*conj(temp(:,:,3)));
    C(:,:,8) = imag(temp(:,:,1).*conj(temp(:,:,3)));
    C(:,:,6) = real(temp(:,:,2).*conj(temp(:,:,3)));
    C(:,:,9) = imag(temp(:,:,2).*conj(temp(:,:,3)));

elseif dn == 8

    %sinclair to  covariance
    %   S(:,:,1): real(HH)
    %   S(:,:,2): real(HV)
    %   S(:,:,3): real(VH)
    %   S(:,:,4): real(VV)
    %   S(:,:,5): imag(HH)
    %   S(:,:,6): imag(HV)
    %   S(:,:,7): imag(VH)
    %   S(:,:,8): imag(VV)

    [rw,cl,~] = size(S);

    C = zeros(rw,cl,9);
    HVreal = (S(:,:,2) + S(:,:,3))./2;
    HVimag = (S(:,:,6) + S(:,:,7))./2;


    C(:,:,1) = S(:,:,1).^2 + S(:,:,5).^2;
    C(:,:,2) = 2 * (HVreal.^2 + HVimag.^2);
    C(:,:,3) = S(:,:,4).^2 + S(:,:,8).^2;

    C(:,:,4) = sqrt(2) * (S(:,:,1) .* HVreal + S(:,:,5) .* HVimag);
    C(:,:,7) = sqrt(2) * (S(:,:,5) .* HVreal - S(:,:,1) .* HVimag);

    C(:,:,5) = (S(:,:,1) .* S(:,:,4) + S(:,:,5) .* S(:,:,8));
    C(:,:,8) = (S(:,:,5) .* S(:,:,4) - S(:,:,1) .* S(:,:,8));

    C(:,:,6) = sqrt(2) * ( HVreal .* S(:,:,5) + HVimag .* S(:,:,8));
    C(:,:,9) = sqrt(2) * ( HVimag .* S(:,:,5) - HVreal .* S(:,:,8));

end

end

