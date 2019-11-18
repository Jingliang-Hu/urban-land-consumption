M = 256;
N = 256;
D = 3;
rho = 0.95;


chol = zeros( D , D );
chol(1,1) = 1;
for k = 2:D
    a = 0;
    
    for l = 1:k-2
        chol(k,l) = chol(k-1,l);
        a = a+chol(k,l)*chol(k,l);
    end
   
    chol(k,k-1) = (rho-a)/chol(k-1,k-1);
    a = a+chol(k,k-1)*chol(k,k-1);
    chol(k,k) = sqrt(1-a);
    
end