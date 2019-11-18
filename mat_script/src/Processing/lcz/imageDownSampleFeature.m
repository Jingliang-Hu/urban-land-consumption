function [ data ] = imageDownSampleFeature( odata,grid,featType)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if size(odata,3)~=1
    return;
end

[r,c] = size(odata);
rw = grid(1);
cl = grid(2);
data = zeros(rw,cl);
rate_r = r/rw;
rate_c = c/cl;

r_start = floor(1:rate_r:r);
r_end = ceil(rate_r:rate_r:r);

c_start = floor(1:rate_c:c);
c_end = ceil(rate_c:rate_c:c);

switch lower(featType)
    case 'std'
        for rr = 1:length(r_start)-1
            for cc = 1:length(c_start)-1
                temp = odata(r_start(rr):r_end(rr),c_start(cc):c_end(cc));
                data(rr,cc) = std(temp(:));
            end
            temp = odata(r_start(rr):r_end(rr),c_start(cc+1):c_end(end));
            data(rr,end) = std(temp(:));
        end
        rr = rr + 1;
        for cc = 1:length(c_start)-1
            temp = odata(r_start(rr):r_end(end),c_start(cc):c_end(cc));
            data(end,cc) = std(temp(:));
        end
        temp = odata(r_start(rr):r_end(end),c_start(cc+1):c_end(end));
        data(end,end) = std(temp(:));
    case 'mean'
        for rr = 1:length(r_start)-1
            for cc = 1:length(c_start)-1
                temp = odata(r_start(rr):r_end(rr),c_start(cc):c_end(cc));
                data(rr,cc) = mean(temp(:));
            end
            temp = odata(r_start(rr):r_end(rr),c_start(cc+1):c_end(end));
            data(rr,end) = mean(temp(:));
        end
        rr = rr + 1;
        for cc = 1:length(c_start)-1
            temp = odata(r_start(rr):r_end(end),c_start(cc):c_end(cc));
            data(end,cc) = mean(temp(:));
        end
        temp = odata(r_start(rr):r_end(end),c_start(cc+1):c_end(end));
        data(end,end) = mean(temp(:));
end




% % % % % % % padData = padarray(odata,[rate_r,rate_c],'symmetric','both');
% % % % % % % 
% % % % % % % temp = zeros(r,c,rate_r*rate_c);
% % % % % % % for i = 0:rate_r-1
% % % % % % %     for j = 0:rate_c-1
% % % % % % %         temp = temp + circshift(padData,[i,j]);
% % % % % % %     end
% % % % % % % end
% % % % % % % 
% % % % % % % switch lower(featType)
% % % % % % %     case 'std'
% % % % % % %         feat = std(temp,[],3);
% % % % % % %     case 'mean'
% % % % % % %         feat = mean(temp,3);
% % % % % % % end
% % % % % % % 
% % % % % % % data = feat(rate_r:rate_r:r,rate_c:rate_c:c);



end

