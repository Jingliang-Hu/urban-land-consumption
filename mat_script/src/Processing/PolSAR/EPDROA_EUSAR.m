function [ epdroa ] = EPDROA_EUSAR( f_data,o_data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[~,~,d] = size(f_data);
epdroa = sum(sum(abs(f_data(2:end,:,:)-f_data(1:end-1,:,:)),1),2)./sum(sum(abs(o_data(2:end,:,:)-o_data(1:end-1,:,:)),1),2);
% epdroa_u = sum(sum(abs(f_data(2:end-1,2:end-1,:)./f_data(1:end-2,2:end-1,:)),1),2)./sum(sum(abs(o_data(2:end-1,2:end-1,:)./o_data(1:end-2,2:end-1,:)),1),2);
% 
% epdroa_r = sum(sum(abs(f_data(2:end-1,2:end-1,:)./f_data(2:end-1,3:end,:)),1),2)./sum(sum(abs(o_data(2:end-1,2:end-1,:)./o_data(2:end-1,3:end,:)),1),2);
% epdroa_l = sum(sum(abs(f_data(2:end-1,2:end-1,:)./f_data(2:end-1,1:end-2,:)),1),2)./sum(sum(abs(o_data(2:end-1,2:end-1,:)./o_data(2:end-1,1:end-2,:)),1),2);
% 
% epdroa = (epdroa_d+epdroa_u+epdroa_r+epdroa_l)./4;

% epdroa = abs(reshape(epdroa,d,[],1)-1);

end

