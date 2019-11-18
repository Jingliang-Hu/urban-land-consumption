function denoisedImg = NLSAR(img,L,W,P)
% The function of DetectSimi calculates the similarity of PolSAR image
% according to detection similarity depending on general likelihood ratio
% with Wishart distribution

% Input     -- data     - noisy image (PolSAR coherence form)
%           -- L        - NO. of looks (Used to calculate sigma)
%           -- W        - search window size (2*W+1)
%           -- P        - patch window size (2*P+1)

% Output    -- simi     - similarity

% Input data info
[M,N,D] = size(img);
% Initial the output of similarity
denoisedImg = zeros(M,N,D); 
% Weight normalization factor
Z = zeros(M,N);
% Pre-estimation
Pre_img = meanfilt2(img,1);

% Extent image dealing edge problem 
padData = padarray(Pre_img,[W+P,W+P],'symmetric','both');
padDataDet = CDet(padData); 
padDataP = padarray(Pre_img,[P,P],'symmetric','both');
padDataDetP = CDet(padDataP);

Img = padarray(img,[W+P,W+P],'symmetric','both');
% search window loop

[ quanSim,~,~ ] = simquantile( L,W,P );

for m = -W:W
    for n = -W:W
        if m~=0 && n~=0
            % Pixel - Pixel similarity (detection similarity General likelihood ratio depending on wishart distribution)
            Sd = -L*log((padDataDetP.* padDataDet(1+W+m:end-W+m,1+W+n:end-W+n))./CDet(0.5*(padDataP + padData(1+W+m:end-W+m,1+W+n:end-W+n,:))) .^ 2);   
            Sd = cumsum(Sd,1);
            Sd = cumsum(Sd,2);
            % Patch - Patch similarity
            temp = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:);     
            % calculate weight
            w = NLSARweight(temp,quanSim);
        else
            w = ones(M,N);
        end
        % sum up normalisation factor
        Z = Z + w;
        % weighted sum
        denoisedImg = denoisedImg + repmat(w,[1,1,D]) .* Img(1+W+P+m:end-W-P+m,1+W+P+n:end-W-P+n,:);
        
    end
end
denoisedImg = denoisedImg./repmat(Z,[1,1,D]);