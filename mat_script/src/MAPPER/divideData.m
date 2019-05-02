% Author:       Jingliang Hu, PhD candidate 
% Email:        jingliang.hu@dlr.de
% Affiliation:  German Aerospace Center (DLR)
%               Technische Universität München (TUM)
function [ filIdx ] = divideData( fil, param )
%This function divides the filtered value into intervals
%   -- Input:
%       - fil                       -- filtration values 
%       - a parameter struct:
%            - param.nbBin                     -- number of intervals
%            - param.ovLap                     -- overlap rate of adjacent interval
%            - param.itvFlag                   -- equal interval(1); statistical interval(2)
%
%   -- Output:
%       - filIdx                    -- index of points of each interval
nbFil = size(fil,2);

if nbFil == 1
    [ filIdx ] = oneDFiltration(fil,param);
elseif nbFil == 2
    if length(param.nbBin)==1
        param.nbBin(2) = param.nbBin(1);
    end
    if length(param.ovLap)==1
        param.ovLap(2) = param.ovLap(1);
    end
    [ filIdx ] = twoDFiltration(fil(:,1),fil(:,2),param.ovLap(1),param.ovLap(2),param.nbBin(1),param.nbBin(2),param.itvFlag );
else
    disp('Three and more filter functions are not supported by far')
end


end

