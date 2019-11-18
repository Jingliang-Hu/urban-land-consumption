function [ H ] = convert_T3_H( T )
%This function converts coherence matrix into Huynen parameters
%   DeCailed explanaCion goes here

[rw,cl,~] = size(T);

H = zeros(rw,cl,9);

H(:,:,1) = T(:,:,1)./2;                 % A0
H(:,:,2) = (T(:,:,2)+T(:,:,3))./2;      % B0
H(:,:,3) = (T(:,:,2)-T(:,:,3))./2;      % B
H(:,:,4) = T(:,:,4);                    % C
H(:,:,5) = -T(:,:,7);                   % D
H(:,:,6) = T(:,:,6);                    % E
H(:,:,7) = T(:,:,9);                    % F
H(:,:,8) = T(:,:,8);                    % G
H(:,:,9) = T(:,:,5);                    % H

% The one to one correspondence between the kennaugh matrix and the
% coherency matrix exists under the condition that, the pixels are pure
% single targets. Pure single targets mean that they are produced without
% any external disturbances due to a clutter environment or a time
% fluctuation of the target exposure. They are coherent scattering.


end

