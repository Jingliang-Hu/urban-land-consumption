function [ ard ] = squareError( signal,gt )
%This function calculate the averaged ratio deviation of the denoised image
%when the ground truth is availabel. 
%   Detailed explanation goes here

[rd,cd,nd] = size(signal);
[rg,cg,ng] = size(gt);
if rd~=rg || cd~=cg || nd~=ng
    disp('... dimension of denoised data and ground truth do not match');
    return;
end

ard = sum(abs(signal(:)-gt(:)).^2)./(rd*cd*nd);



end

