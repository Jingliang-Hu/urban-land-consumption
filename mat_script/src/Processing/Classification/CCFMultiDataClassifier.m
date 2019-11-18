function [ im, claMap,evaluationIdx ] = CCFMultiDataClassifier( varargin )
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
multiData = varargin{1};
nb_data = length(multiData);
n = 2;
trainIdx = [];
testIdx = [];
mapIdx = 'cnnmumbai';
mask = ones(size(multiData{1},1),size(multiData{1},2));
weight = ones(1,nb_data)./nb_data;
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
        case 'weight'
            n = n + 1;
            weight = varargin{n}; 
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

%% check training and testing samples

if size(trainIdx,1) ~= size(testIdx,1) || size(trainIdx,2) ~= size(testIdx,2)
    disp('dimensions of training map and testing map not match');
    return;
% % % % %     % p>1: # of training sample; p<1: percentage of training sample
% % % % %     p = varargin{3};
% % % % %     [ train,trLab,test,teLab ] = sampleData( feature,label,p );
end

%%
forestProbs = cell(1,nb_data); 
treePredictions = cell(1,nb_data); 
cumulativeForestPredicts = cell(1,nb_data); 
maskedprob = cell(1,nb_data);


for i = 1:nb_data

    [r,c,d] = size(multiData{i});
    multiDataTemp = reshape(multiData{i},r*c,d);
    %% mask out null data
    featuremasked = multiDataTemp(mask(:),:);
    trainmasked = trainIdx(mask(:));
    testmasked = testIdx(mask(:));

    % feature normalization
    for nn=1:d
        featuremasked(:,nn) = double(mat2gray(featuremasked(:,nn)));
    end

    trLab = trainmasked(trainmasked(:)>0);
    teLab = testmasked ( testmasked(:)>0);

    train = featuremasked(trainmasked(:)>0,:);
    test  = featuremasked( testmasked(:)>0,:);


    % train ccf model
     nb_tree = 40;
%    nb_tree = 200;
    [CCF] = genCCF(nb_tree,train,trLab);


    %
    % Step 3: evaluation on test sample
    %
    [~, forestProbs{i}, ~, ~] = predictFromCCF(CCF,test);
    %% Step 4: produce classification map
    [ ~,maskedprob{i} ] = CCFclassificationMap( featuremasked,CCF );
end
   
classTest = zeros(size(forestProbs{1}));
maskedclamap = zeros(size(maskedprob{1}));
for i = 1:nb_data
    classTest = classTest + weight(i) * forestProbs{i};
    maskedclamap = maskedclamap + weight(i) * maskedprob{i};
end


[~,classTest] = max(classTest,[],2);
[~,maskedclamap] = max(maskedclamap,[],2);

[ M,oa,pa,ua,kappa ] = confusionMatrix( teLab, classTest );

evaluationIdx = {M oa pa ua kappa};

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
end

