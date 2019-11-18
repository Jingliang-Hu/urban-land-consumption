function [z,h] = fPauliImShow(varargin)
% pesudo color image with Pauli basises

% input     -- data     - Polarimetric data (m x n x 9)

% output    -- z        - pesudo color image with Pauli basis

data = varargin{1};
n = 2;
if nargin ==2
    n = varargin{2};
end


flag = size(data,3);
switch flag
    case 9 % full polarimetric
        
        z(:,:,1) = data(:,:,2)./(mean(mean(data(:,:,2)))*n); % red      |hh-vv|2
        z(:,:,2) = data(:,:,3)./(mean(mean(data(:,:,3)))*n); % green    4|hv|2
        z(:,:,3) = data(:,:,1)./(mean(mean(data(:,:,1)))*n); % blue     |hh+vv|2
        for i = 1:3
            z(:,:,i) = histeq(z(:,:,i));
        end
    case 4 % partial polarimetric
        % ----------------- PolSARpro representation ----------------------
        % Blue = 10log(|T11|)
        % Green = 10log(|T11-2ReT12+T22|)
        % Red = 10log(|T22|)
%         temp = data(:,:,1)+data(:,:,2)-2*data(:,:,3);%                  
%         z(:,:,1) = data(:,:,2);%./(mean(mean(data(:,:,2)))*n); % red    |hh-vv|2
%         z(:,:,2) = temp./2;%./(mean(mean(temp))*n); % green             2|vv|2   
%         z(:,:,3) = data(:,:,1);%./(mean(mean(data(:,:,1)))*n); % blue   |hh+vv|2
        
%         % -------------------- Other representation ----------------------
%         z(:,:,1) = data(:,:,2);%./(mean(mean(data(:,:,2)))*n); % red    |hh-vv|2
%         z(:,:,2) = (data(:,:,2)+data(:,:,1))./2;%./(mean(mean(temp))*n); % green             2|vv|2   
%         z(:,:,3) = data(:,:,1);%./(mean(mean(data(:,:,1)))*n); % blue   |hh+vv|2
   
        % -------------------- Other representation ----------------------
        
%         z(:,:,1) = sqrt(data(:,:,2))./(mean(mean(data(:,:,2)))*n); % red    |hh-vv|
%         z(:,:,3) = sqrt(data(:,:,1))./(mean(mean(data(:,:,1)))*n); % blue   |hh+vv|     
%         z(:,:,2) = (z(:,:,3)+z(:,:,1))./2;%./(mean(mean(temp))*n); % green             |hh|  
        
        
        % -------------------- Other representation ----------------------
        [ data ] = convert_T2_C2_hh_vv( data );
%         
        z(:,:,1) = (data(:,:,2));%./(mean(mean(data(:,:,1))));    % red    |vv|
        z(:,:,2) =  data(:,:,1) + data(:,:,2) - 2 .* data(:,:,3); % green  |hh|+|vv|-real(hv)
        z(:,:,3) = (data(:,:,1));%./(mean(mean(data(:,:,2))));    % blue   |hh|    
        
%         z(:,:,1) = z(:,:,1)/min(max(z(:,:,1)));
%         z(:,:,2) = z(:,:,2)/min(max(z(:,:,2)));
%         z(:,:,3) = z(:,:,3)/min(max(z(:,:,3)));
%         (z(:,:,3)+z(:,:,1))./2;%./(mean(mean(temp))*n); % green      
%         z(:,:,1) = (z(:,:,1) - min(min(z(:,:,1))))/max(min(z(:,:,1)));
%         z(:,:,2) = (z(:,:,2) - min(min(z(:,:,2))))/max(min(z(:,:,2)));
%         z(:,:,3) = (z(:,:,3) - min(min(z(:,:,3))))/max(min(z(:,:,3)));

        % histogram equalization
%        for i = 1:3
%            z(:,:,i) = histeq(z(:,:,i));
%        end
        
end

clear data;
% figure;
h=imshow(z,[]);


