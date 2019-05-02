restoredefaultpath
addpath(genpath('/data/hu/SDG'));


%% loading data
loadData


%% Similarity matrix
tmp = cat(1,trLab,zeros(length(teLab),1),trLab,zeros(length(teLab),1));
S = repmat(tmp,1,length(tmp))==repmat(tmp',length(tmp'),1);
S(tmp==0,:) = 0;

%% Dissimilarity matrix
D = ~S;
D(tmp==0,:) = 0;
D(:,tmp==0) = 0;

nbBin = 10:10:30;
ovLap = .5:.2:.9;

se1Data = cat(1,trainSE1,testSE1);
se2Data = cat(1,trainSE2,testSE2);

T_ul = cell(length(nbBin),length(ovLap));
T_br = cell(length(nbBin),length(ovLap));
Wv_ul = cell(length(nbBin),length(ovLap));
Wv_br = cell(length(nbBin),length(ovLap));

map1 = cell(numel(T_ul),numel(T_br));
map2 = cell(numel(T_ul),numel(T_br));
Mdl_rf = cell(numel(T_ul),numel(T_br));
M = cell(numel(T_ul),numel(T_br));
oa = zeros(numel(T_ul),numel(T_br));



%% data processing
se1roi = se1Data;
se2roi = se2Data;
% SE1 magnitude difference --- dB
for i = 1:size(se1roi,2)
    % step 1. non-negative
    se1roi(:,i) = se1roi(:,i) - min(se1roi(:,i))+1;
    % step 2. dB
    se1roi(:,i) = 10*log10(se1roi(:,i));
end
% SE1 bands extrime value --- histogram cut
for i = 1:size(se1roi,2)
    tmp = se1roi(:,i);
    thres = quantile(tmp,[0.01,0.99]);
    tmp(tmp>thres(2)) = thres(2);
    tmp(tmp<thres(1)) = thres(1);
    se1roi(:,i) = tmp;
end
% SE1 bands value unbalanced --- mean-std normalization
se1roi = zscore(se1roi);
% SE2 bands extrime value --- histogram cut
for i = 1:size(se2roi,2)
    tmp = se2roi(:,i);
    thres = quantile(tmp,[0.01,0.99]);
    tmp(tmp>thres(2)) = thres(2);
    tmp(tmp<thres(1)) = thres(1);
    se2roi(:,i) = tmp;
end
% SE2 bands value unbalanced --- mean-std normalization
se2roi = zscore(se2roi);


[~,~,~,U,V,~] = canoncorr(se1roi,se2roi) ;


for cv_bin = 1:length(nbBin)
    for cv_ovl = 1:length(ovLap)
    %% Topology matrix
    [ T_ul{cv_bin,cv_ovl}, Wv_ul{cv_bin,cv_ovl} ] = MIMA_MAPPER_EN_CCA_MS( se1Data,nbBin(cv_bin),ovLap(cv_ovl),U(:,1) );
    [ T_br{cv_bin,cv_ovl}, Wv_br{cv_bin,cv_ovl} ] = MIMA_MAPPER_EN_CCA_MS( se2Data,nbBin(cv_bin),ovLap(cv_ovl),V(:,1) );
    end
end

Z = [se1Data',zeros(size(se1Data,2),size(se2Data,1));zeros(size(se2Data,2),size(se1Data,1)),se2Data'];
mu = 1;

scores = zeros(size(testSE2,1),length(unique(teLab)));

for cv_ul = 1:numel(T_ul)
    for cv_br = 1:numel(T_br)

    T = [T_ul{cv_ul},zeros(size(T_ul{cv_ul},1),size(T_br{cv_br},2));zeros(size(T_ul{cv_ul},2),size(T_br{cv_br},1)),T_br{cv_br}];
    T = T.*(~(S+D));
    T(eye(size(T))==1) = 0;

    [ map1{cv_ul,cv_br},map2{cv_ul,cv_br} ] = mani_version_2( S,D,T,Z,mu,size(se1Data,2),size(se2Data,2) );

    %% classification with random forest
    se1DataProj = se1Data * map1{cv_ul,cv_br};
    se2DataProj = se2Data * map2{cv_ul,cv_br};

    feat = cat(2,se1DataProj,se2DataProj);            

    trainFeat = feat(1:size(trainSE1,1),:);
    testFeat = feat(size(trainSE1,1)+1:end,:);

    % training
    rng(1); % For reproducibility
    NumTrees = 40;
    Mdl_rf{cv_ul,cv_br} = TreeBagger(NumTrees,trainFeat,trLab,'OOBPredictorImportance','on');

    % testing
    [predLab,scoresTmp] = predict(Mdl_rf{cv_ul,cv_br},testFeat);
    scores = scores + scoresTmp;
    predLab = cellfun(@str2double,predLab);
    [ M{cv_ul,cv_br},oa(cv_ul,cv_br),pa,ua,ka(cv_ul,cv_br) ] = confusionMatrix(double(teLab),predLab);

    end
end

scores = scores./(numel(T_ul)*numel(T_br));

[~,pred] = max(scores,[],2);
idCla = cellfun(@str2double,Mdl_rf{1}.ClassNames);
for i = 1:length(idCla)
	pred(pred==i) = idCla(i);
end
[Me,oae,pae,uae,kae] = confusionMatrix(double(teLab),pred)



save('mima_en_cca_ms_process','M','oa','nbBin','ovLap','T_ul','T_br','Wv_ul','Wv_br','map1','map2','Mdl_rf','scores','teLab','-v7.3')





