%% feature extraction from EnMAP data
hsiFeatExtractionBerlin

%% CLASSIFICATION
claFeat = reshape(optFeat,size(optFeat,1)*size(optFeat,2),size(optFeat,3));

trainFeat = claFeat(trainMap(:)>0,:);
trainLab = trainMap(trainMap(:)>0);

testFeat = claFeat(testMap(:)>0,:);
testLab = testMap(testMap(:)>0);


%% rf
rng(1); % For reproducibility
NumTrees = 40;
Mdl_rf = TreeBagger(NumTrees,trainFeat,trainLab);
predLab = predict(Mdl_rf,testFeat);
predLab = cellfun(@str2double,predLab);
[ M,oa,pa,ua,kappa ] = confusionMatrix(testLab,predLab);


