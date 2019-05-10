%% read enmap
% read training and testing label
load('D:\Matlab\mani\data\LCLU\groundTruth\trainAndTest.mat')
% read LS8 features
load('D:\Matlab\mani\data\LCLU\data\enmap_berlin.mat', 'hsi_up_mask')
load('D:\Matlab\mani\data\LCLU\data\enmap_berlin.mat', 'mask')

EnMapFeat = hsi_up_mask; clear hsi_up_mask
testMap = double(testMap);

%% training map selection
trainMap = trainMap2;

%% dimension reduction pca
temp = reshape(EnMapFeat,size(trainMap,1)*size(trainMap,2),size(EnMapFeat,3));
normData = temp(mask(:)==1,:);
for i = 1:size(normData,2)
    normData(:,i) = mat2gray(normData(:,i));
end
normData = pca_dr(normData);
temp = zeros(size(temp,1),size(normData,2));
temp(mask(:)==1,:) = normData;

hsiFeat = reshape(temp,size(trainMap,1),size(trainMap,2),size(temp,2));

%% morphological profile
r1 = 1:3;
r2 = r1;
options = 'MPr';
optFeat=[];
for i=1:size(hsiFeat,3)
   MPNeachpca = Make_Morphology_profile(hsiFeat(:,:,i),r1,r2,options);
   optFeat = cat(3,optFeat,MPNeachpca);        
end

clear EnMapFeat MPNeachpca hsiFeat i normData options r1 r2 temp trainMap2
