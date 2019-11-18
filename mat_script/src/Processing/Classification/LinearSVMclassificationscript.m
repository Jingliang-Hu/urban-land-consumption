function [ im, claMap,evaluationIdx ] = LinearSVMclassificationscript( varargin )
%linear svm
%   three inputs (given training samples & test samples):
%           1. feature:         data features, row * col * dim
%           2. training map:    train label,   row * col
%           3. test map:        train label,   row * col
%
%   three inputs (given ground truth):
%           1. feature:         data features,          row * col * dim
%           2. label map:       ground truth label,     row * col
%           3. p:               a scale number,         row * col
%           Training samples are the first p (p>1) samples of each class or
%           first p% (p<1) samples of each class, from the ground truth.
%           The rest samples are testing samples
%
%
%
%


% feature,label,p
% inputs:
if nargin ~= 3
    return;
end
feature = varargin{1};
label = varargin{2};

if size(varargin{2},1) == size(varargin{3},1) && size(varargin{2},2) == size(varargin{3},2)
    trainIdx = varargin{2};
    testIdx  = varargin{3};
    [r,c,d] = size(feature);
    feat = reshape(feature,r*c,d);
    
    trLab = trainIdx(trainIdx(:)>0);
    teLab = testIdx (testIdx(:) >0);
    
    train = feat(trainIdx(:)>0,:);
    test = feat(testIdx(:)>0,:);
    
elseif length(varargin{3})==1
    % p>1: # of training sample; p<1: percentage of training sample
    p = varargin{3};
    [ train,trLab,test,teLab ] = sampleData( feature,label,p );
end



mask = sum(feature,3)==0;

 
% feature normalization
[ trainNormalised,m,s ] = featureNormalise( train,3 );% feature scaling for training sampels
testNormalised = (test - repmat(m,size(test,1),1))./repmat(s,size(test,1),1);% feature scaling for test samples


% train SVM model
folds = 5;
[ cv_C, ~ ] = linearSVMPar( trLab,trainNormalised,folds );% optimal parameters searching
model = svmtrain2(trLab,trainNormalised,sprintf('-c %f -t %f', cv_C, 0));% SVM training
 

%
% Step 3: evaluation on test sample
%
[classTest] = svmpredict2(teLab, testNormalised, model);% predict using trained model



[ M,oa,pa,ua,kappa ] = confusionMatrix( teLab, classTest );
evaluationIdx = {M oa pa ua kappa};


%
% Step 4: produce classification map
%
% [r,c,~] = size(feature);
% claMap = zeros(r,c);
% im = zeros(r,c);
[ claMap ] = LinearSVMclassificationMap( feature,label,model,m,s );
claMap = claMap.*(~mask);
im = label2color(claMap,'munich');
figure, imshow(im);
end

