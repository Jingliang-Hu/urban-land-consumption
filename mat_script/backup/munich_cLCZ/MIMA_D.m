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

nbBin = 5:5:50;
ovLap = .4:.1:.9;

se1Data = cat(1,trainSE1,testSE1);
se2Data = cat(1,trainSE2,testSE2);

T_ul = cell(length(nbBin),length(ovLap));
T_br = cell(length(nbBin),length(ovLap));
Wv_ul = cell(length(nbBin),length(ovLap));
Wv_br = cell(length(nbBin),length(ovLap));
oa = zeros(length(nbBin),length(ovLap));
ka = zeros(length(nbBin),length(ovLap));

for cv_bin = 1:length(nbBin)
    for cv_ovl = 1:length(ovLap)
%% Topology matrix
[ T_ul{cv_bin,cv_ovl}, Wv_ul{cv_bin,cv_ovl} ] = MIMA_MAPPER_analysis( se1Data,nbBin(cv_bin),ovLap(cv_ovl) );
[ T_br{cv_bin,cv_ovl}, Wv_br{cv_bin,cv_ovl} ] = MIMA_MAPPER_analysis( se2Data,nbBin(cv_bin),ovLap(cv_ovl) );


T = [T_ul{cv_bin,cv_ovl},zeros(size(T_ul{cv_bin,cv_ovl},1),size(T_br{cv_bin,cv_ovl},2));zeros(size(T_ul{cv_bin,cv_ovl},2),size(T_br{cv_bin,cv_ovl},1)),T_br{cv_bin,cv_ovl}];
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
[ M,oa(cv_bin,cv_ovl),pa,ua,ka(cv_bin,cv_ovl) ] = confusionMatrix(double(teLab),predLab);
oa



    end
end

save mima_para_analysis oa ka nbBin ovLap T_ul T_br Wv_ul Wv_br 





