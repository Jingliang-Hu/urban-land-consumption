function [ W ] = WNormalize( W )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

D=sum(W);
D=sqrt(D);
N=size(W,1);
D21=sparse(N,N);
D21(diag(D==0)) = 1;
D21(diag(D~=0)) = 1./D(D~=0);

W=sparse((D21))*W*sparse((D21));

end

