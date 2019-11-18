function [ start_coord_A,end_coord_A,start_coord_B,end_coord_B ] = dataExtent( dataA,refmatA,dataB,refmatB )
%This function extracts the northwest and southeast coordinates of the
%overlapped area of data A and B according to their geo-reference information.
%
%   Input:
%       - dataA                 - input data A
%       - refmatA               - data A reference matrix
%       - dataB                 - input data B
%       - refmatB               - data B reference matrix
%
%   Output:
%       - start_coord_A         - data A northwest coordinate
%       - end_coord_A           - data A southeast coordinate
%       - start_coord_B         - data B northwest coordinate
%       - end_coord_B           - data B southeast coordinate


if refmatA(1,2)>=0 || refmatA(2,1)<=0 || refmatB(1,2)>=0 || refmatB(2,1)<=0
    disp('coordinate info should starts from northwest corner');
    return;
end


[r_A,c_A,~] = size(dataA);
[r_B,c_B,~] = size(dataB);

% coordinate of northwest corners of polsar and hsi
start_coord_A = refmatA(3,:);
start_coord_B = refmatB(3,:);

% coordinate of southeast corners of polsar and hsi
end_coord_A(1) = refmatA(3,1) + c_A * refmatA(2,1);
end_coord_A(2) = refmatA(3,2) + r_A * refmatA(1,2);

end_coord_B(1) = refmatB(3,1) + c_B * refmatB(2,1);
end_coord_B(2) = refmatB(3,2) + r_B * refmatB(1,2);


end


