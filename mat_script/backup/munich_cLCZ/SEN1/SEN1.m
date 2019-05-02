restoredefaultpath
addpath(genpath('/data/hu/SDG'));

%% directory setting
se1dir = '/data/hu/SDG/data/SE1/S1B_IW_SLC__1SDV_20170609T052529_20170609T052557_005969_00A798_1958_Orb_Cal_Deb_Spk_TC_SUB.tif';
se2dir = '/data/hu/SDG/data/SE2/204371_summer.tif';
trLabDir = '/data/hu/SDG/data/GT/munich_cLCZ_train.tif';
teLabDir = '/data/hu/SDG/data/GT/munich_cLCZ_test.tif';
patchSize = 0;


%% feature extraction
%[ se1Feat ] = sen1FeatExtract( se1dir );
load('/data/hu/SDG/munich_cLCZ/tmpData/sen1Feature_local_f.mat')

%% load training and testing label
[ trCoord, trLab ] = getShareCoordinate( trLabDir,se1dir,se2dir,patchSize );
[ teCoord, teLab ] = getShareCoordinate( teLabDir,se1dir,se2dir,patchSize );


trIdx = sub2ind(size(se1Feat(:,:,1)),trCoord(:,3),trCoord(:,4));
teIdx = sub2ind(size(se1Feat(:,:,1)),teCoord(:,3),teCoord(:,4));


SE1tmp = reshape(se1Feat,size(se1Feat,1)*size(se1Feat,2),size(se1Feat,3));
trainSE1 = SE1tmp(trIdx,:);
testSE1  = SE1tmp(teIdx,:);

%% classification with random forest
% training
rng(1); % For reproducibility
NumTrees = 40;
Mdl_rf = TreeBagger(NumTrees,trainSE1,trLab,'OOBPredictorImportance','on');

% testing
[predLab,scores] = predict(Mdl_rf,testSE1);
predLab = cellfun(@str2double,predLab);
[ M,oa,pa,ua,kappa ] = confusionMatrix(double(teLab),predLab);
oa

%% produce classification map
[ imCoord, label ] = getROICoordinate( trLabDir,se1dir,se2dir,patchSize );

idxSE1 = sub2ind(size(se1Feat(:,:,1)),trCoord(:,3),trCoord(:,4));
featSE1 = SE1tmp(idxSE1,:);

% inferencing
inference = predict(Mdl_rf,featSE1);
inference = cellfun(@str2double,inference);

[im,~] = geotiffread(trLabDir);
clamap = zeros(size(im));
idxClamap = sub2ind(size(clamap),trCoord(:,7),trCoord(:,8));
clamap(idxClamap) = inference;

% % save munich_clcz_sen1 M clamap Mdl_rf testSE1 teLab scores



