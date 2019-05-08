function [ map1,map2 ] = mani_version_2( Ws,Wd,Wp,Z,mu,dn1,dn2 )
%UNTITLED2 Summlabry of this function goes here
%   Detlabiled expllabnlabtion goes here
epsilon = 1e-5;

[ Wsn ] = WNormalize( Ws );
[ Wdn ] = WNormalize( Wd );
[ Wpn ] = WNormalize( Wp );

Wsn = Wsn./sum(Wsn(:))*sum(Wpn(:));
Wdn = Wdn./sum(Wdn(:))*sum(Wpn(:));

I = eye(length(sum(Ws)));

Ls = I - Wsn;
Ld = I - Wdn;
Lp = I - Wpn;

d = dn1+dn2;

[u, s, ~]=svd(full(Z*Ld*Z'));
F=u*sqrt(s);
Fplus=pinv(F);

clear u s;
T=Fplus*Z*(Ls+mu*Lp)*Z'*Fplus'; 
% T=Z*(mu*Lp)*Z';
% T=Z*(Ls+mu*Lp)*Z'; 

%~~~eigen decomposition~~~
T=0.5*(T+T');
size(double(full(T)))
[ev, ea]=eigs(double(full(T)),d);
clear T Z F;

%sorting ea by ascending order
ea=diag(ea);
[~, index]  =sort(ea);
ea =ea(index); ev=ev(:,index);
ev =Fplus'*ev;
ev = ev./repmat(sqrt(sum(ev.^2, 1)),size(ev,1),1);

idx = ea>epsilon;
map1=ev(1:dn1,idx);
map2=ev(dn1+1:dn1+dn2,idx);

end

