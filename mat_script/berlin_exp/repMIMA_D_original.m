restoredefaultpath
addpath(genpath('D:\Matlab\mani'));

maxNumCompThreads(6)

%% read training and testing label
load('D:\Matlab\mani\data\LCLU\groundTruth\trainAndTest.mat')
load('D:\Matlab\mani\data\LCLU\data\enmap_berlin.mat', 'mask')
testMap = double(testMap);


%% training map selection
trainMap = trainMap2;

%% read enmap features
load('D:\Matlab\mani\data\LCLU\data\enmap_berlin.mat', 'hsi_up_mask')
EnMapFeat = hsi_up_mask; clear hsi_up_mask

HSIFeat = reshape(EnMapFeat,size(trainMap,1)*size(trainMap,2),size(EnMapFeat,3));
hsiNormData = HSIFeat(mask(:)==1,:);
for i = 1:size(hsiNormData,2)
    hsiNormData(:,i) = mat2gray(hsiNormData(:,i));
end
hsiNormData = pca_dr(hsiNormData);
HSIFeat = zeros(size(HSIFeat,1),size(hsiNormData,2));
HSIFeat(mask(:)==1,:) = hsiNormData;


HSIFeat = reshape(HSIFeat,size(trainMap,1),size(trainMap,2),size(HSIFeat,2));

r1 = 1:3;
r2 = r1;
options = 'MPr';
temp=[];
for i=1:size(HSIFeat,3)
   MPNeachpca = Make_Morphology_profile(HSIFeat(:,:,i),r1,r2,options);
   temp = cat(3,temp,MPNeachpca);
end

temp = reshape(temp,size(temp,1)*size(temp,2),size(temp,3));

HSINormData = temp(mask(:)==1,:);
for i = 1:size(HSINormData,2)
    HSINormData(:,i) = mat2gray(HSINormData(:,i));
end
HSIFeat = zeros(size(temp,1),size(HSINormData,2));
HSIFeat(mask(:)==1,:) = HSINormData;


%% read sentinel-1 feature
load('D:\Matlab\mani\data\LCLU\data\sentinel1_berlin_C.mat', 'C')
coh = sqrt(C(:,:,3).^2+C(:,:,4).^2)./sqrt(C(:,:,1).*C(:,:,2));
ratio = (C(:,:,1)./C(:,:,2));
PolFeat = cat(3,C(:,:,1:2),ratio,coh);
% statistics
[ featMean ] = localStat( PolFeat,5,'mean' );
[ featStd ]  = localStat( PolFeat,5,'std' );

r1 = 1:3;
r2 = r1;
options = 'MPr';
temp=[];
for i=1:size(PolFeat,3)
   MPNeachpca = Make_Morphology_profile(PolFeat(:,:,i),r1,r2,options);
   temp = cat(3,temp,MPNeachpca);        
end

temp = cat(3,temp,featMean,featStd);
temp = reshape(temp,size(trainMap,1)*size(trainMap,2),size(temp,3));


polNormData = temp(mask(:)==1,:);
for i = 1:size(polNormData,2)
    polNormData(:,i) = mat2gray(polNormData(:,i));
end
PolFeat = zeros(size(temp,1),size(polNormData,2));
PolFeat(mask(:)==1,:) = polNormData;



%% label and unlabel data organization
% labeled data
labeledHSIData = HSIFeat(trainMap(:)>0,:);
labeledPOLData = PolFeat(trainMap(:)>0,:);

% unlabeled data
unLabeledData = cat(2,HSIFeat,PolFeat);
unLabeledData((mask(:)==0)|(trainMap(:)>0),:) = [];
load('D:\Matlab\mani\data\LCLU\unlabelIndex\randomUnLabeledDataIndex.mat')
[~,idx] = sort(randomIdx);
nb_unlabeldata = 6000;

unLabeledData = unLabeledData(idx(1:nb_unlabeldata),:);

unLabeledHSIData = unLabeledData(:,1:size(HSIFeat,2));
unLabeledPOLData = unLabeledData(:,size(HSIFeat,2)+1:end);


%% solve the problem
k_ls8 = size(unLabeledHSIData,1);
k_se1 = size(unLabeledPOLData,1);

%% Similarity matrix
temp = trainMap(trainMap(:)>0);
temp = cat(1,temp,zeros(k_ls8,1),temp,zeros(k_se1,1));
S = repmat(temp,1,length(temp))==repmat(temp',length(temp'),1);
S(temp==0,:) = 0;
figure,imshow(S);

%% Dissimilarity matrix
D = ~S;
D(temp==0,:) = 0;
D(:,temp==0) = 0;
figure,imshow(D);

%% Topology matrix


%% classification only use projected data
LS8Data = cat(1,labeledHSIData,unLabeledHSIData);
SE1Data = cat(1,labeledPOLData,unLabeledPOLData);
Z = [LS8Data',zeros(size(LS8Data,2),size(SE1Data,1));zeros(size(SE1Data,2),size(LS8Data,1)),SE1Data'];

bin = 30;
mu = 1;
dim = 30;


    [ T_ul ] = mapperTopo_parameter( LS8Data, bin );
    [ T_br ] = mapperTopo_parameter( SE1Data, bin );

    T = [T_ul,zeros(size(T_ul,1),size(T_br,2));zeros(size(T_ul,2),size(T_br,1)),T_br];
    T = T.*(~(S+D));
    T(eye(size(T))==1) = 0;


        [ map1,map2 ] = mani_version_2( S,D,T,Z,mu,size(LS8Data,2),size(SE1Data,2) );

            LS8FeatProj = HSIFeat * map1(:,1:dim);
            SE1FeatProj = PolFeat * map2(:,1:dim);

            disp('')
            disp('---------------------')      

            feat = cat(2,LS8FeatProj,SE1FeatProj);            
            for i = 1:size(feat,2)
                feat(:,i) = mat2gray(feat(:,i));
            end        


            trainFeat = feat(trainMap(:)>0,:);
            trainLab = trainMap(trainMap(:)>0);            

            testFeat = feat(testMap(:)>0,:);
            testLab = testMap(testMap(:)>0);


            % rf
            rng(1); % For reproducibility
            NumTrees = 40;
            Mdl_rf = TreeBagger(NumTrees,trainFeat,trainLab);%,'OOBPredictorImportance','on');
            predLab = predict(Mdl_rf,testFeat);
            predLab = cellfun(@str2double,predLab);
            [ M,oa,pa,ua,kappa ] = confusionMatrix(testLab,predLab);



