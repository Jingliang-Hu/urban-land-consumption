function [ cv_C, cv_G, acc ] = kenelPar_linear( labels,data,folds )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% c=10.^(-2:4);
% g=2.^(-3:1:4);
% [C,gamma] = meshgrid(1:5:20, 1:5);
[C,gamma] = meshgrid(-2:4, -3:1:4);


cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain2(labels, data, ...
                    sprintf('-c %f -g %f -v %d -q', 10^C(i), 10^gamma(i), folds));
    display(sprintf('%f percent done \n',i*100/numel(C)));
end

[~,idx] = max(cv_acc);

cv_C = 10^C(idx);
cv_G = 2^gamma(idx);
acc =reshape(cv_acc,size(C));

figure,
contour(C, gamma, reshape(cv_acc,size(C))), colorbar
hold on
plot(C(idx), gamma(idx), 'rx')
text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
    'HorizontalAlign','left', 'VerticalAlign','top')
hold off
xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy');

end

