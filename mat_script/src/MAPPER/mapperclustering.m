% Author:       Jingliang Hu, PhD candidate 
% Email:        jingliang.hu@dlr.de
% Affiliation:  German Aerospace Center (DLR)
%               Technische Universit�t M�nchen (TUM)
function [ clusterIdx,clusterCen ] = mapperclustering( data,filIdx,clusterMethod )
%This function divides data into bins according to the intervals of
%filtered values and applies clustering on each bins. 
%   -- Input:
%        - data                       -- array of n by m, n instances, m dimensions 
%        - filIdx                     -- index of data bins for each instance in data
%        - clusterMethod              -- choose clustering method
%
%   -- Output:
%        - clusterIdx                 -- cluster index of each instances
%        - clusterCen                 -- cluster centers
nbInterval = size(filIdx,2);

% initial the output matrix
clusterIdx = zeros(size(filIdx));
% initial cluster centers
clusterCen = cell(3,nbInterval);

% clustering of each bin
maxCluIdx = 0;
for i = 1:nbInterval
    if sum(filIdx(:,i)==1)==0
        % no data point in the current bin
        continue;
    elseif sum(filIdx(:,i)==1)<7
        % less than 7 data points in the current bin
        disp(['number of data point of the ',num2str(i),'th data bin is less than 7! ']);
        dataTemp = data(filIdx(:,i)==1,:); 
        C = [1:sum(filIdx(:,i)==1)]';
    else
        % more than one data point in the current bin
        dataTemp = data(filIdx(:,i)==1,:);    
        disp(['number of data point of the ',num2str(i),'th data bin: ',num2str(size(dataTemp,1))]);
        switch lower(clusterMethod)
            case 'dbscan'
                % to be finished
                epsilon=0.3;
                MinPts=3;
                C = DBSCAN(dataTemp,epsilon,MinPts);
            case 'sc'
                distMat = squareform(pdist(double(dataTemp)));    
                W = exp( -distMat./(1.4826 * mad(distMat(:),1))^2 );
                [C,~] = spectralClustering_MAPPER(W,3);
            case 'sl' % single linkage
                distMat = pdist(dataTemp);
                z = linkage(distMat);
                % --------------------------------------------------------------------
                % deciding the number of clusters using the strategy in:
                % Singh, Gurjeet, Facundo M�moli, and Gunnar E Carlsson. �Topological Methods for the Analysis of High Dimensional Data Sets and 3D Object Recognition.� In SPBG, 91�100, 2007.
                [x,y] = hist(z(:,3),30); 
                [~,idx] = min(x);            
                % --------------------------------------------------------------------
                C = cluster(z,'cutoff',y(idx),'criterion','distance');
            case 'al' % average linkage
                distMat = pdist(dataTemp);
                z = linkage(distMat,'average');
                [x,y] = hist(z(:,3),30); 
                [~,idx] = min(x);            
                % --------------------------------------------------------------------
                C = cluster(z,'cutoff',y(idx),'criterion','distance');
            case 'ms' % mean shift
                distMat = pdist(dataTemp);                
                [~,C,~] = MeanShiftCluster(dataTemp', (1.4826 * mad(distMat(:),1))^2);
                C = C';
                claCode = unique(C);
                for idxMS = 1:length(claCode)
                    C(C==claCode(idxMS)) = idxMS;
                end
        end  
    end
    
    % get the cluster centers
    centerTmp = zeros(max(C),size(dataTemp,2));
    nbOfPix = zeros(max(C),1);
    for xx = 1:max(C)
        centerTmp(xx,:) = mean(dataTemp(C==xx,:));
        nbOfPix(xx) = sum(C==xx);
    end
    clusterCen{1,i} = unique(C) + maxCluIdx;
    clusterCen{2,i} = centerTmp;    
    clusterCen{3,i} = nbOfPix;
    % get the cluster index
    clusterIdx(filIdx(:,i)==1,i) = C + maxCluIdx;        
    % update the maximum index of existed clusters
    maxCluIdx = max(clusterIdx(:));
end

end




