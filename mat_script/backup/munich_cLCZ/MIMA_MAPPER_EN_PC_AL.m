function [ W, Wv ] =MIMA_MAPPER_EN_PC_AL( data,nbBin,ovLap )
%MIMA-MAPPER fast and dirty experiment for SDG
%   Detailed explanation goes here

dtmp =zscore(data);
% pca decomposition
[T,~,~,~,~,~]=pca(dtmp);
fil = dtmp*T(:,1);

% outliers elimination
thresOutlier = quantile(fil,[0.005,0.995]);
fil(fil<thresOutlier(1)) = thresOutlier(1);
fil(fil>thresOutlier(2)) = thresOutlier(2);

% MAPPER parameters
param.itvFlag = 1;
% nbBin = 5:5:30;
% ovLap = .4:.1:.9;

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
         [ Wv,~,filMean ] = visualMAPPER( clusterIdx,clusterCen,fil );      
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


