function [ claMap ] = classificationMap( data,model )
%This function divides the data into several sub-region and produces
%classification maps. Then, combine them together. The propose is to avoid
%massive computation.
%   Detailed explanation goes here




[r,~,~] = size(data);
claMap = zeros(r,1);

if r <= 1000    
    [claMap] = svmpredict2(zeros(r,1), data, model);
else
    count = 1000;
    nb_r = floor(r/count);
    fakelabel = zeros(count,1);
    for i = 1:nb_r
        [claMap((i-1)*count+1:i*count)] = svmpredict2(fakelabel,data((i-1)*count+1:i*count,:),model);
    end
    [claMap(nb_r*count+1:end)] = svmpredict2(zeros(size(data(nb_r*count+1:end,:),1),1),data(nb_r*count+1:end,:),model);
end

end

