function [ cv_C, cv_acc ] = linearSVMPar( labels,data,folds )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% c=2.^(-2:4);
% g=2.^(-3:1:4);
% [C,gamma] = meshgrid(1:5:20, 1:5);
% [C,gamma] = meshgrid(-2:4, -3:1:4);
C = -4:4;

cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain2(labels, data, ...
                    sprintf('-c %f -t %f -v %d -q', 10^C(i), 0, folds));
%     display(sprintf('%f percent done \n',i*100/numel(C)));
end

[~,idx] = max(cv_acc);

cv_C = 10^C(idx);


% figure,
% plot(cv_acc);grid on;
% xlabel('log_1_0(C)'), ylabel('Acc'), title('Cross-Validation Accuracy');

end

