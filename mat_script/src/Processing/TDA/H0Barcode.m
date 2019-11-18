function [ interval ] = H0Barcode( interval,nb_interval_display )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    [nb_interval_display,~] = size(interval);
end

interval = [interval,interval(:,3)-interval(:,2)];
interval = sortrows(interval,4);
[r,~] = size(interval);

figure,hold on;
for i = r:-1:r-nb_interval_display+1
    p1 = [interval(i,2),interval(i,3)];
    p2 = [i,i];
    plot(p1,p2,'LineWidth',3);
end
interval = sortrows(interval,-4);
set(gca, 'YTick',1:r, 'YTickLabel',num2str(interval(:,1)),'fontsize',5);

grid on;
hold off;
title('H0 Barcode');
% set(gca, 'fontsize',18);



ma = max([interval(:,2);interval(:,3)]);
mi = min([interval(:,2);interval(:,3)]);

figure,hold on;
scatter(interval(:,2),interval(:,3),'or');
plot([mi,ma],[mi,ma],'b','LineWidth',3);
axis([mi,ma,mi,ma]);


grid on;
hold off;
title('Persistance Diagram');


end

