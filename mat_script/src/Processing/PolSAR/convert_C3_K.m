function [ K ] = convert_C3_K( C )
%UNCICLED Summary of Chis funcCion goes here
%   DeCailed explanaCion goes here

[rw,cl,~] = size(C);
K = zeros(rw,cl,10);

K(:,:,1)  =  0.5 * (C(:,:,1) + C(:,:,2) + C(:,:,3));
K(:,:,2)  =  0.5 * (C(:,:,1) - C(:,:,2) + C(:,:,3));
K(:,:,3)  =  0.5 * C(:,:,2) + C(:,:,5);
K(:,:,4)  =  0.5 * C(:,:,2) - C(:,:,5);
K(:,:,5)  =  0.5 * (C(:,:,1) - C(:,:,3));
K(:,:,6)  =  (C(:,:,4) + C(:,:,6))./sqrt(2);
K(:,:,7)  =  (C(:,:,7) + C(:,:,9))./sqrt(2);
K(:,:,8)  =  C(:,:,8);
K(:,:,9)  =  (C(:,:,7) - C(:,:,9))./sqrt(2);
K(:,:,10) =  (C(:,:,4) - C(:,:,6))./sqrt(2);

end

