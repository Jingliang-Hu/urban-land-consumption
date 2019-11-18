function sim = DetectSimStat(data,L,W,P)
% The function of DetectSimi calculates the similarity of PolSAR image
% according to detection similarity depending on general likelihood ratio
% with Wishart distribution

% Input     -- data     - noisy image (PolSAR coherence form)
%           -- L        - NO. of looks (Used to calculate sigma)
%           -- W        - search window size (2*W+1)
%           -- P        - patch window size (2*P+1)

% Output    -- simi     - similarity

% Input data info
[M,N,~] = size(data);
% Initial the output of similarity
sim = zeros(M,N,(W*2+1)^2-1); 

data = meanfilt2(data,1);

% Extent image dealing edge problem 
padData = padarray(data,[W+P,W+P],'symmetric','both');
padDataDet = CDet(padData); 
padDataP = padarray(data,[P,P],'symmetric','both');
padDataDetP = CDet(padDataP);

i = 1;
% search window loop
for m = -W:W
    for n = -W:W
        if~(m==0 && n==0)  

           % Pixel - Pixel similarity (detection similarity General likelihood ratio depending on wishart distribution)
           Sd = -L*log((padDataDetP.* padDataDet(1+W+m:end-W+m,1+W+n:end-W+n))./CDet(0.5*(padDataP + padData(1+W+m:end-W+m,1+W+n:end-W+n,:))) .^ 2);   
           Sd = cumsum(Sd,1);
           Sd = cumsum(Sd,2);
           % Patch - Patch similarity
           temp = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:);     
           % sum up similarity
           sim(:,:,i) = temp;
           i = i+1;
           % waitbar(((m+W)*(2*W+1)+(n+W+1))/(2*W+1).^2);
           
        end
    end
end


end