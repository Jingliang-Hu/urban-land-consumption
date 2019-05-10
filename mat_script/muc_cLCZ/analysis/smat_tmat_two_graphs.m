clear
addpath(genpath('/data/hu/SDG'));

%% load data
load('/data/hu/SDG/munich_cLCZ_perc/con/con_xv.mat', 'trainIdx', 'testIdx', 'observ', 'nbFeatSE1', 'lab')
observ = double(observ);

nFolds = 1;
% idxCla = unique(lab);
% for i = 1:length(idxCla)
%     lab(lab==idxCla(i)) = i;
% end




%% get the data
    trainPerc = [ones(1,1),zeros(1,9)] == 1; % 10 percent
    trainPercTmp = circshift(trainPerc,nFolds-1);
    trIndex = sum(trainIdx(:,trainPercTmp),2)>0;
    
    trLab = lab(trIndex);
    teLab = lab(~trIndex);

    trainSE1 = observ( trIndex,1:nbFeatSE1);
    testSE1  = observ(~trIndex,1:nbFeatSE1);

    trainSE2 = observ( trIndex,nbFeatSE1+1:size(observ,2));
    testSE2  = observ(~trIndex,nbFeatSE1+1:size(observ,2));

se1Data = cat(1,trainSE1,testSE1);
se2Data = cat(1,trainSE2,testSE2);

%% get the data
% % % trLab = lab(trainIdx(:,nFolds));
% % % teLab = lab( testIdx(:,nFolds));
% % % 
% % % trainSE1 = observ(trainIdx(:,nFolds),1:nbFeatSE1);
% % % testSE1  = observ( testIdx(:,nFolds),1:nbFeatSE1);
% % % 
% % % trainSE2 = observ(trainIdx(:,nFolds),nbFeatSE1+1:size(observ,2));
% % % testSE2  = observ( testIdx(:,nFolds),nbFeatSE1+1:size(observ,2));
% % % 
% % % se1Data = cat(1,trainSE1,testSE1);
% % % se2Data = cat(1,trainSE2,testSE2);


%% data preprocessing 
% SE1 magnitude difference --- dB
se1Data(:,[1:21,29:31,33:35]) = log10(se1Data(:,[1:21,29:31,33:35]));
se1Data = zscore(se1Data);
se2Data = zscore(se2Data);


%% mima graph 
% solution one: model 'label similarity graph' and 'topology graph' as one
% graph

% label similarity graph
G_sup = repmat(trLab,1,length(trLab))==repmat(trLab',length(trLab'),1);
G_sup = double(G_sup);

% se1
data = se1Data;

% parameters
param.nbBin = 40;
param.ovLap = .5;
param.itvFlag = 1;
param.clutMeth = 'sc';

% pca
[Tpca,~,~,~,~,~]=pca(data);
se1fil = data*Tpca(:,1);

% density
% k = 12;
% [se1fil] = log10(localDensity(data,k));

% label cca
% [A,B] = canoncorr(trainSE1,double(trLab));
% se1fil = (data-repmat(mean(trainSE1),size(data,1),1))*A;

[ G1, Wv, clusterCen ] = EnMIMA_MAPPER( data,se1fil,param );


% se2 graph
data = se2Data;

% pca
[Tpca,~,~,~,~,~]=pca(data);
se2fil = data*Tpca(:,1);

% density
% [se2fil] = log10(localDensity(data,k));

% label cca
% [A,B] = canoncorr(trainSE2,double(trLab));
% se2fil = (data-repmat(mean(trainSE2),size(data,1),1))*A;
% se2fil = log10(se2fil-min(se2fil(:))+1);

[ G2, Wv, clusterCen ] = EnMIMA_MAPPER( data,se2fil,param );


% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% construct two graphs
T = blkdiag(G1,G2);
S = zeros(size(T));

S(1:length(trLab),1:length(trLab)) = G_sup;
S(1:length(trLab),size(G1,2)+1:size(G1,2)+length(trLab)) = G_sup;
S(size(G1,1)+1:size(G1,1)+length(trLab),1:length(trLab)) = G_sup;
S(size(G1,1)+1:size(G1,1)+length(trLab),size(G1,2)+1:size(G1,2)+length(trLab)) = G_sup;


% T(1:length(trLab),1:length(trLab)) = 0;
% T(size(G1,1)+1:size(G1,1)+length(trLab),size(G1,2)+1:size(G1,2)+length(trLab)) = 0;

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


data = blkdiag(se1Data,se2Data);


% #########################################################################
% Construct diagonal weight matrix
Dt = diag(sum(T));
Ds = diag(sum(S));
% Compute Laplacian
Lt = Dt - T;
Ls = Ds - S;


Lt(isnan(Lt)) = 0; Dt(isnan(Dt)) = 0;
Lt(isinf(Lt)) = 0; Dt(isinf(Dt)) = 0;
Ls(isnan(Ls)) = 0; Ds(isnan(Ds)) = 0;
Ls(isinf(Ls)) = 0; Ds(isinf(Ds)) = 0;

% Compute XDX and XLX and make sure these are symmetric
disp('Computing low-dimensional embedding...');
DP = data' * (Dt + Ds) * data;
LP = data' * (Lt + Ls) * data;
DP = (DP + DP') / 2;
LP = (LP + LP') / 2;

% options.disp = 0;
% options.issym = 1;
% options.isreal = 1;
% [eigvector, eigvalue] = eigs(LP, DP, size(data,2), 'sa', options);
[eigvector, eigvalue] = eigs(LP, DP, size(data,2), 'sa');

% Sort eigenvalues in descending order and get smallest eigenvectors
[eigvalue, ind] = sort(diag(eigvalue), 'ascend');
eigvector = eigvector(:,ind(1:size(data,2)));

% Compute final linear basis and map data
mappedXTmp = data * eigvector;  
mappedX = cat(2,mappedXTmp(1:size(se1Data,1),1:40),mappedXTmp(size(se1Data,1)+1:end,1:40));

% #########################################################################
disp('Random forest classification ...');
trainFeat = mappedX(1:size(trainSE1,1),:);
testFeat = mappedX(size(trainSE1,1)+1:end,:); 

NumTrees = 100;
rng(1); % For reproducibility
Mdl_rf = TreeBagger(NumTrees,trainFeat,trLab,'OOBPredictorImportance','on');
% testing
[predLab,scoresSE1] = predict(Mdl_rf,testFeat);
predLab = cellfun(@str2double,predLab);
[ M,oa_mima,pa,ua,ka ] = confusionMatrix(double(teLab),predLab);
oa_mima

