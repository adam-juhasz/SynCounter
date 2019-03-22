function [summa, pixNum] = calcSum(i,j,IHClayer,circleSize)
summa = 0;
pixNum = 0;
for k = (i-circleSize):(i+circleSize)
    for l = (j-circleSize):(j+circleSize)
        dist = sqrt((i-k)^2+(j-l)^2);
        if dist > 50
            continue;
        elseif k < 1 || l < 1 || k > size(IHClayer,1) || l > size(IHClayer,2)
            pixNum = pixNum + 1;
            continue;
        else
            summa = summa + IHClayer(k,l);
            pixNum = pixNum + 1;
        end
    end
end