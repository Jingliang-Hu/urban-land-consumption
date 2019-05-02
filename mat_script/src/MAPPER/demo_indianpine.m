clear all

%% load indian pine data and apply PCA
load('C:\Users\hujin\OneDrive\Documents\MATLAB\data\Indianpine\Indian_pines_corrected.mat')
load('C:\Users\hujin\OneDrive\Documents\MATLAB\data\Indianpine\Indian_pines_gt.mat')
gt = reshape(indian_pines_gt,size(indian_pines_gt,1)*size(indian_pines_gt,2),size(indian_pines_gt,3));
hsi = indian_pines_corrected; clear indian_pines_corrected
tmp = reshape(hsi,size(hsi,1)*size(hsi,2),size(hsi,3));

tmp = tmp(gt>0,:);
tmp = zscore(tmp);
tmp = pca_dr(tmp);

%%
fil = tmp(:,1);
param.itvFlag = 1;
param.nbBin = 5;
param.ovLap = 0.7;


[ filIdx ] = divideData( fil, param );

[ cluster,cluCenter ] = mapperclustering( tmp,filIdx, 'sl' );

[ W,cluCens ] = visualMAPPER( cluster,cluCenter );


figure,plot(graph(W));

figure,plot(graph(W),'XData',cluCens(:,1),'YData',cluCens(:,3));


