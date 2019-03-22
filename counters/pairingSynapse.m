function [pairs, valRed] = pairingSynapse(red,green)

pairs = [];
thVals = [2 5 10];
count = 1;
valRed = [];
for k = 1:numel(thVals)
    distTh = thVals(k);
    %disp(distTh);
    for i = 1:size(green,1)
        if green(i,1) > 0
            vicinity = red(red(:,1) >= (green(i,1)-1) & red(:,1) <= (green(i,1)+1),:);
            dist = (vicinity(:,2)-green(i,2)).^2 + (vicinity(:,3)-green(i,3)).^2;
            if min(dist) <= distTh
                [~, idx] = min(dist);
                [~, index]=ismember(vicinity(idx,:),red,'rows');
                vicinity2 = green(green(:,1) >= (red(index,1)-1) & green(:,1) <= (red(index,1)+1),:);
                dist2 = (vicinity2(:,2)-red(index,2)).^2 + (vicinity2(:,3)-red(index,3)).^2;
                
                [~, idx] = min(dist2);
                [~, index2]=ismember(vicinity2(idx,:),green,'rows');
                if index2 == i
                    %disp(count);
                    count = count +1;
                    pairs = [pairs; [(green(i,1) + red(index,1))/2 round((green(i,2:3) + red(index,2:3))/2)]];
                    green(i,1) = green(i,1)*(-1);
                    valRed = [valRed; red(index,:)];
                    red(index,1) = red(index,1)*(-1);
                    
                end
                
            end
        end
    end
end