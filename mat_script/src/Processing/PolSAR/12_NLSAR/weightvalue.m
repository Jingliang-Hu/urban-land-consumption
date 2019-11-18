function [ per,simquan,minS,maxS ] = weightvalue( L,W,P )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

M = 256;
N = 256;
D = 3;
rho = 0.95;


homo = WishartRnd( M,N,D,rho );
sim = DetectSimStat(homo,L,W,P);

[  per,simquan,minS,maxS  ] = simquantile( sim );



end

