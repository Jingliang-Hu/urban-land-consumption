function [ father ] = find_union( edge,link )
%This function calculate the connected components of a graph given by edge,
%and the connnectivity given by link
%   Detailed explanation goes here

[n,~] = size(edge);
n = n + 1;
father = linspace(1,n,n)';
rank = zeros(n,1);
% den = ones(n,1);

for i = 1:n-1
    if link(i) == 1
        fatherL = getFather(edge(i,1),father);
        fatherR = getFather(edge(i,2),father);
        
        if rank(fatherL) >= rank(fatherR)
            
            father(father == fatherR) = fatherL;
            rank(fatherL) = rank(fatherL) + 1;
%             den(fatherL) = den(fatherL) + den(fatherR);
        else
            father(father == fatherL) = fatherR;
            rank(fatherR) = rank(fatherR) + 1;
%             den(fatherR) = den(fatherR) + den(fatherL);
        end
    end
    
end


end

function [ father_node ] = getFather( son, father )
    if son ~= father(son)
        getFather(father(son),father);
    end
    father_node = father(son);
end