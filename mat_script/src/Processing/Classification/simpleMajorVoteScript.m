

claTemp = claMap_fullhsi_SVM400(mask);
segTemp = segmentsFlevoland(mask);

res = zeros(size(segTemp));

for i = min(segTemp(:)):max(segTemp(:))
    temp = claTemp(segTemp==i);
    p = 0;
    j = 1;
    while p < 0.5 && j < length(temp)
        ptemp = sum(temp == temp(j))/length(temp);
        j = j + 1;
        if ptemp > p
            p = ptemp;
            res(segTemp == i ) = temp(j);
        end
    end
end


f = zeros(size(claMap_fullhsi_SVM400));
f(mask) = res;