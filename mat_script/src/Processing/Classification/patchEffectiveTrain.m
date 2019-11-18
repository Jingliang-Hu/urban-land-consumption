function [ trainEffective,test,train,trainMask ] = patchEffectiveTrain( trainLabel,label,win )
%
%   Detailed explanation goes here
%       Input:
%           - data          -- [row,col,bnd]
%           - win           -- half window size
%           - dim           -- number of dimension to reduce
%
%       Output:
%           - feat          -- [row,col,nbOfDim]

[r,c,~] = size(trainLabel);
dataPad = padarray(trainLabel,[win,win],'symmetric','both');

datatemp = zeros(size(dataPad,1),size(dataPad,2),(2*win+1)^2);
    for i = -win:win
        for j = -win:win
            datatemp(:,:,(i+win)*(2*win+1)+j+win+1) = circshift(dataPad(:,:),[i,j]);
        end
    end
    
trainMask = sum(datatemp(1+win:r+win,1+win:c+win,:),3)>0;

test = label .* (~trainMask);
trainEffective = label .* trainMask;
train = trainLabel;

idx = unique(trainEffective);
for i = 1:length(idx)
    if sum(test(:)==idx(i))==0
        trainEffective(trainEffective == idx(i)) = 0;        
    end
end


idx = unique(train);
for i = 1:length(idx)
    if sum(test(:)==idx(i))==0
        train(train == idx(i)) = 0;        
    end
end

end

