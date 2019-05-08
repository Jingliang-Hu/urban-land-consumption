function [ W ] = ensembleTopo_draft1( data )
%UNTITLED18 Summary of this function goes here
%   Detailed explanation goes here

% normalization
for i = 1:size(data,2)
    data(:,i) = mat2gray(data(:,i));
end

% filter function
K = 12;
D = pdist(data);
D = squareform(D);
D = sort(D);
fil = log(D(K+1,:)');

% MAPPER parameters
param.itvFlag = 1;
nbBin = 10:5:60;
ovLap = 0.1:0.1:0.9;

W =zeros(size(data,1));


figure,
for cv_bin = 1:length(nbBin)
    for cv_ovl = 1:length(ovLap)
        % MAPPER parameter: number of bins, overlap rate
        param.nbBin = nbBin(cv_bin);
        param.ovLap = ovLap(cv_ovl);
        
        % slices filtered values into intervals
        [ filIdx ] = divideData( fil, param );

        % MAPPER clustering in data bins
        [ clusterIdx,clusterCen ] = mapperclustering( data,filIdx, 'al' ); 
        
        % construct the MAPPER derived topological structure, cluster level
        [ Wv,~,filMean ] = visualMAPPER( clusterIdx,clusterCen,fil );        
        % visualizing the MAPPER derived topological structure, cluster level
        subplot(length(nbBin),length(ovLap),(cv_bin-1)*length(ovLap)+cv_ovl);
        plot(graph(Wv),'NodeCData',mat2gray(filMean),'NodeLabel',[]);axis off;
        title(['b=',num2str(param.nbBin),',c=',num2str(param.ovLap)])
        
%         % construct the MAPPER derived topological structure, data point level
%         [ Wpt ] = pointWiseGraph( clusterIdx );
%         
%         % construct ensemble graph
%         W = W + Wpt;

    end
    
end
    

W = W./max(W(:));


end

