function [ per,quanSim,minS,maxS ] = chi2Dic( sim )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



[rw1,cl1,dn1] = size(sim);
vec1 = reshape(sim,rw1*cl1*dn1,1);
minS = min(vec1);
maxS = max(vec1);
per = linspace(0,1,1024);
quanSim = quantile(vec1,per);
% 
% H1 = hist(vec1,quanSim);
% proDF1 = [quanSim;cumsum(H1./(rw1*cl1*dn1))];
% xx = chi2inv(proDF1(2,:),49);
% m = sum(xx.*H1)/sum(H1);
% 
% output = abs(xx - m);



% x = linspace(min(vec1),max(vec1),1024);
% 
% H1 = hist(vec1,x);
% proDF1 = [x;H1./(rw1*cl1*dn1)];
% proDF1(2,:) = cumsum(proDF1(2,:));
% 
% xx = chi2inv(proDF1(2,:),49);
% xx(end) = xx(end-1);
% m = sum(xx.*H1)/sum(H1);
% 
% output = abs(xx - m);

end

