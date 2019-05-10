restoredefaultpath
addpath(genpath('/data/hu/SDG'));


%% directory setting
se1dir = '/data/hu/SDG/data/SE1/S1B_IW_SLC__1SDV_20170609T052529_20170609T052557_005969_00A798_1958_Orb_Cal_Deb_Spk_TC_SUB.tif';
se2dir = '/data/hu/SDG/data/SE2/204371_summer.tif';
trLabDir = '/data/hu/SDG/data/GT/munich_cLCZ_train.tif';
teLabDir = '/data/hu/SDG/data/GT/munich_cLCZ_test.tif';
patchSize = 0;


%% feature extraction
% [ se1Feat ] = sen1FeatExtract( se1dir );
load('/data/hu/SDG/munich_cLCZ/tmpData/sen1Feature_local_f.mat')
% [ se2Feat ] = sen2FeatExtract( se2dir );
load('/data/hu/SDG/munich_cLCZ/tmpData/sen2Feature.mat')

%% load training and testing label
[ trCoord, trLab ] = getShareCoordinate( trLabDir,se1dir,se2dir,patchSize );
[ teCoord, teLab ] = getShareCoordinate( teLabDir,se1dir,se2dir,patchSize );


trIdxSE1 = sub2ind(size(se1Feat(:,:,1)),trCoord(:,3),trCoord(:,4));
teIdxSE1 = sub2ind(size(se1Feat(:,:,1)),teCoord(:,3),teCoord(:,4));

SE1tmp = reshape(se1Feat,size(se1Feat,1)*size(se1Feat,2),size(se1Feat,3));
trainSE1 = SE1tmp(trIdxSE1,:);
testSE1  = SE1tmp(teIdxSE1,:);


trIdxSE2 = sub2ind(size(se2Feat(:,:,1)),trCoord(:,5),trCoord(:,6));
teIdxSE2 = sub2ind(size(se2Feat(:,:,1)),teCoord(:,5),teCoord(:,6));

SE2tmp = reshape(se2Feat,size(se2Feat,1)*size(se2Feat,2),size(se2Feat,3));
trainSE2 = SE2tmp(trIdxSE2,:);
testSE2  = SE2tmp(teIdxSE2,:);





