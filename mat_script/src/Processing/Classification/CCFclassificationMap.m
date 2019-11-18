function [ claMap,forestProbs ] = CCFclassificationMap( data,model )
%This function divides the data into several sub-region and produces
%classification maps. Then, combine them together. The propose is to avoid
%massive computation.
%   Detailed explanation goes here

[r,~,~] = size(data);
claMap = zeros(r,1);
forestProbs = zeros(r,length(model.options.classNames));
if r <= 1000
    [claMap, forestProbs, ~] = predictFromCCF(model,data);
else
    count = 10000;
    nb_r = floor(r/count);
    for i = 1:nb_r
        [claMap((i-1)*count+1:i*count), forestProbs((i-1)*count+1:i*count,:), ~] = predictFromCCF(model,data((i-1)*count+1:i*count,:));
    end
    [claMap(nb_r*count+1:end), forestProbs(nb_r*count+1:end,:), ~] = predictFromCCF(model,data(nb_r*count+1:end,:));
end


end
