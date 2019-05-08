function [ filIdx ] = twoDFiltration( filVal1,filVal2,overlap,nbInterval1,nbInterval2,flag )
%This function calculate the equal sized filtration intervals for the
%MAPPER algorithm
%   Input:
%       - filVal11                   -- first dimension filtration values
%       - filVal12                   -- second dimension filtration values
%       - overlap                    -- overlap rate of adjacent interval
%       - nbInterval1                -- number of intervals 1st filtration dimension
%       - nbInterval2                -- number of intervals 2nd filtration dimension
%       - flag                       -- equal interval(1); statistical interval(2)
%
%   Output:
%       - filIdx                     -- index of points of each interval
%

disp('-----------------  filtration value calculating ... ------------------');

[r,~,~] = size(filVal1);
filIdx = zeros(r,nbInterval1 * nbInterval2);

minVal1 = min(filVal1);
maxVal1 = max(filVal1);

minVal2 = min(filVal2);
maxVal2 = max(filVal2);

switch flag
    case 1
        % intervals of equal length of filtration value
        lengthOfInterval1 = (maxVal1-minVal1)/((nbInterval1-1)*(1-overlap)+1);
        lengthOfInterval2 = (maxVal2-minVal2)/((nbInterval2-1)*(1-overlap)+1);
        
        start1 = minVal1;
        finish1 = start1 + lengthOfInterval1;
        
        
        
        for i = 1:nbInterval1
            
            start2 = minVal2;
            finish2 = start2 + lengthOfInterval2;
            for j = 1:nbInterval2
                
                filIdx(:,(i-1)*nbInterval1+j) = ((filVal1 >= start1) & (filVal1 <= finish1) & (filVal2 >= start2) & (filVal2 <= finish2));
                start2 = finish2  - lengthOfInterval2 * overlap;
                finish2 = start2 + lengthOfInterval2;
                if finish2 > maxVal2
                    finish2 = maxVal2;
                end
            end
                       
            start1 = finish1  - lengthOfInterval1 * overlap;
            finish1 = start1 + lengthOfInterval1;
            
            if finish1 > maxVal1
                finish1 = maxVal1;
            end
        end
        
        

    case 2
        % statistically derived intervals
        lengthOfInterval1 = 1/((nbInterval1-1)*(1-overlap)+1);
        lengthOfInterval2 = 1/((nbInterval2-1)*(1-overlap)+1);

        start1 = 0;
        finish1 = lengthOfInterval1;
        
        filVal1Bin = zeros(nbInterval1,2);
                
        for i = 1:nbInterval1
            filVal1Bin(i,1) = quantile(filVal1,start1);
            filVal1Bin(i,2) = quantile(filVal1,finish1);
            
            start1 = finish1  - lengthOfInterval1 * overlap;
            finish1 = start1 + lengthOfInterval1;
            if finish1 > 1
                finish1 = 1;
            end
        end
        
        start2 = 0;
        finish2 = lengthOfInterval2;
        
        filVal2Bin = zeros(nbInterval2,2);

        for i = 1:nbInterval2
            filVal2Bin(i,1) = quantile(filVal2,start2);
            filVal2Bin(i,2) = quantile(filVal2,finish2);
            
            start2 = finish2  - lengthOfInterval2 * overlap;
            finish2 = start2 + lengthOfInterval2;
            if finish2 > 1
                finish2 = 1;
            end
        end
        
        for i = 1:nbInterval1
            
            for j = 1:nbInterval2
                
                filIdx(:,(i-1)*nbInterval2+j) = (filVal1 >= filVal1Bin(i,1)) & (filVal1 <= filVal1Bin(i,2)) & (filVal2 >= filVal2Bin(j,1)) & (filVal2 <= filVal2Bin(j,2));
                
            end
            
        end
        
end
disp('-----------------  filtration value calculation done ------------------');

end

