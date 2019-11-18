function [ interval ] = tomato_barcode( interval,nb )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tt = interval(:,2:3);
ind = (tt == Inf);
tt(ind) = max(max(tt(~ind)))+1;
interval(:,2:3) = tt;


if nargin == 1 || nb ==0
    [r , ~] = size(interval);
else
    r = nb;
end
interval(:,4) = interval(:,2) - interval(:,3);
interval(:,5) = (interval(:,2) - interval(:,3)).*interval(:,2);



% % barcode all
% figure,
% hold on,
% temp = sortrows(interval,5);
% for i = 1:r
%     plot([temp(end+1-i,3),temp(end+1-i,2)],[i,i],'LineWidth',3);
% end
% grid on;
% set(gca, 'YTick',1:r, 'YTickLabel',num2str(temp(end:-1:end+1-r,1)),'fontsize',10);
% 
% 
% 
% ma = max([interval(:,2);interval(:,3)]);
% mi = min([interval(:,2);interval(:,3)]);
% 
% % persistent diagram all
% figure,hold on;
% scatter(interval(:,2).*interval(:,2),interval(:,3).*interval(:,2),'or');
% plot([mi,ma],[mi,ma],'b','LineWidth',3);
% % axis([mi,ma,mi,ma]);
% grid on;
% hold off;
% title('Persistance Diagram');
% 

% barcode connected
figure,
hold on,
temp = sortrows(interval,4);
for i = 1:r-1
    plot([temp(end-i,3),temp(end-i,2)],[i,i],'LineWidth',3);
end
grid on;
set(gca, 'YTick',1:r, 'YTickLabel',num2str(temp(end:-1:end+1-r,1)),'fontsize',10);
% title('density persistence')


ma = max([interval(:,2);interval(:,3)]);
mi = min([interval(:,2);interval(:,3)]);

% persistent diagram connected
figure,hold on;
scatter(interval(interval(:,3)~=0,2),interval(interval(:,3)~=0,3),'or','filled');
ma = max([interval(interval(:,3)~=0,2);interval(interval(:,3)~=0,3)]);
mi = min([interval(interval(:,3)~=0,2);interval(interval(:,3)~=0,3)]);
plot([mi,ma],[mi,ma],'b','LineWidth',3);
axis([mi,ma,mi,ma]);


grid on;
hold off;
title('Persistance Diagram');
end

