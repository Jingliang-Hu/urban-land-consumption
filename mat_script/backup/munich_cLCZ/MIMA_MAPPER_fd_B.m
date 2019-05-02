function [ W ] = MIMA_MAPPER_fd_B( data )
%MIMA-MAPPER fast and dirty experiment for SDG
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

% outlier processing
thres = quantile(fil,.99);
fil(fil>thres) = thres;

% MAPPER parameters
param.itvFlag = 1;
nbBin = 5:5:30;
ovLap = .4:.1:.9;

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
        
%         % construct the MAPPER derived topological structure, cluster level
%         [ Wv,~,filMean ] = visualMAPPER( clusterIdx,clusterCen,fil );      
%         g = graph(Wv);
%         % visualizing the MAPPER derived topological structure, cluster level
%         subplot(length(nbBin),length(ovLap),(cv_bin-1)*length(ovLap)+cv_ovl);
%         plot(g,'NodeCData',mat2gray(filMean),'NodeLabel',[]);axis off;
%         title(['b=',num2str(param.nbBin),',c=',num2str(param.ovLap),', ratio: ',num2str(size(g.Edges,1)/size(g.Nodes,1))])
        
        % construct the MAPPER derived topological structure, data point level
        [ Wpt ] = pointWiseGraph( clusterIdx );
        
        % construct ensemble graph
        W = W + Wpt;

    end
    
end
    

W = W./max(W(:));


end


