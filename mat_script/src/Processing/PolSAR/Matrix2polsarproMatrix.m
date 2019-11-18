function [C] = Matrix2polsarproMatrix(mat)
%This function transform the covariance matrix of normal math form to the 
%covariance matrix of polsarpro format
%   Input:
%       - mat           -- normal matrix form 3 by 3 by N
%
%   Output:
%       - C             -- covariance matrix in polsarpro format N by 9

[r,~,~] = size(mat);
if r == 3
    C(:,1) = mat(1,1,:);
    C(:,2) = mat(2,2,:);
    C(:,3) = mat(3,3,:);

    C(:,4) = real(mat(1,2,:));
    C(:,7) = imag(mat(1,2,:));
        
    C(:,5) = real(mat(1,3,:));
    C(:,8) = imag(mat(1,3,:));
    
    C(:,6) = real(mat(2,3,:));
    C(:,9) = imag(mat(2,3,:));
    
elseif r == 2
    C(:,1) = mat(1,1,:);
    C(:,2) = mat(2,2,:);
    
    C(:,3) = real(mat(1,2,:));
    C(:,4) = imag(mat(1,2,:));
    
end
end