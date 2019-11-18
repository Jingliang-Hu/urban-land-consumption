function output = NLmeanFilterForPolarSarData(data,L,W,P,K)
% fast pre-test filter for Polarimetric SAR image, "FAST NONLOCAL FILTERING APPLIED TO ELECTRON CRYOMICROSCOPY"
% 2*W+1 is the size of the search window
% 2*P+1 is the size of the patch window
% K is the coefficient in the empirical equation to calculate the threshold

[M,N,k] = size(data);
output = zeros(M,N,k);     Z = zeros(M,N);      w=zeros(M,N);     % ³õÊ¼»¯
% h = L/h;
dataDet = fTdet(data);
sigma = (K / L)^(1 / 2) * ((2*P+1)^2);
for m = -W:W
    m
    for n = -W:W
        shiftData = circshift(data,[m,n]);
        Sd = 6 * log(2) + log((dataDet.* circshift(dataDet,[m,n]))./fTdet(data + shiftData) .^ 2);     
        Sd = cumsum(Sd,1);
        Sd = cumsum(Sd,2);
        temp = (circshift(Sd,[P+1,P+1]) + circshift(Sd,[-P,-P])-circshift(Sd,[-P,P+1]) - circshift(Sd,[P+1,-P]));
        w = exp(temp/sigma).*(temp>-sigma);
        Z = Z + w;
        output = output + repmat(w,[1,1,k]) .* shiftData;
    end
end
output = output ./ repmat(Z,[1 1 k]);
output(1:P+1,:,:)=0;
output(end-P+1:end,:,:)=0;
output(:,1:P+1,:)=0;
output(:,end-P+1:end,:)=0;
