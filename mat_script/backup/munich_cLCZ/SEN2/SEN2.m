restoredefaultpath
addpath(genpath('/data/hu/SDG'));

%% directory setting
se1dir = '/data/hu/SDG/data/SE1/S1B_IW_SLC__1SDV_20170609T052529_20170609T052557_005969_00A798_1958_Orb_Cal_Deb_Spk_TC_SUB.tif';
se2dir = '/data/hu/SDG/data/SE2/204371_summer.tif';
trLabDir = '/data/hu/SDG/data/GT/munich_cLCZ_train.tif';
teLabDir = '/data/hu/SDG/data/GT/munich_cLCZ_test.tif';
patchSize = 0;


%% feature extraction
[ se2Feat ] = sen2FeatExtract( se2dir );


%% load training and testing label
[ trCoord, trLab ] = getShareCoordinate( trLabDir,se1dir,se2dir,patchSize );
[ teCoord, teLab ] = getShareCoordinate( teLabDir,se1dir,se2dir,patchSize );


trIdx = sub2ind(size(se2Feat(:,:,1)),trCoord(:,5),trCoord(:,6));
teIdx = sub2ind(size(se2Feat(:,:,1)),teCoord(:,5),teCoord(:,6));


SE2tmp = reshape(se2Feat,size(se2Feat,1)*size(se2Feat,2),size(se2Feat,3));
trainSE2 = SE2tmp(trIdx,:);
testSE2  = SE2tmp(teIdx,:);

%% classification with random forest
% training
rng(1); % For reproducibility
NumTrees = 40;
Mdl_rf = TreeBagger(NumTrees,trainSE2,trLab,'OOBPredictorImportance','on');

% testing
[predLab,scores] = predict(Mdl_rf,testSE2);
predLab = cellfun(@str2double,predLab);
[ M,oa,pa,ua,kappa ] = confusionMatrix(double(teLab),predLab);
oa


%% produce classification map
[ imCoord, label ] = getROICoordinate( trLabDir,se1dir,se2dir,patchSize );

idxSE2 = sub2ind(size(se2Feat(:,:,1)),imCoord(:,5),imCoord(:,6));
featSE2 = SE2tmp(idxSE2,:);

% inferencing
inference = predict(Mdl_rf,featSE2);
inference = cellfun(@str2double,inference);

[im,~] = geotiffread(trLabDir);
clamap = zeros(size(im));
idxClamap = sub2ind(size(clamap),imCoord(:,7),imCoord(:,8));
clamap(idxClamap) = inference;

save munich_clcz_sen2 M clamap Mdl_rf testSE2 scores teLab



