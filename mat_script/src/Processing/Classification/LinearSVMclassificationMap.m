function [ claMap ] = LinearSVMclassificationMap( data,label,model,m,s )
%This function divides the data into several sub-region and produces
%classification maps. Then, combine them together. The propose is to avoid
%massive computation.
%   Detailed explanation goes here

[r_d,c_d,~] = size(data);
[r,c,~] = size(label);

if r_d~=r || c_d~=c
    disp('size of data and label do not match');
    return;
end
claMap = zeros(size(label));

nr = 100;
nc = 100;

nb_r = ceil(r/nr);
nb_c = ceil(c/nc);

for i = 1:nb_r
    if i == nb_r
        temp_data = data((i-1)*nr+1:end,:,:);
        temp_label = label((i-1)*nr+1:end,:);
    else
        temp_data = data((i-1)*nr+1:i*nr,:,:);
        temp_label = label((i-1)*nr+1:i*nr,:);
    end
    
        
    for j = 1:nb_c
        if j == nb_c
            [ ~,~,feature,a ] = sampleData( temp_data(:,(j-1)*nc+1:end,:),temp_label(:,(j-1)*nc+1:end),0 );
            if isa(m,'double')&&isa(s,'double')
                allNormalised = (feature - repmat(m,size(feature,1),1))./repmat(s,size(feature,1),1);% feature scaling for test samples
            else
                allNormalised = feature;
            end
            [classAll] = svmpredict2(a, allNormalised, model);% predict using trained model

            if i == nb_r
                claMap((i-1)*nr+1:end,(j-1)*nc+1:end) = reshape(classAll,size(temp_data(:,(j-1)*nc+1:end,:),1),[]);
            else
                claMap((i-1)*nr+1:i*nr,(j-1)*nc+1:end) = reshape(classAll,size(temp_data(:,(j-1)*nc+1:end,:),1),[]);
            end
        else
            [ ~,~,feature,a ] = sampleData( temp_data(:,(j-1)*nc+1:j*nc,:),temp_label(:,(j-1)*nc+1:j*nc),0 );
            if isa(m,'double')&&isa(s,'double')
                allNormalised = (feature - repmat(m,size(feature,1),1))./repmat(s,size(feature,1),1);% feature scaling for test samples
            else
                allNormalised = feature;
            end
            [classAll] = svmpredict2(a, allNormalised, model);% predict using trained model

            if i == nb_r
                claMap((i-1)*nr+1:end,(j-1)*nc+1:j*nc) = reshape(classAll,size(temp_data(:,(j-1)*nc+1:j*nc,:),1),[]);
            else
                claMap((i-1)*nr+1:i*nr,(j-1)*nc+1:j*nc) = reshape(classAll,size(temp_data(:,(j-1)*nc+1:j*nc,:),1),[]);
            end
        end
        
    end
    
end


end

