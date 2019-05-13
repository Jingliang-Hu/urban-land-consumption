function [flag] = enMIMA_Workflow_One_City_1(cityPath,enviPath)
% This function implements the ensemble mima for the land cover land use
% classification.
%   Input:
%       - cityPath      -   a directory to a folder, where has three
%                           subfolders: SE1, SE2, and GT, which contain a 
%                           geotiff file of Sentinel-1, Sentinel-2, and
%                           ground truth, respectively.
%       - enviPath      -   a path to a firectory, where lib are stored. 
%                           '/<directory to git local repo>/mat_script'
%
%   Output:
%       - flag          -   '0' failed
%                           '1' successed: results are saved in the ouput
%                           directory;



%% setting the environmental path
addpath(genpath(enviPath));
flag = 0;

%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% directory setting
% directory to Sentinel-1 analysis-ready data in GEOTIFF data format
se1dir = [cityPath,'/SE1/*.tif'];
fileName = dir(se1dir);
if isempty(fileName)
    disp('The Sentinel-1 GEOTIFF data does not exist!');
    return
elseif length(fileName)~=1
    disp('More than one Sentinel-1 GEOTIFF data exist');
    return
else
    se1dir = [fileName.folder,'/',fileName.name];
    disp(['The directory to Sentinel-1 data: ',se1dir]);
end
% directory to Sentinel-2 analysis-ready data in GEOTIFF data format
se2dir = [cityPath,'/SE2/*.tif'];
fileName = dir(se2dir);
if isempty(fileName)
    disp('The Sentinel-2 GEOTIFF data does not exist!');
    return
elseif length(fileName)~=1
    disp('More than one Sentinel-2 GEOTIFF data exist');
    return
else
    se2dir = [fileName.folder,'/',fileName.name];
    disp(['The directory to Sentinel-2 data: ',se2dir]);
end
% directory to label data in GEOTIFF data format
labdir = [cityPath,'/GT/*.tif'];
fileName = dir(labdir);
if isempty(fileName)
    disp('The ground truth GEOTIFF data does not exist!');
    return
elseif length(fileName)~=1
    disp('More than one ground truth GEOTIFF data exist');
    return
else
    labdir = [fileName.folder,'/',fileName.name];
    disp(['The directory to ground truth GEOTIFF data: ',labdir]);
end
% directory to the output files
outputDir = [cityPath,'/OUTPUT'];
if ~isfolder(outputDir)
    mkdir(outputDir);
end
disp(['The output directory was set to: ',outputDir]);

%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
patchSize = 0;


%% -------------------------------------------------------------
%% STEP ONE: Find data with labels
disp('-------------------------------------------------------------');
disp(' Find locations of labeled data ...')
%% -------------------------------------------------------------
% load data the geolocation, sentinel-1 image location, and sentinel-2 image location of labeled data
[ labCoord, lab ] = getROICoordinate( labdir,se1dir,se2dir,patchSize );

%% -------------------------------------------------------------
%% STEP TOW: feature extraction of Sentinel-1 data
disp('-------------------------------------------------------------');
disp('loading SE1 data, feature extraction ...')
%% -------------------------------------------------------------
% feature extraction for sentinel-1
[ se1Feat ] = sen1FeatExtract( se1dir );
se1sz = size(se1Feat);
se1LabIdx = sub2ind(se1sz(1:2),labCoord(:,3),labCoord(:,4));
SE1tmp = reshape(se1Feat,se1sz(1)*se1sz(2),se1sz(3)); 
clear se1Feat

% Sentinel-1 data preprocessing, dB scaling and mean-std normalization
SE1tmp(:,[1:21,29:31,33:35]) = log10(SE1tmp(:,[1:21,29:31,33:35]));
SE1tmp = zscore(SE1tmp);
se1Observ = SE1tmp(se1LabIdx,:);

% load SE1 data for inferencing and save it into temperary data file
SE1tmp = reshape(SE1tmp,se1sz(1),se1sz(2),se1sz(3));
SE1PredOb = SE1tmp(labCoord(1,3):labCoord(end,3),labCoord(1,4):labCoord(end,4),:);
clear SE1tmp se1LabIdx
save([outputDir,'/datTmp.mat'],'SE1PredOb','labCoord','se1dir','-v7.3');
clear SE1PredOb
disp('loading SE1 data, DONE')


%% -------------------------------------------------------------
%% STEP Three: feature extraction of Sentinel-2 data
disp('-------------------------------------------------------------');
disp('loading SE2 data, feature extraction ...')
%% -------------------------------------------------------------
% feature extraction for sentinel-2
[ se2Feat ] = sen2FeatExtract( se2dir );
se2sz = size(se2Feat);
se2LabIdx = sub2ind(se2sz(1:2),labCoord(:,5),labCoord(:,6));
SE2tmp = reshape(se2Feat,se2sz(1)*se2sz(2),se2sz(3)); 
clear se2Feat 

% Sentinel-2 data preprocessing, mean-std normalization
SE2tmp = zscore(SE2tmp);
se2Observ = SE2tmp(se2LabIdx,:);

% load SE2 data for inferencing and save it into temperary data file
SE2tmp = reshape(SE2tmp,se2sz(1),se2sz(2),se2sz(3)); 
SE2PredOb = SE2tmp(labCoord(1,5):labCoord(end,5),labCoord(1,6):labCoord(end,6),:);
clear se2LabIdx SE2tmp
save([outputDir,'/datTmp.mat'],'SE2PredOb','-append')
clear SE2PredOb
disp('loading SE2 data, DONE')


%% -------------------------------------------------------------
%% STEP FOUR: MIMA data organization
disp('-------------------------------------------------------------');
disp(' MIMA data organization ...')
%% -------------------------------------------------------------

% get the index of all data with label
trIndex = lab>0;
% get the label of labeled data
trLab = lab(trIndex);
% get the labeled and unlabeled setinel-1 data
trSE1 = se1Observ( trIndex,:);
unSE1 = se1Observ(~trIndex,:);
% get the labeled and unlabeled setinel-2 data
trSE2 = se2Observ( trIndex,:);
unSE2 = se2Observ(~trIndex,:);

% randomly get a part of unlabeled data to avoid huge requirement on memory, randomly yet in reproductive manner
% 'tms' gives the number of times regarding the number of unlabeled data comparing to the number of labeled data
tms = 2;
rng(1);
[~,order] = sort(randn(size(unSE1,1),1));
unSE1 = unSE1(order(1:tms*size(trSE1,1)),:);
unSE2 = unSE2(order(1:tms*size(trSE1,1)),:);

% re-organizing sentinel-1 and sentinel-2 data
se1Data = cat(1,trSE1,unSE1);
se2Data = cat(1,trSE2,unSE2);
clear order trIndex unSE1 unSE2


%% -------------------------------------------------------------
% STEP FIVE: EnMIMA
%% -------------------------------------------------------------
disp('Extracting MIMA topological structure ...')
% ++++++++++++++++++++++++++++++++++++++++++++++++++++
% EnMIMA parameter setting
% change those parameter if you know what you are doing...
param.nbBin = 50:10:70;
param.ovLap = .3:.2:.7;
param.itvFlag = 1;
param.clutMeth = 'sc';
param.mu = 1;
% ++++++++++++++++++++++++++++++++++++++++++++++++++++


% mima graph 
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
        [ wtmp, ~, ~ ] = EnMIMA_MAPPER( se1Data,se1fil,inputParam );
        W1{cv_bin,cv_ovp} = sparse(wtmp); clear wtmp
        [ wtmp, ~, ~ ] = EnMIMA_MAPPER( se2Data,se2fil,inputParam );
        W2{cv_bin,cv_ovp} = sparse(wtmp); clear wtmp
    end
end
clear se1fil se2fil Tpca

% label similarity graph
disp('Calculating fused latent space and train random forest classifiers ...')
G_sup = repmat(trLab,1,length(trLab))==repmat(trLab',length(trLab'),1);

% similarity graph
sz = 2*size(W1{1});
S = sparse(sz(1),sz(2));
S(1:length(trLab),1:length(trLab)) = G_sup;
S(1:length(trLab),size(W1{1},2)+1:size(W1{1},2)+length(trLab)) = G_sup;
S(size(W1{1},1)+1:size(W1{1},1)+length(trLab),1:length(trLab)) = G_sup;
S(size(W1{1},1)+1:size(W1{1},1)+length(trLab),size(W1{1},2)+1:size(W1{1},2)+length(trLab)) = G_sup;
% similarity degree matrix
Ds = diag(sum(S));
Ds(isnan(Ds)) = 0;
Ds(isinf(Ds)) = 0;
% similarity laplacian
Ls = Ds - S; clear S; Ds = sparse(Ds);
Ls(isnan(Ls)) = 0; 
Ls(isinf(Ls)) = 0; 
Ls = sparse(Ls);
% data organization
data = blkdiag(se1Data,se2Data);
clear se1Data se2Data


% initial results
maps1 = cell(numel(W1),numel(W2));
maps2 = cell(numel(W1),numel(W2));
Mdl_rf = cell(numel(W1),numel(W2));

for cv_w1 = 1:numel(W1)
    G1 = W1{cv_w1};
    for cv_w2 = 1:numel(W2)
        G2 = W2{cv_w2};
	% #########################################################################
	% SOLVING TWO-TERM MIMA: A GENERALIZED EIGENVALUE DECOMPOSITIONN
        % #########################################################################
        % disp('Computing graphs ...');
        % topology graph
        T = blkdiag(G1,G2);
        % topology degree matrix
        Dt = diag(sum(T));
        Dt(isnan(Dt)) = 0;
        Dt(isinf(Dt)) = 0;
        % topology laplacian
        Lt = Dt - T; clear T;
        Lt(isnan(Lt)) = 0; 
        Lt(isinf(Lt)) = 0; 
        % #########################################################################



        % #########################################################################
        % Compute XDX and XLX and make sure these are symmetric
        % disp('Computing low-dimensional embedding...');
        DP = double(data' * full(Dt + Ds) * data); clear Dt
        LP = double(data' * full(Lt + Ls) * data); clear Lt
        DP = (DP + DP') / 2;
        LP = (LP + LP') / 2;

        
        options.disp = 0;
        options.issym = 1;
        options.isreal = 1;
        [eigvector, eigvalue] = eigs(LP, DP, size(data,2), 'sa',options);

        % Sort eigenvalues in descending order and get smallest eigenvectors
        [~, ind] = sort(diag(eigvalue), 'ascend');
        eigvector = eigvector(:,ind(1:size(data,2)));

        % Compute final linear basis and map data
        maps1{cv_w1,cv_w2} = eigvector(1:se1sz(3),1:40);
        maps2{cv_w1,cv_w2} = eigvector(se1sz(3)+1:end,1:40);
        % #########################################################################



        % #########################################################################
        % disp('Training a random forest classifier ...');
        trainFeat = cat(2,trSE1*maps1{cv_w1,cv_w2},trSE2*maps2{cv_w1,cv_w2});
        NumTrees = 100;
        rng(1); % For reproducibility
        Mdl_rf{cv_w1,cv_w2} = TreeBagger(NumTrees,trainFeat,trLab);
        % #########################################################################            
    end
end

% save trained projections and classifiers
save([outputDir,'/datTmp.mat'],'maps1','maps2','Mdl_rf','-append')
clearvars -except outputDir
load([outputDir,'/datTmp.mat'])

SE1PredOb = reshape(SE1PredOb,size(SE1PredOb,1)*size(SE1PredOb,2),size(SE1PredOb,3));
SE2PredOb = reshape(SE2PredOb,size(SE2PredOb,1)*size(SE2PredOb,2),size(SE2PredOb,3));
scoresTmp = zeros(size(SE1PredOb,1),length(Mdl_rf{1}.ClassNames));

disp('Inferencing ...');

parpool(2)
parfor cv_m = 1:numel(maps1)
    disp(['Inferencing using the ',num2str(cv_m),' random forest ...']);
    testFeat = cat(2,SE1PredOb*maps1{cv_m},SE2PredOb*maps2{cv_m});
    % interencing
    [predLab,scores] = predict(Mdl_rf{cv_m},testFeat);
    scoresTmp = scoresTmp + scores;
end
% EnSembling classification results
[~,pred] = max(scoresTmp,[],2);
idCla = cellfun(@str2double,Mdl_rf{1}.ClassNames);
for i = 1:length(idCla)
    pred(pred==i) = idCla(i);
end
%% -------------------------------------------------------------
%% STEP FOUR: SAVE CLASSIFICATION RESULT IN GEOTIFF FORMAT
disp('saving the outputs')
%% -------------------------------------------------------------
[~,ref] = geotiffread(se1dir);
info = geotiffinfo(se1dir);

clamap = reshape(pred,labCoord(end,3)-labCoord(1,3)+1,labCoord(end,4)-labCoord(1,4)+1);
clamap_col = label2color(clamap,'lcz');

firstrow    = labCoord(1,3);
lastrow     = labCoord(end,3);
firstcol    = labCoord(1,4);
lastcol     = labCoord(end,4);

xi = [firstcol - .5, lastcol + .5];
yi = [firstrow - .5, lastrow + .5];
[xlimits, ylimits] = intrinsicToWorld(ref, xi, yi);
subR = ref;
subR.RasterSize = size(clamap);
subR.XLimWorld = sort(xlimits);
subR.YLimWorld = sort(ylimits);

geotiffwrite([outputDir,'/claMap_cLCZ.tif'], uint8(clamap), subR,  ...
'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

geotiffwrite([outputDir,'/claMap_cLCZ_col.tif'], uint8(clamap_col), subR,  ...
'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);

clear
flag = 1;
system('touch OK.finish')
end
