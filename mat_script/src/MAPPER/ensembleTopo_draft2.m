function [ W ] = ensembleTopo_draft2( data, param )
%ensembleTopo_draft2 differs ensembleTopo_draft1 on inputs,
%ensembleTopo_draft2 can take MAPPER parameters as input


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
% param.itvFlag = 1;
% nbBin = 5:5:40;
% ovLap = 0.2:0.2:0.8;

W =zeros(size(data,1));


figure,
for cv = 1:param.nbPairs
    
        % MAPPER parameter: number of bins, overlap rate
        paramTmp = param;
        paramTmp.nbBin = param.nbBin(cv);
        paramTmp.ovLap = param.ovLap(cv);
        
        % slices filtered values into intervals
        [ filIdx ] = divideData( fil, paramTmp );

        % MAPPER clustering in data bins
        [ clusterIdx,clusterCen ] = mapperclustering( data,filIdx, 'al' ); 
        
        % construct the MAPPER derived topological structure, cluster level
        [ Wv,~,filMean ] = visualMAPPER( clusterIdx,clusterCen,fil );
        
        % visualizing the MAPPER derived topological structure, cluster level
        subplot(ceil(param.nbPairs/4),4,cv);
        plot(graph(Wv),'NodeCData',mat2gray(filMean),'NodeLabel',[]);axis off;
        title(['b=',num2str(paramTmp.nbBin),',c=',num2str(paramTmp.ovLap)])
        
        % construct the MAPPER derived topological structure, data point level
        [ Wpt ] = pointWiseGraph( clusterIdx );
        
        % construct ensemble graph
        W = W + Wpt;

    
    
end
    

W = W./max(W(:));


end

