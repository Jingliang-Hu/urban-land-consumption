function target = searchSimilar(data,targetCov,L,P,thres)
% The function of DetectSimi calculates the similarity of PolSAR image
% according to detection similarity depending on general likelihood ratio
% with Wishart distribution

% Input     -- data     - noisy image (PolSAR coherence form)
%           -- L        - NO. of looks (Used to calculate sigma)
%           -- W        - search window size (2*W+1)
%           -- P        - patch window size (2*P+1)

% Output    -- simi     - similarity

% Input data info
[M,N,D] = size(data);
D = sqrt(D);
targetCov = repmat(targetCov,M,N,1);


% Extent image dealing edge problem 
padData = padarray(data,[P,P],'symmetric','both');
padDataDet = CDet(padData); 
padDataP = padarray(targetCov,[P,P],'symmetric','both');
padDataDetP = CDet(padDataP);



        
Sd = -L*log((padDataDetP.* padDataDet)./(CDet(padDataP + padData)) .^ 2)-2*L*D*log(2);   
Sd = cumsum(Sd,1);
Sd = cumsum(Sd,2);
% Patch - Patch similarity
target = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:);  
target = target<thres;
   

end
