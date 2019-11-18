function [quanSim,minS,maxS ] = simquantile( L,W,P )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% M = 256;
% N = 256;
% D = 3;
% rho = 0.95;
% 
% homo = WishartRnd( M,N,D,rho );


% load TRX
% homo = TRX(748:870,370:479,:);
load simulated_Data1 Noisy_C_simulation
homo = Noisy_C_simulation(210:270,210:270,:);

sim = DetectSimStat(homo,L,W,P);

[rw1,cl1,dn1] = size(sim);
vec1 = reshape(sim,rw1*cl1*dn1,1);
minS = min(vec1);
maxS = max(vec1);
per = linspace(0,1,1024);
quanSim = quantile(vec1,per);


end