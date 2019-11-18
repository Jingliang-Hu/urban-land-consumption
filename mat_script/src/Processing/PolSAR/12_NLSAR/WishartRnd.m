function [ C ] = WishartRnd( M,N,D,rho )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

chol = zeros( D , D );
chol(1,1) = 1;
for k = 2:D
    a = 0;
    
    for l = 1:k-2
        chol(k,l) = chol(k-1,l);
        a = a+chol(k,l)*chol(k,l);
    end
   
    chol(k,k-1) = (rho-a)/chol(k-1,k-1);
    a = a+chol(k,k-1)*chol(k,k-1);
    chol(k,k) = sqrt(1-a);
    
end

n1 = (nlRand(M,N)+1i.*nlRand(M,N))./sqrt(2);
n2 = (nlRand(M,N)+1i.*nlRand(M,N))./sqrt(2);
n3 = (nlRand(M,N)+1i.*nlRand(M,N))./sqrt(2);

s(:,:,1) = chol(1,1).*n1+chol(2,1).*n2+chol(3,1).*n3;
s(:,:,2) = chol(1,2).*n1+chol(2,2).*n2+chol(3,2).*n3;
s(:,:,3) = chol(1,3).*n1+chol(2,3).*n2+chol(3,3).*n3;

[ C ] = convert_S3_C3( s );

end


