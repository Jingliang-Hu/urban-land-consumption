function [ claMap ] = rfclassificationMap( data,model )
%This function divides the data into several sub-region and produces
%classification maps. Then, combine them together. The propose is to avoid
%massive computation.
%   Detailed explanation goes here

[r,~,~] = size(data);
claMap = zeros(r,1);

if r <= 1000
    [claMap, ~, ~] = classRF_predict(data,model);
else
    count = 1000;
    nb_r = floor(r/count);
    for i = 1:nb_r
        [claMap((i-1)*count+1:i*count), ~, ~] = classRF_predict(data((i-1)*count+1:i*count,:),model);
    end
    [claMap(nb_r*count+1:end), ~, ~] = classRF_predict(data(nb_r*count+1:end,:),model);
end

end

