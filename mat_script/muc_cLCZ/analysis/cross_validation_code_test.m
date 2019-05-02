addpath(genpath('/data/hu/SDG'));

%% load data
load('/data/hu/SDG/munich_cLCZ_perc/con/con_xv.mat', 'trainIdx', 'testIdx', 'observ', 'nbFeatSE1', 'lab')
observ = double(observ);

%% parameter setting
param.nbBin = 20:10:40;
param.ovLap = .3:.2:.7;
param.itvFlag = 1;
param.clutMeth = 'sc';
param.mu = 1;




%% n folds cross validation
trainPerc = [ones(1,1),zeros(1,9)] == 1; % 10 percent
trainPerc = [ones(1,5),zeros(1,5)] == 1; % 50 percent
trainPerc = [ones(1,9),zeros(1,1)] == 1; % 90 percent


for nFolds = 1:size(trainIdx,2)
    %% get the data
    trainPercTmp = circshift(trainPerc,nFolds-1);
    trIndex = sum(trainIdx(:,trainPercTmp),2)>0;
    
    trLabt = lab(trIndex);
    teLabt = lab(~trIndex);

    trainSE1t = observ( trIndex,1:nbFeatSE1);
    testSE1t  = observ(~trIndex,1:nbFeatSE1);

    trainSE2t = observ( trIndex,nbFeatSE1+1:size(observ,2));
    testSE2t  = observ(~trIndex,nbFeatSE1+1:size(observ,2));

    
    
    
    
    
    %% get the data
    trLab = lab(trainIdx(:,nFolds));
    teLab = lab( testIdx(:,nFolds));

    trainSE1 = observ(trainIdx(:,nFolds),1:nbFeatSE1);
    testSE1  = observ( testIdx(:,nFolds),1:nbFeatSE1);

    trainSE2 = observ(trainIdx(:,nFolds),nbFeatSE1+1:size(observ,2));
    testSE2  = observ( testIdx(:,nFolds),nbFeatSE1+1:size(observ,2));
    
    
    %% check
    disp('############################################')
    disp([num2str(nFolds),' cross validation done ...']);
    disp(['Checking trLab   : ',num2str(sum(trLab(:)-trLabt(:)))]);
    disp(['Checking teLab   : ',num2str(sum(teLab(:)-teLabt(:)))]);
    
    disp(['Checking trainSE1: ',num2str(sum(trainSE1(:)-trainSE1t(:)))]);
    disp(['Checking testSE1 : ',num2str(sum(testSE1(:)-testSE1t(:)))]);
    
    disp(['Checking trainSE2: ',num2str(sum(trainSE2(:)-trainSE2t(:)))]);
    disp(['Checking testSE2 : ',num2str(sum(testSE2(:)-testSE2t(:)))]);
end