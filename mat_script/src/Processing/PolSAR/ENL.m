function [ enl ] = ENL( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[rw,cl,dn] = size(data);
temp = reshape(data,rw*cl,1,dn);
enl = mean(temp,1).^2./std(temp,1).^2;
enl = reshape(enl,dn,[],1);
end

