function [flag] = enMIMA_Workflow_One_City_lowMem(cityPath,enviPath)
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
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
disp('+++++++++++++++++++++ Setting Directories ++++++++++++++++++++++++++');
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

% temporary data file
datTmpDir = [outputDir,'/datTmp.mat'];
disp(['The temporary data file was set to: ',datTmpDir]);
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');


%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  SE1 feature extraction
if isfile(datTmpDir)
    load(datTmpDir,'OKse1Feat')
    if exist('OKse1Feat','var')
        disp('-------------------------------------------------------------');
        disp('SE1 feature extracted ...')
    else
        disp('-------------------------------------------------------------');
        disp('loading SE1 data, feature extraction ...')
        [ ~ ] = sen1FeatExtractMem( se1dir, datTmpDir);
        OKse1Feat = 1;
        save(datTmpDir,'OKse1Feat','-append')
    end
else
    disp('-------------------------------------------------------------');
    disp('loading SE1 data, feature extraction ...')
    [ ~ ] = sen1FeatExtractMem( se1dir, datTmpDir);
    OKse1Feat = 1;
    save(datTmpDir,'OKse1Feat','-append')
end


%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  SE2 feature extraction
if isfile(datTmpDir)
    load(datTmpDir,'OKse2Feat')
    if exist('OKse2Feat','var')
        disp('-------------------------------------------------------------');
        disp('SE2 feature extracted ...')
    else
        disp('-------------------------------------------------------------');
        disp('loading SE2 data, feature extraction ...')
        [ ~ ] = sen2FeatExtractMem( se2dir, datTmpDir);
        OKse2Feat = 1;
        save(datTmpDir,'OKse2Feat','-append')
    end
else
    disp('-------------------------------------------------------------');
    disp('loading SE2 data, feature extraction ...')
    [ ~ ] = sen2FeatExtractMem( se2dir, datTmpDir);
    OKse2Feat = 1;
    save(datTmpDir,'OKse2Feat','-append')
end



load(datTmpDir,'OKmodel')
if ~exist('OKmodel','var')
%% 
disp('-------------------------------------------------------------');
disp('loading locations of labeled data ...')
patchSize = 0;
[ labCoord, lab ] = getROICoordinate( labdir,se1dir,se2dir,patchSize );
trIdx = lab>0;
trLab = lab(trIdx);
%%
disp('-------------------------------------------------------------');
disp('prep SE1 data for training ...')
load(datTmpDir,'se1Feat');
se1sz = size(se1Feat);
se1Feat = reshape(se1Feat,se1sz(1)*se1sz(2),se1sz(3));
tmpIdx = sub2ind(se1sz(1:2),labCoord(:,3),labCoord(:,4));

trSE1 = se1Feat(tmpIdx( trIdx),:);
unSE1 = se1Feat(tmpIdx(~trIdx),:);clear se1Feat;
% randomly get a part of unlabeled data to avoid huge requirement on memory, randomly yet in reproductive manner
% 'tms' gives the number of times regarding the number of unlabeled data comparing to the number of labeled data

tms = 1;
rng(1);
[~,order] = sort(randn(size(unSE1,1),1));
unSE1 = unSE1(order(1:tms*size(trSE1,1)),:);

%%
disp('-------------------------------------------------------------');
disp('prep SE2 data for training ...')
load(datTmpDir,'se2Feat');
se2sz = size(se2Feat);
se2Feat = reshape(se2Feat,se2sz(1)*se2sz(2),se2sz(3));
tmpIdx = sub2ind(se2sz(1:2),labCoord(:,5),labCoord(:,6));
save(datTmpDir,'labCoord','lab','labdir','se1dir','se2dir','-append')


trSE2 = se2Feat(tmpIdx( trIdx),:);
unSE2 = se2Feat(tmpIdx(~trIdx),:);clear se2Feat;

% randomly get a part of unlabeled data to avoid huge requirement on memory, randomly yet in reproductive manner
% 'tms' gives the number of times regarding the number of unlabeled data comparing to the number of labeled data
unSE2 = unSE2(order(1:tms*size(trSE1,1)),:);



% re-organizing sentinel-1 and sentinel-2 data
se1Data = cat(1,trSE1,unSE1);
se2Data = cat(1,trSE2,unSE2);
clear order trIdx unSE1 unSE2


%% EnMIMA
disp('-------------------------------------------------------------');
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
disp('Sentinel-1 data filtration')
[Tpca,~,~,~,~,~]=pca(se1Data);
se1fil = se1Data*Tpca(:,1);
% se2 filtration for mapper
disp('Sentinel-2 data filtration')
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
OKmodel = 1;
save(datTmpDir,'maps1','maps2','Mdl_rf','OKmodel','-append')
clearvars -except datTmpDir cityPath
else
disp('-------------------------------------------------------------');
disp('models have already been trained')
end


load(datTmpDir,'OKclaMap')
if ~exist('OKclaMap','var')
    [flag] = enMIMA_Inference(datTmpDir);
%elseif OKclaMap == 1
%    colStartPoint = 1;
%    save(datTmpDir,'colStartPoint','-append')
%    [flag] = enMIMA_Inference(datTmpDir);
    system(['touch ',cityPath,'/OK.finish'])

else
    system(['touch ',cityPath,'/OK.finish'])
    disp('-------------------------------------------------------------');
    disp('Classification map has already been produced')
end

end

