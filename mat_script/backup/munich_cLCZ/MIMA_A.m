restoredefaultpath
addpath(genpath('/data/hu/SDG'));


%% loading data
% loadData


%% Similarity matrix
tmp = cat(1,trLab,zeros(length(teLab),1),trLab,zeros(length(teLab),1));
S = repmat(tmp,1,length(tmp))==repmat(tmp',length(tmp'),1);
S(tmp==0,:) = 0;

%% Dissimilarity matrix
D = ~S;
D(tmp==0,:) = 0;
D(:,tmp==0) = 0;

%% Topology matrix
se1Data = cat(1,trainSE1,testSE1);
[ T_ul ] = MIMA_MAPPER_fd_A( se1Data );

se2Data = cat(1,trainSE2,testSE2);
[ T_br ] = MIMA_MAPPER_fd_A( se2Data );

T = [T_ul,zeros(size(T_ul,1),size(T_br,2));zeros(size(T_ul,2),size(T_br,1)),T_br];
T = T.*(~(S+D));
T(eye(size(T))==1) = 0;

%% solve the problem
Z = [se1Data',zeros(size(se1Data,2),size(se2Data,1));zeros(size(se2Data,2),size(se1Data,1)),se2Data'];

mu = 1;

[ map1,map2 ] = mani_version_2( S,D,T,Z,mu,size(se1Data,2),size(se2Data,2) );


%% classification with random forest
se1DataProj = se1Data * map1;
se2DataProj = se2Data * map2;

disp('')
disp('---------------------')      

feat = cat(2,se1DataProj,se2DataProj);            
for i = 1:size(feat,2)
    feat(:,i) = mat2gray(feat(:,i));
end

trainFeat = feat(1:size(trainSE1,1),:);
testFeat = feat(size(trainSE1,1)+1:end,:);


% training
rng(1); % For reproducibility
NumTrees = 40;
Mdl_rf = TreeBagger(NumTrees,trainFeat,trLab,'OOBPredictorImportance','on');

% testing
predLab = predict(Mdl_rf,testFeat);
predLab = cellfun(@str2double,predLab);
[ M,oa,pa,ua,kappa ] = confusionMatrix(double(teLab),predLab);
oa





