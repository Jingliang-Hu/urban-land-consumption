% Author:       Jingliang Hu, PhD candidate 
% Email:        jingliang.hu@dlr.de
% Affiliation:  German Aerospace Center (DLR)
%               Technische Universit�t M�nchen (TUM)
function [ Wpt ] = pointWiseGraph( clusterIdx )
%This function get the MAPPER graph on the point wise level
%   -- Input:
%        - clusterIdx          -- cluster index of MAPPER result
%
%   -- Output:
%        - Wpt                 -- data point level MAPPER graph
%

% get the number of cores
% c = parcluster('local');
% nbCore = c.NumWorkers;
% maxNumCompThreads(nbCore);
% disp('---------------------------------------------------------')
% disp(['Total number of local cores: ',num2str(c.NumWorkers),'; Number of cores in use: ',num2str(nbCore)]);

% construct point wise graph
Wpt =sparse(zeros(size(clusterIdx,1)));
idxItv = size(clusterIdx,2);
for i = 1:idxItv
    tmp = clusterIdx(:,i);
    S = repmat(tmp,1,length(tmp))==repmat(tmp',length(tmp'),1);
    S(tmp==0,:) = 0;
    Wpt = Wpt + S;
    % progress bar
    if mod(i,ceil(idxItv/10))==0
        disp(['--- construct point-wise graph, ',num2str(10*i/ceil(idxItv/10)),'% is done ---']);
    end
end
Wpt = Wpt./max(Wpt(:));
disp('---------------------------------------------------------')

end
