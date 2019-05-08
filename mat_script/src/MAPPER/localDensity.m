function [density] = localDensity(data,k)
%This function calculate the local density of data. The returned density
%values are actually distance values. The smaller the returned value, the
%higher density it is.

PD = squareform(pdist(data));
density = sort(PD);
density = density(k+1,:)';

end

