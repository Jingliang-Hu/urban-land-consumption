function [ K ] = convert_S4_K( S )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,d] = size(S);

K = zeros(rw,cl,10);

if d == 4
    %sinclair to  covariance
    %   S(:,:,1): real(HH) + imag(HH)*1i
    %   S(:,:,2): real(HV) + imag(HV)*1i
    %   S(:,:,3): real(VH) + imag(VH)*1i
    %   S(:,:,4): real(VV) + imag(VV)*1i

    K(:,:,1) = 0.5 * (abs(S(:,:,1)).^2 + abs(S(:,:,2)).^2 + abs(S(:,:,3)).^2 + abs(S(:,:,4)).^2);
    K(:,:,2) = 0.5 * (abs(S(:,:,1)).^2 - abs(S(:,:,2)).^2 - abs(S(:,:,3)).^2 + abs(S(:,:,4)).^2);
    K(:,:,3) = 0.5 * (abs(S(:,:,2)).^2 + abs(S(:,:,3)).^2) + ( real(S(:,:,1)).*real(S(:,:,4)) + imag(S(:,:,1)).*imag(S(:,:,4)) );
    K(:,:,4) = 0.5 * (abs(S(:,:,2)).^2 + abs(S(:,:,3)).^2) - ( real(S(:,:,1)).*real(S(:,:,4)) + imag(S(:,:,1)).*imag(S(:,:,4)) );
    K(:,:,5) = 0.5 * (abs(S(:,:,1)).^2 - abs(S(:,:,4)).^2);
    
    temp = S(:,:,2) + S(:,:,3);
    K(:,:,6) = 0.5 * real(S(:,:,1) .* conj(temp) + temp .* conj(S(:,:,4)));
    K(:,:,7) = 0.5 * imag(S(:,:,1) .* conj(temp) + temp .* conj(S(:,:,4)));    
    K(:,:,8) = imag(S(:,:,1) .* conj(S(:,:,4)));
    
    K(:,:,9)  = 0.5 * imag(S(:,:,1) .* conj(temp) - temp .* conj(S(:,:,4)));
    K(:,:,10) = 0.5 * real(S(:,:,1) .* conj(temp) - temp .* conj(S(:,:,4)));
    
    % The one to one correspondence between the kennaugh matrix and the
    % coherency matrix exists under the condition that, the pixels are pure
    % single targets. Pure single targets mean that they are produced without
    % any external disturbances due to a clutter environment or a time
    % fluctuation of the target exposure. They are coherent scattering.

elseif d == 8
    
end

