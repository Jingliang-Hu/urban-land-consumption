function [denoisedImg,Z,sim] = NLM_POLSAR_sepa(Img,Img_pre,L,W,P,idtSim,wtSim,mode)
% This function conduct the algorithm of non-local means filter for Polsar
% data. The rare pixels are separated for the filtering procedure.

%           Input     
%           -- Img_pre           - pre-estimated PolSAR data
%           -- L                 - Number of looks
%           -- W                 - search window size (2*W+1)
%           -- P                 - patch window size (2*P+1)
%           -- idtSim            - criteria for the weight function
%           -- mode              - indication of similarty approach

%           Output    
%           -- denoisedImg       - denoised img



% Input data info
[M,N,D] = size(Img_pre);
% Initial the output of denoised data
denoisedImg = zeros(M,N,D);
% Initial the output of coherent and incoherent scatters
Z = zeros(M,N); 
sim = zeros(M,N); 
% Extent image dealing with edge problem 
padData = padarray(Img_pre,[W+P,W+P],'symmetric','both');
padDataDet = CDet(padData); 
padDataP = padarray(Img_pre,[P,P],'symmetric','both');
padDataDetP = CDet(padDataP);

Img_pad = padarray(Img,[W+P,W+P],'symmetric','both');

% switch similarity approach based on choosen mode
switch mode
    case 1      % detection similarity
        d = sqrt(D);
        % search window loop
        for m = -W:W
            for n = -W:W
               % Pixel - Pixel similarity (detection similarity General likelihood ratio depending on wishart distribution)
               
                % *****************************************************************
                % ****************** similarity of pretest ************************
                %          Sd = L*log(...
                %                    CDet(padDataP + padData(1+W+m:end-W+m,1+W+n:end-W+n,:)).^2./padDataDetP./padDataDet(1+W+m:end-W+m,1+W+n:end-W+n)./(4^D)...
                %                    );   
                %         Sd = L*(2*log(CDet(padDataP + padData(1+W+m:end-W+m,1+W+n:end-W+n,:))) - log(padDataDetP) - log(padDataDet(1+W+m:end-W+m,1+W+n:end-W+n)) - D*log(4));
               
                % ****************** similarity of Delledalle ************************
                % Sd = -L*log((padDataDetP.* padDataDet(1+W+m:end-W+m,1+W+n:end-W+n))./(CDet(0.5*(padDataP + padData(1+W+m:end-W+m,1+W+n:end-W+n,:))) .^ 2));   
                 Sd = -L*log((padDataDetP.* padDataDet(1+W+m:end-W+m,1+W+n:end-W+n))./(CDet(padDataP + padData(1+W+m:end-W+m,1+W+n:end-W+n,:))) .^ 2)-2*L*d*log(2);   

                % ******************************************************************


               Sd = cumsum(Sd,1);
               Sd = cumsum(Sd,2);
               % Patch - Patch similarity
               temp = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:); 
               % calculate weight
               w = w2(temp,idtSim,wtSim);

               % weighted sum
               denoisedImg = denoisedImg + repmat((w.*double(logical(Img_pad(1+W+P+m:end-W-P+m,1+W+P+n:end-W-P+n,1)))),[1,1,D]).* Img_pad(1+W+P+m:end-W-P+m,1+W+P+n:end-W-P+n,:);%
               
               
               % sum up normalisation factor
               w = w .*double(logical(Img_pad(1+W+P+m:end-W-P+m,1+W+P+n:end-W-P+n,1)));
               Z = Z + w;
               sim = sim+temp;
               
            end
        end
        
    case 2      % geometric similarity
        
         % search window loop
        for m = -W:W
            for n = -W:W
               % Pixel - Pixel similarity
               Sd = riemDist(padDataP(:,:,1:sqrt(D)),padData(1+W+m:end-W+m,1+W+n:end-W+n,1:sqrt(D)));
               Sd = cumsum(Sd,1);
               Sd = cumsum(Sd,2);
               % Patch - Patch similarity
               temp = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:); 
               % calculate weight
               w = w2(temp,idtSim,wtSim);
               % sum up normalisation factor
               Z = Z + w;
               % weighted sum
               denoisedImg = denoisedImg + repmat(w,[1,1,D]) .* Img_pad(1+W+P+m:end-W-P+m,1+W+P+n:end-W-P+n,:);
              
              
            end
        end
        
    case 3      % information similarity
        
         % search window loop
        for m = -W:W
            for n = -W:W
               % Pixel - Pixel similarity
               Sd = KLtrace(padDataP,padData(1+W+m:end-W+m,1+W+n:end-W+n,:));
               Sd = cumsum(Sd,1);
               Sd = cumsum(Sd,2);
               % Patch - Patch similarity
               temp = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:); 
               temp = sqrt(abs(temp));
               
            end
        end
     case 4      % geometric similarity
        
         % search window loop
        for m = -W:W
            for n = -W:W
               % Pixel - Pixel similarity
               Sd = logEucMetric(padDataP,padData(1+W+m:end-W+m,1+W+n:end-W+n,:));
               Sd = cumsum(Sd,1);
               Sd = cumsum(Sd,2);
               % Patch - Patch similarity
               temp = Sd(2*P+1:end,2*P+1:end,:)+Sd(1:end-2*P,1:end-2*P,:)-Sd(1:end-2*P,2*P+1:end,:)-Sd(2*P+1:end,1:end-2*P,:); 
               % calculate weight
               w = w2(temp,idtSim,wtSim);
               % sum up normalisation factor
               Z = Z + w;
               sim = sim+temp;
               % weighted sum
               denoisedImg = denoisedImg + repmat(w,[1,1,D]) .* Img_pad(1+W+P+m:end-W-P+m,1+W+P+n:end-W-P+n,:);
              
              
            end
        end
        
    otherwise
        
end
denoisedImg = denoisedImg./repmat(Z,[1,1,D]);
denoisedImg(isnan(denoisedImg))=0;

end

