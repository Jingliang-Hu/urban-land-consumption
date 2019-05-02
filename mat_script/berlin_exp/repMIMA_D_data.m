%% load environment
clear
restoredefaultpath
addpath(genpath('D:\Matlab\SDG'))
maxNumCompThreads(6)

%% read training and testing label
load('D:\Matlab\mani\data\LCLU\groundTruth\trainAndTest.mat')
load('D:\Matlab\mani\data\LCLU\data\enmap_berlin.mat', 'mask')
testMap = double(testMap);
trainMap = trainMap2;

%% read enmap features
hsiFeatExtractionBerlin

%% enmap feature normalization
optFeat = reshape(optFeat,size(optFeat,1)*size(optFeat,2),size(optFeat,3));
HSINormData = optFeat(mask(:)==1,:);
for i = 1:size(HSINormData,2)
    HSINormData(:,i) = mat2gray(HSINormData(:,i));
end
HSIFeat = zeros(size(optFeat,1),size(HSINormData,2));
HSIFeat(mask(:)==1,:) = HSINormData;

%% read sentinel-1 feature
se1FeatExtractionBerlin

%% sentinel-1 feature normalization
polFeat = reshape(polFeat,size(trainMap,1)*size(trainMap,2),size(polFeat,3));
polNormData = polFeat(mask(:)==1,:);
for i = 1:size(polNormData,2)
    polNormData(:,i) = mat2gray(polNormData(:,i));
end
PolFeat = zeros(size(polFeat,1),size(polNormData,2));
PolFeat(mask(:)==1,:) = polNormData;

%% label and unlabel data organization
% labeled data
labeledHSIData = HSIFeat(trainMap(:)>0,:);
labeledPOLData = PolFeat(trainMap(:)>0,:);

% unlabeled data
unLabeledData = cat(2,HSIFeat,PolFeat);
unLabeledData((mask(:)==0)|(trainMap(:)>0),:) = [];
load('D:\Matlab\mani\data\LCLU\unlabelIndex\randomUnLabeledDataIndex.mat')
[~,idx] = sort(randomIdx);
nb_unlabeldata = 6000;

unLabeledData = unLabeledData(idx(1:nb_unlabeldata),:);

unLabeledHSIData = unLabeledData(:,1:size(HSIFeat,2));
unLabeledPOLData = unLabeledData(:,size(HSIFeat,2)+1:end);


%% solve the problem

%% Similarity matrix
temp = trainMap(trainMap(:)>0);
temp = cat(1,temp,zeros(size(unLabeledHSIData,1),1),temp,zeros(size(unLabeledPOLData,1),1));
S = repmat(temp,1,length(temp))==repmat(temp',length(temp'),1);
S(temp==0,:) = 0;

%% Dissimilarity matrix
D = ~S;
D(temp==0,:) = 0;
D(:,temp==0) = 0;

%% ** parameter setting **
% bin: number of bins for MAPPER
bin = 30;
% mu: the weighting parameter of topology matrix
mu = 1;
% dim: dimension of latent space
dim = 30;

%% Topology matrix
LS8Data = cat(1,labeledHSIData,unLabeledHSIData);
SE1Data = cat(1,labeledPOLData,unLabeledPOLData);

[ T_ul ] = ensembleTopo_draft1( LS8Data );
[ T_br ] = ensembleTopo_draft1( SE1Data );




param.itvFlag = 1;
param.nbBin = [20,15,20,25,10,15,20,25,10,15,20,25,30,35,40,15,20,25,30,35,40,45,50,55,60];
param.ovLap = [.5,.6,.6,.6,.7,.7,.7,.7,.8,.8,.8,.8,.8,.8,.8,.9,.9,.9,.9,.9,.9,.9,.9,.9,.9];
param.nbPairs = length(param.nbBin);        
[ T_ul ] = ensembleTopo_draft2( LS8Data,param );

param.itvFlag = 1;
param.nbBin = [20,15,20,25,10,15,20,25,10,15,20,25,30,35,40,15,20,25,30,35,40,45,50,55,60];
param.ovLap = [.5,.6,.6,.6,.7,.7,.7,.7,.8,.8,.8,.8,.8,.8,.8,.9,.9,.9,.9,.9,.9,.9,.9,.9,.9];
param.nbPairs = length(param.nbBin);        
[ T_br ] = ensembleTopo_draft2( SE1Data,param );

T = [T_ul,zeros(size(T_ul,1),size(T_br,2));zeros(size(T_ul,2),size(T_br,1)),T_br];
T = T.*(~(S+D));
T(eye(size(T))==1) = 0;

%% data organization
Z = [LS8Data',zeros(size(LS8Data,2),size(SE1Data,1));zeros(size(SE1Data,2),size(LS8Data,1)),SE1Data'];


%% solve the projection
[ map1,map2 ] = mani_version_2( S,D,T,Z,mu,size(LS8Data,2),size(SE1Data,2) );

%% project data sources into latent space
LS8FeatProj = HSIFeat * map1(:,1:dim);
SE1FeatProj = PolFeat * map2(:,1:dim);

%% CLASSIFICATION
% data normalization
feat = cat(2,LS8FeatProj,SE1FeatProj);            


% training data
trainFeat = feat(trainMap(:)>0,:);
trainLab = trainMap(trainMap(:)>0);            

% testing data
testFeat = feat(testMap(:)>0,:);
testLab = testMap(testMap(:)>0);

% random forest
rng(1); % For reproducibility
NumTrees = 40;
Mdl_rf = TreeBagger(NumTrees,trainFeat,trainLab);%,'OOBPredictorImportance','on');
predLab = predict(Mdl_rf,testFeat);
predLab = cellfun(@str2double,predLab);
[ M,oa,pa,ua,kappa ] = confusionMatrix(testLab,predLab);

oa
