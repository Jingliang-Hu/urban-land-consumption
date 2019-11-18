% % chol = calloc(D * D, sizeof(float complex));
% %   chol[0] = 1;
% %   for (k = 1; k < D; ++k)
% %     {
% %       a = 0;
% %       for (l = 0; l <= k - 2; ++l)
% % 	{
% % 	  chol[l + D * k] = chol[l + D * (k-1)];
% % 	  a += chol[l + D * k] * chol[l + D * k];
% % 	}
% %       chol[(k-1) + D * k] = (rho - a) / chol[(k-1) + D * (k-1)];
% %       a += chol[(k-1) + D * k] * chol[(k-1) + D * k];
% %       chol[k + D * k] = sqrtf(1 - a);
% %     }


M = 256;
N = 256;
D = 9; 
L = 1;
rho = 0.95;



chol = zeros( D , D );
chol(1,1) = 1;
for k = 2:D
    a = 0;
    
    for l = 1:k-2
        chol(k,l) = chol(k-1,l);
        a = a+chol(k,l)*chol(k,l);
    end
   
    chol(k,k-1) = (0.95-a)/chol(k-1,k-1);
    a = a+chol(k,k-1)*chol(k,k-1);
    chol(k,k) = sqrt(1-a);
    
end