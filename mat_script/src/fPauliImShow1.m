function [z,h] = fPauliImShow1(varargin)
% pesudo color image with Pauli basises

% input     -- data     - Polarimetric data (m x n x 9)

% output    -- z        - pesudo color image with Pauli basis

data = varargin{1};
flag = size(data,3);

z = zeros(size(data,1),size(data,2),3);



if nargin < 2
    switch flag
        case 9
            mask = ones(size(data,1),size(data,2));
        case 4
%             coh = sqrt(data(:,:,3).^2+data(:,:,4).^2)./sqrt(data(:,:,1).*data(:,:,2));
%             mask = coh <= 1;
%             mask = 
            mask = sum(data(:,:,1:2),3)>0;
    end
    
else
    mask = varargin{2};
end





switch flag
    case 9 % full polarimetric
        
%         Description :  Creation of the PAULI RGB BMP file
%         Blue = 10log(T11)
%         Green = 10log(T33)
%         Red = 10log(T22)
%         with :
%         T11 = 0.5*|HH+VV|^2
%         T22 = 0.5*|HH-VV|^2
%         T33 = 2*|HV|^2
        
        z(:,:,1) = data(:,:,2); % red      |hh-vv|2
        z(:,:,2) = data(:,:,3); % green    4|hv|2
        z(:,:,3) = data(:,:,1); % blue     |hh+vv|2
        
        
        
        
        
    case 4 % partial polarimetric
        % ----------------- PolSARpro representation ----------------------
        % Blue = |C11|
        % Green = |C11-2ReC12+C22|
        % Red = |C22|

%         data = convert_T2_C2_hh_vv(data);
        
        
        z(:,:,1) = data(:,:,2);
        z(:,:,2) = data(:,:,1) + data(:,:,2) - 2 * data(:,:,3);
        z(:,:,3) = data(:,:,1);
        

        % -------------------- Other representation ----------------------
%         data = convert_T2_C2_hh_vv(data);
%         z(:,:,1) = (data(:,:,1))./(mean(mean(data(:,:,1))));
%         z(:,:,2) = (data(:,:,2)+data(:,:,1)-2*data(:,:,3))./(mean(mean(data(:,:,2))));
%         z(:,:,3) = (data(:,:,2))./(mean(mean(data(:,:,2))));
%         for i = 1:3
%             z(:,:,i) = histeq(z(:,:,i));
%         end
        
end

clear data;


%           if (xx <= eps) xx = eps;
%           xx = 10 * log10(xx);
%           if (xx > maxblue) xx = maxblue;
%           if (xx < minblue) xx = minblue;
%           xx = (xx - minblue) / (maxblue - minblue);
%           if (xx > 1.) xx = 1.;        
%           if (xx < 0.) xx = 0.;
%           l = (int) (floor(255 * xx));

% geting maximum and minimum value for rgb bands
% rgbmin = zeros(1,3);
% rgbmax = zeros(1,3);



% for i = 1:3
%     temp = z(:,:,i);
%     temp = temp(mask==1);
%     rgbmin(i) = min(10*log10(temp(temp>eps)));
%     rgbmax(i) = max(10*log10(temp(temp>eps)));
% end

% z(z<=eps) = eps;
z = 10*log10(z);

for i = 1:3
    temp = z(:,:,i);
    temp = temp(mask==1);
    rgbBoundary = quantile(temp(:),[0.02,0.98]);
%     rgbBoundary = quantile(temp(:),[0.1,0.9]);
    temp = z(:,:,i);
    temp(temp<rgbBoundary(1)) =  rgbBoundary(1);
    temp(temp>rgbBoundary(2)) =  rgbBoundary(2);
    z(:,:,i) = (temp - rgbBoundary(1))/(rgbBoundary(2)-rgbBoundary(1));
end


% z(:,:,1) = (z(:,:,1) - min(min(z(:,:,1))))/(max(max(z(:,:,1))) - min(min(z(:,:,1))));
% z(:,:,2) = (z(:,:,2) - min(min(z(:,:,2))))/(max(max(z(:,:,2))) - min(min(z(:,:,2))));
% z(:,:,3) = (z(:,:,3) - min(min(z(:,:,3))))/(max(max(z(:,:,3))) - min(min(z(:,:,3))));

% z = uint8(floor(255*z));
% for i = 1:3
%     z(:,:,i) = histeq(z(:,:,i));
% end
        
        
% figure;
h=imshow(z);
