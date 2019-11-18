function [ im, claMap,evaluationIdx, TestVote, PredictVote  ] = CCFclassificationscript( varargin )
%ccf: cononical correlation forest
%   three inputs (given training samples & test samples):
%           1. feature:         data features, row * col * dim
%           2. training map:    train label,   row * col
%           3. test map:        train label,   row * col
%           4. label map index: 'flevoland','munich'
%           5. mask:            data mask
%
%   three inputs (given ground truth):
%           1. feature:         data features,          row * col * dim
%           2. label map:       ground truth label,     row * col
%           3. p:               a scale number,         row * col
%           Training samples are the first p (p>1) samples of each class or
%           first p% (p<1) samples of each class, from the ground truth.
%           The rest samples are testing samples


%% initialize outputs
im = 0;
claMap = 0;
evaluationIdx = 0;


%% read input variables
feature = varargin{1};
n = 2;
trainIdx = [];
testIdx = [];
mapIdx = 'cnnmumbai';
mask = ones(size(feature,1),size(feature,2));
while n < nargin
    switch lower(varargin{n})
        case 'train'
            n = n + 1;
            trainIdx = varargin{n};            
        case 'test'
            n = n + 1;
            testIdx = varargin{n};    
        case 'maplegend'
            n = n + 1;
            mapIdx = varargin{n};  
        case 'datamask'
            n = n + 1;
            mask = varargin{n}; 
    end
    n = n + 1;
end

%% check input variables
if isempty(trainIdx)
    disp('training map not given');
    return;
end
if isempty(testIdx)
    disp('test map not given');
    return;
end
if isempty(mapIdx)
    mapIdx = 'cnnmumbai';
end
if isempty(testIdx)
    mask = ones(size(feature,1),size(feature,2));
end

%% check training and testing samples

if size(trainIdx,1) ~= size(testIdx,1) || size(trainIdx,2) ~= size(testIdx,2)
    disp('dimensions of training map and testing map not match');
    return;
% % % % %     % p>1: # of training sample; p<1: percentage of training sample
% % % % %     p = varargin{3};
% % % % %     [ train,trLab,test,teLab ] = sampleData( feature,label,p );
end

%%
[r,c,d] = size(feature);
feature = reshape(feature,r*c,d);
%% mask out null data
featuremasked = feature(mask(:),:);
trainmasked = trainIdx(mask(:));
testmasked = testIdx(mask(:));

% feature normalization
for i=1:d
    featuremasked(:,i) = double(mat2gray(featuremasked(:,i)));
end

trLab = trainmasked(trainmasked(:)>0);
teLab = testmasked ( testmasked(:)>0);

train = featuremasked(trainmasked(:)>0,:);
test  = featuremasked( testmasked(:)>0,:);

nb_trees = 40;
% train ccf model
[CCF] = genCCF(nb_trees,train,trLab);


%
% Step 3: evaluation on test sample
%
[classTest, forestProbsTest, ~, ~] = predictFromCCF(CCF,test);


[ M,oa,pa,ua,kappa ] = confusionMatrix( teLab, classTest );
evaluationIdx = {M oa pa ua kappa};

%% Step 4: produce classification map

[ maskedclamap,forestProbsPred ] = CCFclassificationMap( featuremasked,CCF );
labIdx = unique(trLab);
claIdx = unique(classTest);
for i = 1:length(claIdx)
    maskedclamap(maskedclamap == claIdx(i)) = labIdx(claIdx(i));
end
claMap = zeros(r,c);
claMap(mask(:)) = maskedclamap;
claMap = reshape(claMap,r,c);
im = 0;
% claMap = 0;
% claMap = claMap.*(~mask);
% im = label2color(claMap,mapIdx);
% figure, imshow(im);

PredictVote = zeros(r,c,size(forestProbsPred,2));
TestVote = zeros(r,c,size(forestProbsPred,2));
testAreaMask = mask.*(testIdx>0);
for i = 1:size(forestProbsPred,2)
    temp = zeros(r,c);
    temp(mask(:)) = forestProbsPred(:,i) .* nb_trees;
    PredictVote(:,:,i) = temp;
    
    temp = zeros(r,c);
    temp(testAreaMask(:)>0) = forestProbsTest(:,i) .* nb_trees;
    TestVote(:,:,i) = temp;
end



end

