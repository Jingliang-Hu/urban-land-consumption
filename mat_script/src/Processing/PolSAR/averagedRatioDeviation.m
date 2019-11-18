function [ ard ] = averagedRatioDeviation( denoised,gt )
%This function calculate the averaged ratio deviation of the denoised image
%when the ground truth is availabel. 
%   Detailed explanation goes here

[rd,cd,nd] = size(denoised);
[rg,cg,ng] = size(gt);
if rd~=rg || cd~=cg || nd~=ng
    disp('... dimension of denoised data and ground truth do not match');
    return;
end

ard = sum(abs(denoised(:)./gt(:)-1))./(rd*cd*nd);



end

