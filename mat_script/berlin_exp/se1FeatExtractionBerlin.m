%% 
% read training and testing label
load('D:\Matlab\mani\data\LCLU\groundTruth\trainAndTest.mat')
% read sentinel 1 data
load('D:\Matlab\mani\data\LCLU\data\sentinel1_berlin_C.mat', 'C')
load('D:\Matlab\mani\data\LCLU\data\enmap_berlin.mat', 'mask')
testMap = double(testMap);
polsar = C;clear C

%% training map selection
trainMap = trainMap2;

%% Polsar elements from covariance matrix
coh = sqrt(polsar(:,:,3).^2+polsar(:,:,4).^2)./sqrt(polsar(:,:,1).*polsar(:,:,2));
ratio = (polsar(:,:,1)./polsar(:,:,2));
PolFeat = cat(3,polsar(:,:,1:2),ratio,coh);

%% morphological profile
r1 = 1:3;
r2 = r1;
options = 'MPr';
temp=[];
for i=1:size(PolFeat,3)
   MPNeachpca = Make_Morphology_profile(PolFeat(:,:,i),r1,r2,options);
   temp = cat(3,temp,MPNeachpca);        
end

%% statistics
[ featMean ] = localStat( PolFeat,5,'mean' );
[ featStd ]  = localStat( PolFeat,5,'std' );
polFeat = cat(3,temp,featMean,featStd);   

clear MPNeachpca coh featMean featStd i options PolFeat polsar r1 r2 ratio temp trainMap2;