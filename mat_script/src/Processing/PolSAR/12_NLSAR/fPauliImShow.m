% #########################################################################
% 
% This algorithm is modified based on the codes with the paper 
% 'Nonlocal Filtering for Polarimetric SAR Data: A Pretest Approach'
% Author: Jiong Chen, Yilun Chen, Wentao An, Yi Cui, Jian Yang
% Source codes downloaded from 'https://sites.google.com/site/jiongc/'
%
% #########################################################################

function z = fPauliImShow(varargin)
% pesudo color image with Pauli basises

% input     -- data     - Polarimetric data (m x n x 9)

% output    -- z        - pesudo color image with Pauli basis

data = varargin{1};
n = 2;
if nargin ==2
    n = varargin{2};
end

z(:,:,3) = data(:,:,1)./(mean2(data(:,:,1))*n); % blue
z(:,:,1) = data(:,:,2)./(mean2(data(:,:,2))*n); % red
z(:,:,2) = data(:,:,3)./(mean2(data(:,:,3))*n); % green

figure;imshow(z.*2);