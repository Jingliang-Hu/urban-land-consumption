clear
clc
close all
restoredefaultpath
addpath(genpath('./'))

%% two spirals data simulation
[x,y] = gsp_twospirals(3000, 570, 90, 0.5);
figure,
plot(x(y==1,1),x(y==1,2),'xr');
hold on
plot(x(y==0,1),x(y==0,2),'ob');
hold off
M = x;

%% horse example from kepler-mapper
M = csvread('D:\Matlab\SDG\src\MAPPER\examples\horse\horse-reference.csv');


%% set input data and parameters
data = M;
for i = 1:size(data,2)
    data(:,i) = mat2gray(data(:,i));
end
fil = data(:,2);
param.itvFlag = 1;
nbBin = 10:15;
ovLap = 0.2:0.2:0.8;

figure(100),
for cv_bin = 1:length(nbBin)
    for cv_ovl = 1:length(ovLap)
        param.nbBin = nbBin(cv_bin);
        param.ovLap = ovLap(cv_ovl);
        
        [ filIdx ] = divideData( fil, param );
        [ cluster,cluCenter ] = mapperclustering( data,filIdx, 'sl' );
        [ W,cluCens ] = visualMAPPER( cluster,cluCenter );
               
        figure(100),subplot(length(nbBin),length(ovLap),(cv_bin-1)*length(ovLap)+cv_ovl);
        plot(graph(W));
        title(['b=',num2str(param.nbBin),',c=',num2str(param.ovLap),'%'])

    end
    
end
    
    





