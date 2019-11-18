function [ clusters ] = polsarCompareClustering( polsar,flag )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

[r,c,~] = size(polsar);
switch flag
    case 'C3'
        compare = [...  HH, HV, VV      (1: min; 2: max)
                        
                        1,  0,  2;... HH < HV < VV
                        1,  2,  0;... HH < VV < HV
                        2,  1,  0;... HV < VV < HH
                        0,  1,  2;... HV < HH < VV
                        2,  0,  1;... VV < HV < HH                        
                        0,  2,  1;... VV < HH < HV
                            ];
         
        temp = polsar(:,:,1:3);
        code = (repmat(min(temp,[],3),1,1,3) == temp);
        code = 2*(repmat(max(temp,[],3),1,1,3) == temp)+code;
        
        [nb_cluster,~] = size(compare);
        clusters = zeros(r,c);
        for i = 1:nb_cluster
            clusters = ( sum( code == repmat(reshape(compare(i,:),1,1,3),r,c,1),3) == 3) * i + clusters;
        end
        
        
    case 'T3'
        polsar = convert_T3_C3(polsar);
        compare = [...  HH, HV, VV      (1: min; 2: max)
                        
                        1,  0,  2;... HH < HV < VV
                        1,  2,  0;... HH < VV < HV
                        2,  1,  0;... HV < VV < HH
                        0,  1,  2;... HV < HH < VV
                        2,  0,  1;... VV < HV < HH                        
                        0,  2,  1;... VV < HH < HV
                            ];
         
        temp = polsar(:,:,1:3);
        code = (repmat(min(temp,[],3),1,1,3) == temp);
        code = 2*(repmat(max(temp,[],3),1,1,3) == temp)+code;
        
        [nb_cluster,~] = size(compare);
        clusters = zeros(r,c);
        for i = 1:nb_cluster
            clusters = ( sum( code == repmat(reshape(compare(i,:),1,1,3),r,c,1),3) == 3) * i + clusters;
        end
        
    case 'K'
        % to be constructed
        
    case 'H'
        [r,c,d] = size(polsar);
        largeNum = max(polsar(:))+100;
        clusters = zeros(r,c,d);
        for i = 1:d
            clusters = clusters + (repmat(min(polsar,[],3),1,1,d) == polsar) * i;
            polsar(clusters==i) = largeNum;
        end
    otherwise
        clusters = 0;
        disp('--- flag is not correct ---');
end




end

