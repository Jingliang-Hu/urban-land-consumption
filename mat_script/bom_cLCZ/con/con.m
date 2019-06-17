restoredefaultpath
addpath(genpath('/data/hu/SDG'));

%% directory setting
se1dir = '/data/hu/SDG/data/BOM/SE1/S1A_IW_SLC__1SDV_20170606T010243_20170606T010310_016906_01C214_AEC6_Orb_Cal_Deb_Spk_TC_SUB.tif';
se2dir = '/data/hu/SDG/data/BOM/SE2/21206_autumn.tif';
labdir = '/data/hu/SDG/data/BOM/GT/mumbai_cLCZ.tif';
patchSize = 0;

%% feature extraction
% [ se1Feat ] = sen1FeatExtract( se1dir );
load('/data/hu/SDG/data/BOM/tmpData/sen1Feature.mat')
SE1tmp = reshape(se1Feat,size(se1Feat,1)*size(se1Feat,2),size(se1Feat,3));
% [ se2Feat ] = sen2FeatExtract( se2dir );
load('/data/hu/SDG/data/BOM/tmpData/sen2Feature.mat')
SE2tmp = reshape(se2Feat,size(se2Feat,1)*size(se2Feat,2),size(se2Feat,3));


%% load training and testing label
[ labCoord, lab ] = getShareCoordinate( labdir,se1dir,se2dir,patchSize );
se1LabIdx = sub2ind(size(se1Feat(:,:,1)),labCoord(:,3),labCoord(:,4));
se2LabIdx = sub2ind(size(se2Feat(:,:,1)),labCoord(:,5),labCoord(:,6));

se1Observ = SE1tmp(se1LabIdx,:);
se1Observ(:,[1:21,29:31,33:35]) = log10(se1Observ(:,[1:21,29:31,33:35]));
se2Observ = SE2tmp(se2LabIdx,:);

observ = zscore(cat(2,se1Observ,se2Observ));
nbFeatSE1 = size(se1Observ,2);
%% parameters for training and testing separation
trainPerc = 0.1;
[ trainIdx,testIdx ] = nFoldsDataSampleBlockEqual( lab,trainPerc );
nfolds = size(trainIdx,2);


%% set the percentage of training samples
trainPercArray = [...
    ones(1,1),zeros(1,9);...% 10%
    ones(1,5),zeros(1,5);...% 50%
    ones(1,9),zeros(1,1)... % 90%
    ]==1;

for cv_trPerc = 1:size(trainPercArray,1)
    trainPerc = trainPercArray(cv_trPerc,:);


    %% n folds classification with random forest
    M = cell(nfolds,1);
    oa = zeros(nfolds,1);
    kappa = zeros(nfolds,1);
    Mdl_rf = cell(nfolds,1);
    NumTrees = 100;


    % loop for n folds
    for cv_fold = 1:nfolds
        %% get the data
        trainPercTmp = circshift(trainPerc,cv_fold-1);
        trIndex = sum(trainIdx(:,trainPercTmp),2)>0;

        trLab = lab(trIndex);
        teLab = lab(~trIndex);

        trainfeat = observ( trIndex,:);
        testfeat  = observ(~trIndex,:);
        

        % training
        rng(1); % For reproducibility
        Mdl_rf{cv_fold} = TreeBagger(NumTrees,trainfeat,trLab,'OOBPredictorImportance','on');
        % testing
        [predLab,scores] = predict(Mdl_rf{cv_fold},testfeat);
        predLab = cellfun(@str2double,predLab);
        [ M{cv_fold},oa(cv_fold),pa,ua,kappa(cv_fold) ] = confusionMatrix(double(teLab),predLab);
        oa
    end

    save(['con_xv_trp_',num2str(sum(trainPerc*10))],'oa','M','kappa','Mdl_rf','trainIdx','testIdx','labCoord','lab','observ','nbFeatSE1','NumTrees','-v7.3')

end
