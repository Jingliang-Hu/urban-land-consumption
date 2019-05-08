addpath(genpath('/data/hu/SDG'));

%% load data
load('/data/hu/SDG/bom_cLCZ/con/con_xv_trp_10.mat', 'trainIdx', 'testIdx', 'observ', 'nbFeatSE1', 'lab')
observ = double(observ);

%% parameter setting
param.nbBin = 20:10:40;
param.ovLap = .3:.2:.7;
param.itvFlag = 1;
param.clutMeth = 'sc';
param.mu = 1;

%% set the percentage of training samples
trainPercArray = [...
    ones(1,1),zeros(1,9);...% 10%
    ones(1,5),zeros(1,5);...% 50%
    ones(1,9),zeros(1,1)... % 90%
    ]==1;

for cv_trPerc = 1:1%size(trainPercArray,1)

trainPerc = trainPercArray(cv_trPerc,:);



%% n folds cross validation
for nFolds = 1:size(trainIdx,2)    
    %% get the data
    trainPercTmp = circshift(trainPerc,nFolds-1);
    trIndex = sum(trainIdx(:,trainPercTmp),2)>0;
    
    trLab = lab(trIndex);
    teLab = lab(~trIndex);

    trainSE1 = observ( trIndex,1:nbFeatSE1);
    testSE1  = observ(~trIndex,1:nbFeatSE1);

    trainSE2 = observ( trIndex,nbFeatSE1+1:size(observ,2));
    testSE2  = observ(~trIndex,nbFeatSE1+1:size(observ,2));
    
    se1Data = cat(1,trainSE1,testSE1);
    se2Data = cat(1,trainSE2,testSE2);
    
    %% data preprocessing
    % SE1 magnitude difference --- dB
    % se1Data(:,[1:21,29:31,33:35]) = log10(se1Data(:,[1:21,29:31,33:35]));
    % se1Data = zscore(se1Data);
    % se2Data = zscore(se2Data);

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
    Ls = Ds - S;
    Ls(isnan(Ls)) = 0; Ds(isnan(Ds)) = 0;
    Ls(isinf(Ls)) = 0; Ds(isinf(Ds)) = 0;
    
    % data organization
    data = blkdiag(se1Data,se2Data);
    
    
    % initial results
    oa = zeros(numel(W1),numel(W2));
    scores = zeros(length(teLab),length(unique(teLab)),numel(W1)*numel(W2));
    
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
            DP = data' * (Dt + Ds) * data;
            LP = data' * (Lt + Ls) * data;
            DP = (DP + DP') / 2;
            LP = (LP + LP') / 2;

            [eigvector, eigvalue] = eigs(LP, DP, size(data,2), 'sa');

            % Sort eigenvalues in descending order and get smallest eigenvectors
            [eigvalue, ind] = sort(diag(eigvalue), 'ascend');
            eigvector = eigvector(:,ind(1:size(data,2)));

            % Compute final linear basis and map data
            mappedXTmp = data * eigvector;  
            mappedX = cat(2,mappedXTmp(1:size(se1Data,1),1:40),mappedXTmp(size(se1Data,1)+1:end,1:40));
            % #########################################################################
            
            
            
            % #########################################################################
            disp('Random forest classification ...');
            trainFeat = mappedX(1:size(trainSE1,1),:);
            testFeat = mappedX(size(trainSE1,1)+1:end,:); 

            NumTrees = 100;
            rng(1); % For reproducibility
            Mdl_rf = TreeBagger(NumTrees,trainFeat,trLab,'OOBPredictorImportance','on');
            % testing
            [predLab,scores(:,:,(cv_w1-1)*numel(W1)+cv_w2)] = predict(Mdl_rf,testFeat);
            predLab = cellfun(@str2double,predLab);
            [ ~,oa(cv_w1,cv_w2),~,~,~ ] = confusionMatrix(double(teLab),predLab);
            % #########################################################################            
        end
    end

    
    scoresTmp = sum(scores,3);
    [~,pred] = max(scoresTmp,[],2);
    idCla = cellfun(@str2double,Mdl_rf.ClassNames);
    for i = 1:length(idCla)
        pred(pred==i) = idCla(i);
    end
    [Me,oae,pae,uae,kae] = confusionMatrix(double(teLab),pred);
    
    
    save(['mima_2t_en_pc_sc_p_trp_',num2str(sum(trainPerc)*10),'_xv_',num2str(nFolds)],'oa','param','W1','W2','Mdl_rf','scores','teLab','Me','oae','-v7.3')
    disp([num2str(nFolds),' cross validation done ...']);
    

end

end
