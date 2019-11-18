clear all; close all; clc
% load TRX
% homo = TRX(748:870,370:479,:);
load simulated_Data1 Noisy_C_simulation

L = 1;
W = 7;
P = 1;
W7P1NLSARfake = NLSAR(Noisy_C_simulation,L,W,P);


fPauliImShow(W7P1NLSARfake);

% save('NLSARresImitation','W7P1NLSARfake','-append');