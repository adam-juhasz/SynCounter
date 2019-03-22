function [i, j, check, val] = findMaxCentr(i,j,IHClayer,circleSize)

check = true;
midMax = true;
while midMax
    values = zeros(3,3);
    for k = -1:1
        for l = -1:1
            [summa, ~] = calcSum(i+k,j+l,IHClayer,circleSize);
            values(k+2,l+2) = summa;
        end
    end
    if sum(sum(summa)) == 0
        midMax = false;
        check = false;
    end
    [~,a] = max(max(values,[],2));
    i = i + a-2;
    [~,b] = max(max(values));
    j = j + b-2;
    %disp([num2str(i) ' ' num2str(j)]);
    if a == b && a == 2
        midMax = false;
    end
end
val = values(2,2);
