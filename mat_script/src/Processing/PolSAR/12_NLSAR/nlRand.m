
function r = nlRand(M,N)
    r1 = rand(M,N);
    r2 = rand(M,N);
    
    r = sqrt(-2.*log(r1./max(max(r1))).*cos(2*pi.*r2./max(max(r2))));
end