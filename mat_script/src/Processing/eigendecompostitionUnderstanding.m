%% interpretation 1
% interpretation of eigendecompostion of matrix while treating matrix as 
% transformation matrix in space. Taking 2D as an example.


T = [2,1;1,2]; % transformation matrix; linear projection in R2

[v,l] = eig(T); % v: eigenvector; l: lamda eigenvalues



x = -10:10;
y = -10:10;
[x,y] = meshgrid(x,y);

figure(1);
grid on;

% axis of 2D dimension
figure(1);plot([-12,12],[0,0],'b-')
figure(1);plot([0,0],[-12,12],'b-')


% original points
point = [x(:),y(:)]'; 
figure(1),scatter(x(:),y(:),'.');


% points achieved by transformation T
tpoint = T*point;
figure(1),hold on; scatter(tpoint(1,:),tpoint(2,:),'or')

% the direction of eigenvectors of transformation matrix T
figure(1);plot([-15*v(1,1),15*v(1,1)],[-15*v(2,1),15*v(2,1)],'r-')
figure(1);plot([-45*v(1,2),45*v(1,2)],[-45*v(2,2),45*v(2,2)],'r-')

% One interesting point: if we treat the original points (blue dots) as the
% end points of vectors, the ones which lay on the direction of 
% eigenvectors of the transformation matrix T (red line) are only scaled by
% the corresponding eigenvalues without changes on the direction.


% transformed original x and y axises.
yaxisPoint = [0 0;-10,10];
yaxisPointTran = T*yaxisPoint;
figure(1),plot(yaxisPointTran(1,:),yaxisPointTran(2,:),'c-')
xaxisPoint = [-10,10;0 0];
xaxisPointTran = T*xaxisPoint;
figure(1),plot(xaxisPointTran(1,:),xaxisPointTran(2,:),'c-')



%% interpretation 2
% singular value decompostion on data set; 2D points as an example
clear
x = 2*randn(1,1000);
y = 8*randn(1,1000);
points = [x;y];
tpoints = [2,1;0.5,1]*points;
figure(2),hold on;grid on;
scatter(tpoints(1,:),tpoints(2,:),'.');


[U,S,V] = svd(tpoints);
eigenvector = U;
plot([0,10*eigenvector(1,1)],[0,10*eigenvector(1,2)],'r-');
plot([0,10*eigenvector(2,1)],[0,10*eigenvector(2,2)],'r-');





















