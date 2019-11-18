function [ xor ] = crcorr( x,y )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if length(x)>length(y)
    long = x;
    short = y;
else 
    long = y;
    short = x;
end

l = length(long);
s = length(short);
long = long-mean(long);
short = short-mean(short);
xor = ones(1,l-s+1);

for i = 1:l-s+1
    xor(i) = sum(short.*long(i:s+i-1));
end
end

