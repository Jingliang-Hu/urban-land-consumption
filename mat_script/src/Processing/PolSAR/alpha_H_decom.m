function [ eigen,eigenvector,alpha,entropy ] = alpha_H_decom( polsar )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[r,c,d]=size(polsar);
matrix = zeros(sqrt(d),sqrt(d));
eigen = zeros(r,c,sqrt(d));
eigenvector = zeros(r,c,d);
p = zeros(r,c,sqrt(d));
for i = 1:r
    for j = 1:c
        matrix(1,1) = polsar(i,j,1);
        matrix(2,2) = polsar(i,j,2);
        matrix(1,2) = polsar(i,j,3)+1i*polsar(i,j,4);
        matrix(2,1) = polsar(i,j,3)-1i*polsar(i,j,4);
        
        [~,e,v] = svd(matrix);
        for k = 1:sqrt(d)
            eigen(i,j,k)=e(k,k);
        end
        eigenvector(i,j,:)=v(:);
        
    end
end



entropy = zeros(r,c);
for i = 1:sqrt(sqrt(d))
    p(:,:,i) = eigen(:,:,i)./sum(eigen,3);
    entropy = entropy - p(:,:,i).*log(p(:,:,i))./log(2);
end


alpha1 = acosd(abs(real(eigenvector(:,:,1))));
alpha2 = acosd(abs(real(eigenvector(:,:,3))));

alpha = p(:,:,1).*alpha1+p(:,:,2).*alpha2;

end

