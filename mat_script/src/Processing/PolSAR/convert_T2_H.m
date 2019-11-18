function [ K ] = convert_T2_H( T )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(T);
K = zeros(rw,cl,3);

K(:,:,1) = T(:,:,1)./2;                 % A0
K(:,:,2) = T(:,:,3);                    % C
K(:,:,3) = -T(:,:,4);                   % D


% The one to one correspondence between the kennaugh matrix and the
% coherency matrix exists under the condition that, the pixels are pure
% single targets. Pure single targets mean that they are produced without
% any external disturbances due to a clutter environment or a time
% fluctuation of the target exposure. They are coherent scattering.


end

