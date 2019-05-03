function [ W, Wv, clusterCen ] = EnMIMA_MAPPER( data,fil,param )
%MIMA-MAPPER fast and dirty experiment for SDG
%   Detailed explanation goes here


W =zeros(size(data,1));

for cv_bin = 1:length(param.nbBin)
    for cv_ovl = 1:length(param.ovLap)
        % MAPPER parameter: number of bins, overlap rate
        innerParam.nbBin = param.nbBin(cv_bin);
        innerParam.ovLap = param.ovLap(cv_ovl);
        innerParam.itvFlag = param.itvFlag;

        % slices filtered values into intervals
        [ filIdx ] = divideData( fil, innerParam );

        % MAPPER clustering in data bins
        [ clusterIdx,clusterCen ] = mapperclustering( data,filIdx,param.clutMeth );

%         % construct the MAPPER derived topological structure, cluster level
         [ Wv,~,~ ] = visualMAPPER( clusterIdx,clusterCen,fil );
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


% W = W./max(W(:));
W = W>0;


end


