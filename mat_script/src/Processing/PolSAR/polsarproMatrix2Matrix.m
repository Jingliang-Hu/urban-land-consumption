function [mat] = polsarproMatrix2Matrix(C)
%This function transform the covariance matrix format of polsarpro standard
%to the math format in order to being prepare for further calculation. Like
%matrix inverse.
%   Input:
%       - C             -- covariance matrix in polsarpro format N by 9
%   Output:
%       - mat           -- normal matrix form 3 by 3 by N

[n,~,d] = size(C);
d = sqrt(d);
mat = zeros(d,d,n);

if d == 3
    mat(1,1,:) = C(:,1,1);
    mat(2,2,:) = C(:,1,2);
    mat(3,3,:) = C(:,1,3);

    mat(1,2,:) = C(:,1,4)+C(:,1,7)*1i;
    mat(2,1,:) = C(:,1,4)-C(:,1,7)*1i;
    
    mat(1,3,:) = C(:,1,5)+C(:,1,8)*1i;
    mat(3,1,:) = C(:,1,5)-C(:,1,8)*1i;
    
    mat(2,3,:) = C(:,1,6)+C(:,1,9)*1i;
    mat(3,2,:) = C(:,1,6)-C(:,1,9)*1i;
elseif d == 2
    mat(1,1,:) = C(:,1,1);
    mat(2,2,:) = C(:,1,2);

    mat(1,2,:) = C(:,1,3)+C(:,1,4)*1i;
    mat(2,1,:) = C(:,1,3)-C(:,1,4)*1i;
    
end

end