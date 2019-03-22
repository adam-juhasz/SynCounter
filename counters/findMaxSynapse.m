function [i, j, val] = findMaxSynapse(I,i,j)

midMax = true;
while midMax
    values = zeros(3,3);
    for k = -1:1
        for l = -1:1
            %disp([num2str(i + k) ' ' num2str(j+l)])
            if (i+k) < 1 || (j+l) < 1
                midMax = false;
                i = 0;
                j = 0;
                break
            end
            values(k+2,l+2) = mean(mean(I(i+k,j+l)));
            %disp(values);
        end
    end
    val = mean(mean(values));
    if sum(sum(values)) == 0
        i = 0;
        j = 0;
        midMax = false;
    end
    if max(max(values)) == values(2,2)
        midMax = false;
        continue;
    end

    [~,a] = max(max(values,[],2));
    i = i + a-2;
    [~,b] = max(values(a,:));
    j = j + b-2;
    %disp([num2str(a) ' ' num2str(b)]);
    
    if a == b && a == 2
        midMax = false;
    end
end