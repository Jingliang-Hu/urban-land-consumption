function [ topo_mat ] = topo_connectivity_matrix( im )
%This function calculates a topological matrix representing the neighbor 
% topological relationship of the image objects
%
%   Input
%       - im            -- topological map (segmentation result)
% 
%   Output
%       - topo_mat      -- topological matrix
% 
% 
%   Topological matrix description:
%   row 1: [	segment 1	, connectivity of 1 and 2, connectivity of 1 and 3
%   row 2:          0       ,       segment 2        , connectivity of 2 and 3
%   row 3:          0       ,          0             ,       segment 2        ]

[r,c,~]=size(im);
if sum(im(:)==0) 
    im = im+1;
end

num = max(unique(im(:)));
topo_mat = zeros(num);
mask = ones(3,3);
im_pad = padarray(im,[1,1]);

for i = 1:r
    for j = 1:c
        temp = mask.*im_pad(i:i+2,j:j+2);
        if i == 1 && j == 1                           % up-left corner
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(2,3)) = topo_mat(temp(2,2),temp(2,3))+1;
            topo_mat(temp(2,2),temp(3,2)) = topo_mat(temp(2,2),temp(3,2))+1;
            topo_mat(temp(2,2),temp(3,3)) = topo_mat(temp(2,2),temp(3,3))+1;
        elseif i == 1 && j>1 && j<c                 % up edge
            topo_mat(temp(2,2),temp(2,1)) = topo_mat(temp(2,2),temp(2,1))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(2,3)) = topo_mat(temp(2,2),temp(2,3))+1;
            topo_mat(temp(2,2),temp(3,1)) = topo_mat(temp(2,2),temp(3,1))+1;
            topo_mat(temp(2,2),temp(3,2)) = topo_mat(temp(2,2),temp(3,2))+1;
            topo_mat(temp(2,2),temp(3,3)) = topo_mat(temp(2,2),temp(3,3))+1;
        elseif i == 1 && j==c                       % up-right corner
            topo_mat(temp(2,2),temp(2,1)) = topo_mat(temp(2,2),temp(2,1))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(3,1)) = topo_mat(temp(2,2),temp(3,1))+1;
            topo_mat(temp(2,2),temp(3,2)) = topo_mat(temp(2,2),temp(3,2))+1;            
        elseif i ~= 1 && i ~= c && j==1             % left edge
            topo_mat(temp(2,2),temp(1,2)) = topo_mat(temp(2,2),temp(1,2))+1;
            topo_mat(temp(2,2),temp(1,3)) = topo_mat(temp(2,2),temp(1,3))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(2,3)) = topo_mat(temp(2,2),temp(2,3))+1;            
            topo_mat(temp(2,2),temp(3,2)) = topo_mat(temp(2,2),temp(3,2))+1;
            topo_mat(temp(2,2),temp(3,3)) = topo_mat(temp(2,2),temp(3,3))+1;
        elseif i ~= 1 && i ~= c && j>1 && j<c     % middle
            topo_mat(temp(2,2),temp(1,1)) = topo_mat(temp(2,2),temp(1,1))+1;
            topo_mat(temp(2,2),temp(1,2)) = topo_mat(temp(2,2),temp(1,2))+1;
            topo_mat(temp(2,2),temp(1,3)) = topo_mat(temp(2,2),temp(1,3))+1;
            topo_mat(temp(2,2),temp(2,1)) = topo_mat(temp(2,2),temp(2,1))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(2,3)) = topo_mat(temp(2,2),temp(2,3))+1;
            topo_mat(temp(2,2),temp(3,1)) = topo_mat(temp(2,2),temp(3,1))+1;
            topo_mat(temp(2,2),temp(3,2)) = topo_mat(temp(2,2),temp(3,2))+1;
            topo_mat(temp(2,2),temp(3,3)) = topo_mat(temp(2,2),temp(3,3))+1;
        elseif i ~= 1 && i ~= c && j==c           % right edge       
            topo_mat(temp(2,2),temp(1,1)) = topo_mat(temp(2,2),temp(1,1))+1;
            topo_mat(temp(2,2),temp(1,2)) = topo_mat(temp(2,2),temp(1,2))+1;
            topo_mat(temp(2,2),temp(2,1)) = topo_mat(temp(2,2),temp(2,1))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(3,1)) = topo_mat(temp(2,2),temp(3,1))+1;
            topo_mat(temp(2,2),temp(3,2)) = topo_mat(temp(2,2),temp(3,2))+1;
        elseif i == c && j==1                       % bottom-left corner
            topo_mat(temp(2,2),temp(1,2)) = topo_mat(temp(2,2),temp(1,2))+1;
            topo_mat(temp(2,2),temp(1,3)) = topo_mat(temp(2,2),temp(1,3))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(2,3)) = topo_mat(temp(2,2),temp(2,3))+1;           
        elseif i == c && j>1 && j<c               % bottom edge
            topo_mat(temp(2,2),temp(1,1)) = topo_mat(temp(2,2),temp(1,1))+1;
            topo_mat(temp(2,2),temp(1,2)) = topo_mat(temp(2,2),temp(1,2))+1;
            topo_mat(temp(2,2),temp(1,3)) = topo_mat(temp(2,2),temp(1,3))+1;
            topo_mat(temp(2,2),temp(2,1)) = topo_mat(temp(2,2),temp(2,1))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;
            topo_mat(temp(2,2),temp(2,3)) = topo_mat(temp(2,2),temp(2,3))+1;            
        elseif i == c && j==c                     % bottom-right corner
            topo_mat(temp(2,2),temp(1,1)) = topo_mat(temp(2,2),temp(1,1))+1;
            topo_mat(temp(2,2),temp(1,2)) = topo_mat(temp(2,2),temp(1,2))+1;
            topo_mat(temp(2,2),temp(2,1)) = topo_mat(temp(2,2),temp(2,1))+1;
            topo_mat(temp(2,2),temp(2,2)) = topo_mat(temp(2,2),temp(2,2))+1;            
        end
    end
end

topo_mat = (topo_mat~=0)+eye(num);


end

