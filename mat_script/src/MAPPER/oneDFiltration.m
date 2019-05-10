function [ filIdx ] = oneDFiltration( filVal, param )
%This function calculate the equal sized filtration intervals for the
%MAPPER algorithm
%   Input:
%       - filVal                    -- filtration values
%       - overlap                   -- overlap rate of adjacent interval
%       - nbInterval                -- number of intervals
%       - flag                      -- equal interval(1); statistical interval(2)
%
%   Output:
%       - filIdx                    -- index of points of each interval
%
overlap = param.ovLap(1);
nbInterval = param.nbBin(1);
flag = param.itvFlag;



[r,~,~] = size(filVal);
filIdx = zeros(r,nbInterval);

minVal = min(filVal);
maxVal = max(filVal);

switch flag
    case 1
        % intervals of equal length of filtration value
        lengthOfInterval = (maxVal-minVal)/((nbInterval-1)*(1-overlap)+1);

        start = minVal;
        finish = start + lengthOfInterval;
        for i = 1:nbInterval - 1
            filIdx(:,i) = ((filVal >= start) & (filVal <= finish));
            start = finish  - lengthOfInterval * overlap;
            finish = start + lengthOfInterval;
        end
        
        filIdx(:,end) = ((filVal >= start) & (filVal <= maxVal));

    case 2
        % statistically derived intervals
        lengthOfInterval = 1/((nbInterval-1)*(1-overlap)+1);
        start = 0;
        finish = lengthOfInterval;
        
        for i = 1:nbInterval - 1
            filIdx(:,i) = ((filVal >= quantile(filVal,start)) & (filVal <= quantile(filVal,finish)));
            start = finish  - lengthOfInterval * overlap;
            finish = start + lengthOfInterval;
        end
        
        filIdx(:,end) = ((filVal >= quantile(filVal,start)) & (filVal <= maxVal));
        
        
end


end

