

%% load data
repMIMA_D_data
clearvars -except LS8Data SE1Data

%% MAPPER
% input data, n by m matrix, n instances, m dimensions
data = LS8Data;
% data = SE1Data;

% normlization
% for i = 1:size(data,2)
%     data(:,i) = mat2gray(data(:,i));
% end

% filter function
filFunc = 'density';
switch lower(filFunc)
    case 'density'
        K = 12;
        D = pdist(data);
        D = squareform(D);
        D = sort(D);
        fil = log(D(K+1,:)');
        % ??? assume 1% outliers, which has low density
%         thres = quantile(fil,0.99);
%         fil(fil>thres) = thres;   
end

% MAPPER parameters
param.itvFlag = 1;
nbBin = 5:10:40;
ovLap = 0.2:0.2:0.8;

% MAPPER
figure(100),
for cv_bin = 1:length(nbBin)
    for cv_ovl = 1:length(ovLap)
        % MAPPER parameter: number of bins, overlap rate
        param.nbBin = nbBin(cv_bin);
        param.ovLap = ovLap(cv_ovl);
        
        % slices filtered values into intervals
        [ filIdx ] = divideData( fil, param );

        % MAPPER clustering in data bins
        [ clusterIdx,clusterCen ] = mapperclustering( data,filIdx, 'sl' );
        
        % construct the MAPPER derived topological structure, cluster level
        [ W,cluCens,filMean ] = visualMAPPER( clusterIdx,clusterCen,fil );        
        % visualizing the MAPPER derived topological structure, cluster level
        figure(100),subplot(length(nbBin),length(ovLap),(cv_bin-1)*length(ovLap)+cv_ovl);
        plot(graph(W),'NodeCData',mat2gray(filMean),'NodeLabel',[]);axis off;
        title(['b=',num2str(param.nbBin),',c=',num2str(param.ovLap),'%'])
        
        % construct the MAPPER derived topological structure, data point level
%         [ Wpt ] = pointWiseGraph( clusterIdx );
        

    end
    
end
    
