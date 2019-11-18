function [ C ] = CInv( C )
%This function calculate the inverse matrix of polsar covariance matrix
%   Detailed explanation goes here
[n,~,~] = size(C);
[mat_temp] = polsarproMatrix2Matrix(C);
for i = 1:n
    mat_temp(:,:,i) = inv(mat_temp(:,:,i));
end
[C] = Matrix2polsarproMatrix(mat_temp);

end









