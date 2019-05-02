restoredefaultpath
enviPath = '/data/hu/sdg/mat_script';
addpath(genpath(enviPath));
tic
%% directory setting
se1dir = [enviPath,'/data/MUC/SE1/S1B_IW_SLC__1SDV_20170609T052529_20170609T052557_005969_00A798_1958_Orb_Cal_Deb_Spk_TC_SUB.tif'];
se2dir = [enviPath,'/data/MUC/SE2/204371_summer.tif'];
labdir = [enviPath,'/data/MUC/GT/munich_cLCZ.tif'];
patchSize = 0;

memoryArr = zeros(1,15);
%% feature extraction
[ se1Feat ] = sen1FeatExtract( se1dir );
memoryArr(1) = memProfile(whos,'gb');

%load('/data/hu/SDG/data/MUC/tmpData/sen1Feature_local_f.mat')
SE1tmp = reshape(se1Feat,size(se1Feat,1)*size(se1Feat,2),size(se1Feat,3)); se1FeatSize = size(se1Feat);
memoryArr(2) = memProfile(whos,'gb');
clear se1Feat
memoryArr(3) = memProfile(whos,'gb');

[ se2Feat ] = sen2FeatExtract( se2dir );
memoryArr(4) = memProfile(whos,'gb');

%load('/data/hu/SDG/data/MUC/tmpData/sen2Feature.mat')
SE2tmp = reshape(se2Feat,size(se2Feat,1)*size(se2Feat,2),size(se2Feat,3)); se2FeatSize = size(se2Feat);
memoryArr(5) = memProfile(whos,'gb');
clear se2Feat 
memoryArr(6) = memProfile(whos,'gb');


%% load data
[ labCoord, lab ] = getROICoordinate( labdir,se1dir,se2dir,patchSize );

se1LabIdx = sub2ind(se1FeatSize(1:2),labCoord(:,3),labCoord(:,4));
se2LabIdx = sub2ind(se2FeatSize(1:2),labCoord(:,5),labCoord(:,6));


se1Observ = SE1tmp(se1LabIdx,:);
se1Observ(:,[1:21,29:31,33:35]) = log10(se1Observ(:,[1:21,29:31,33:35]));
se1Observ = zscore(se1Observ); 

se2Observ = SE2tmp(se2LabIdx,:);
se2Observ = zscore(se2Observ); 
memoryArr(7) = memProfile(whos,'gb');
clear se2LabIdx se1LabIdx SE2tmp SE1tmp
memoryArr(8) = memProfile(whos,'gb');

%% organizing data
trIndex = lab>0;

trLab = lab(trIndex);

trSE1 = se1Observ( trIndex,:);
unSE1 = se1Observ(~trIndex,:);

trSE2 = se2Observ( trIndex,:);
unSE2 = se2Observ(~trIndex,:);

tms = 2;
rng(1);
[~,order] = sort(randn(size(unSE1,1),1));
unSE1 = unSE1(order(1:tms*size(trSE1,1)),:);
unSE2 = unSE2(order(1:tms*size(trSE1,1)),:);


se1Data = cat(1,trSE1,unSE1);
se2Data = cat(1,trSE2,unSE2);
memoryArr(9) = memProfile(whos,'gb');
clear order trIndex unSE1 unSE2
memoryArr(10) = memProfile(whos,'gb');

%% parameter setting
param.nbBin = 50:10:70;
param.ovLap = .3:.2:.7;
param.itvFlag = 1;
param.clutMeth = 'sc';
param.mu = 1;



 %% mima graph 
% initial graphs for topological structures of se1 and se2
W1 = cell(length(param.nbBin),length(param.ovLap));
W2 = cell(length(param.nbBin),length(param.ovLap));
inputParam = param;

% se1 filtration for mapper
[Tpca,~,~,~,~,~]=pca(se1Data);
se1fil = se1Data*Tpca(:,1);
% se2 filtration for mapper
[Tpca,~,~,~,~,~]=pca(se2Data);
se2fil = se2Data*Tpca(:,1);
% mapper graphs
for cv_bin = 1:length(param.nbBin)
    for cv_ovp = 1:length(param.ovLap)
        inputParam.nbBin = param.nbBin(cv_bin);
        inputParam.ovLap = param.ovLap(cv_ovp);        
        [ W1{cv_bin,cv_ovp}, ~, ~ ] = EnMIMA_MAPPER( se1Data,se1fil,inputParam );
        [ W2{cv_bin,cv_ovp}, ~, ~ ] = EnMIMA_MAPPER( se2Data,se2fil,inputParam );
    end
end
memoryArr(11) = memProfile(whos,'gb');
clear se1fil se2fil Tpca
memoryArr(12) = memProfile(whos,'gb');

% label similarity graph
G_sup = repmat(trLab,1,length(trLab))==repmat(trLab',length(trLab'),1);
G_sup = double(G_sup);

% similarity graph
S = zeros(2*size(W1{1}));
S(1:length(trLab),1:length(trLab)) = G_sup;
S(1:length(trLab),size(W1{1},2)+1:size(W1{1},2)+length(trLab)) = G_sup;
S(size(W1{1},1)+1:size(W1{1},1)+length(trLab),1:length(trLab)) = G_sup;
S(size(W1{1},1)+1:size(W1{1},1)+length(trLab),size(W1{1},2)+1:size(W1{1},2)+length(trLab)) = G_sup;
% similarity degree matrix
Ds = diag(sum(S));
% similarity laplacian
Ls = Ds - S; clear S
Ls(isnan(Ls)) = 0; Ds(isnan(Ds)) = 0;
Ls(isinf(Ls)) = 0; Ds(isinf(Ds)) = 0;

% data organization
data = blkdiag(se1Data,se2Data);
memoryArr(13) = memProfile(whos,'gb');
clear se1Data se2Data
memoryArr(14) = memProfile(whos,'gb');


% initial results
maps1 = cell(numel(W1),numel(W2));
maps2 = cell(numel(W1),numel(W2));
Mdl_rf = cell(numel(W1),numel(W2));
scoresTmp = zeros(size(se1Observ,1),length(unique(trLab)));
for cv_w1 = 1:numel(W1)
    G1 = W1{cv_w1};
    for cv_w2 = 1:numel(W2)
        G2 = W2{cv_w2};

        % #########################################################################
        disp('Computing graphs ...');
        % topology graph
        T = blkdiag(G1,G2);
        % topology degree matrix
        Dt = diag(sum(T));
        % topology laplacian
        Lt = Dt - T;
        Lt(isnan(Lt)) = 0; Dt(isnan(Dt)) = 0;
        Lt(isinf(Lt)) = 0; Dt(isinf(Dt)) = 0;
        % #########################################################################



        % #########################################################################
        % Compute XDX and XLX and make sure these are symmetric
        disp('Computing low-dimensional embedding...');
        DP = double(data' * (Dt + Ds) * data);
        LP = double(data' * (Lt + Ls) * data);
        DP = (DP + DP') / 2;
        LP = (LP + LP') / 2;

        
        options.disp = 0;
        options.issym = 1;
        options.isreal = 1;
        [eigvector, eigvalue] = eigs(LP, DP, size(data,2), 'sa',options);

        % Sort eigenvalues in descending order and get smallest eigenvectors
        [eigvalue, ind] = sort(diag(eigvalue), 'ascend');
        eigvector = eigvector(:,ind(1:size(data,2)));

        % Compute final linear basis and map data
        maps1{cv_w1,cv_w2} = eigvector(1:se1FeatSize(3),1:40);
        maps2{cv_w1,cv_w2} = eigvector(se1FeatSize(3)+1:end,1:40);
        % #########################################################################



        % #########################################################################
        disp('Training a random forest classifier ...');
        trainFeat = cat(2,trSE1*maps1{cv_w1,cv_w2},trSE2*maps2{cv_w1,cv_w2});
        NumTrees = 100;
        rng(1); % For reproducibility
        Mdl_rf{cv_w1,cv_w2} = TreeBagger(NumTrees,trainFeat,trLab);
        
        disp('Inferencing using random forest ...');
        testFeat = cat(2,se1Observ*maps1{cv_w1,cv_w2},se2Observ*maps2{cv_w1,cv_w2});
        % interencing
        [predLab,scores] = predict(Mdl_rf{cv_w1,cv_w2},testFeat);
        scoresTmp = scoresTmp + scores;
        predLab = cellfun(@str2double,predLab);
        % #########################################################################            
    end
end



[~,pred] = max(scoresTmp,[],2);
idCla = cellfun(@str2double,Mdl_rf{cv_w1,cv_w2}.ClassNames);
for i = 1:length(idCla)
    pred(pred==i) = idCla(i);
end

labdir = '/data/hu/SDG/data/MUC/GT/munich_cLCZ.tif';

[im,ref] = geotiffread(labdir);
info = geotiffinfo(labdir);

idxLoc = sub2ind(size(im),labCoord(:,7),labCoord(:,8));
clamap = zeros(size(im));
clamap(idxLoc) = pred;
clamap_col = label2color(clamap,'lcz');



memoryArr(15) = memProfile(whos,'gb');
toc
save('memMonitor','memoryArr')

geotiffwrite('claMap_cLCZ.tif', uint8(clamap), ref,  ...
'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

geotiffwrite('claMap_cLCZ_col.tif', uint8(clamap_col), ref,  ...
'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

save('muc_product','pred','maps1','maps2','Mdl_rf','-v7.3')


clear



