%% feature extraction from sentinel-1 data
se1FeatExtractionBerlin

%% CLASSIFICATION
claFeat = reshape(polFeat,size(trainMap,1)*size(trainMap,2),size(polFeat,3));

trainFeat = claFeat(trainMap(:)>0,:);
trainLab = trainMap(trainMap(:)>0);

testFeat = claFeat(testMap(:)>0,:);
testLab = testMap(testMap(:)>0);

%% rf
rng(1); % For reproducibility
NumTrees = 40;
Mdl_rf = TreeBagger(NumTrees,trainFeat,trainLab,'OOBPredictorImportance','on');
figure,bar(Mdl_rf.OOBPermutedVarDeltaError)
predLab = predict(Mdl_rf,testFeat);
predLab = cellfun(@str2double,predLab);
[ M,oa,pa,ua,kappa ] = confusionMatrix(testLab,predLab);






